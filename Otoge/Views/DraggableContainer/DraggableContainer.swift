//
//  DraggableContainer.swift
//  OtogeFinder
//
//  Created by Sen on 2024/4/27.
//

import SwiftUI

struct DraggableContainer<Content>: View where Content : View {
    let width: Double
    let height: Double
    
    @ObservedObject
    var keyboardHeight = KeyboardHeight()
    
    @ViewBuilder
    let content: () -> Content
    
    @State var positionX: CGFloat = 200
    @State var positionY: CGFloat = 300
    
    @State var previousDragValue: DragGesture.Value?
    @State var previousContainerY: CGFloat?
    
    @State var dragged = false
    
    @ViewBuilder
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray)
                        .frame(width: 48, height: 6)
                        .padding(.all, 8.0)
                        .padding(.vertical, 4.0)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 4)
                        )
                        .scaleEffect(dragged ? 1.3 : 1.0)
                        .animation(.smooth, value: dragged)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(
                        minimumDistance: 0.0,
                        coordinateSpace: .global
                    )
                    .onChanged { gesture in
                        let offset = CGSize(
                            width: gesture.location.x - (previousDragValue?.location.x ?? gesture.location.x),
                            height: gesture.location.y - (previousDragValue?.location.y ?? gesture.location.y)
                        )
                        
                        previousContainerY = nil
                        positionX = positionX + offset.width
                        positionY = positionY + offset.height
                        
                        dragged = true
                        previousDragValue = gesture
                    }
                        .onEnded { gesture in
                            dragged = false
                            previousDragValue = nil
                            let velocity = gesture.velocity
                            let maxTime = 0.5
                            let velocityMultiplier = 0.3
                            
                            withAnimation(.smooth(duration: maxTime)) {
                                positionX = positionX + (velocity.width * velocityMultiplier)
                                positionY = positionY + velocity.height * velocityMultiplier
                            } completion: {
                                repositionContainerIfNeeded(screenSize: geometry.size)
                            }
                        }
                )
                content()
            }
            .background(.thinMaterial)
            .frame(
                width: min(width, geometry.size.width - 8),
                height: height + 8 + 6
            )
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
            .position(x: positionX, y: positionY)
            .onAppear {
                positionX = width / 2 - geometry.safeAreaInsets.leading + 8
                positionY = geometry.size.height - (height / 2) + geometry.safeAreaInsets.bottom - 16
                repositionContainerIfNeeded(screenSize: geometry.size)
            }
            .onChange(of: geometry.size) { _, screenSize in
                repositionContainerIfNeeded(screenSize: screenSize)
            }
        }
    }
    
    func repositionContainerIfNeeded(screenSize: CGSize) {
        let width = min(width, screenSize.width - 8)
        let screenSize = CGSize(
            width: screenSize.width,
            height: screenSize.height - keyboardHeight.value / 2
        )
        
        var positionX = positionX
        var positionY = positionY
        
        if let previousContainerY {
            positionY = previousContainerY
            self.previousContainerY = nil
        }
        
        if positionX > (screenSize.width - width/2 - 4) {
            positionX = screenSize.width - width/2 - 4
        }
        
        if positionY > (screenSize.height + height / 2 - 64) {
            previousContainerY = positionY
            positionY = screenSize.height + height / 2 - 64
        }
        
        if positionX < (0 + width/2 + 4) {
            positionX = 0 + width/2 + 4
        }
        
        if positionY < (0 + height/2 + 4) {
            positionY = 0 + height/2 + 4
        }
        
        withAnimation(.bouncy) {
            self.positionX = positionX
            self.positionY = positionY
        }
    }
}

#Preview {
    DraggableContainer(width: 200, height: 300) {
        Rectangle()
        .fill(.green)
    }
}
