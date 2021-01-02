Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058912E88B4
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 22:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbhABVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 16:40:27 -0500
Received: from mout.gmx.net ([212.227.17.20]:35967 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbhABVk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Jan 2021 16:40:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1609623524;
        bh=65567gUH7pUHimFSswoUGu6z3nW5+V9kc46kQAId9N4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ej5yzO6CH8gNBebs9HfL9+8YE+7Q13c+sMeyoLDY3kgcXCDYN6zkKxcCTpvm79/OU
         3fk4PrjWItjybUQYuV+vF8atqWXoCOs7X78qBM1T3V+3bNqYSfTCmDq2E38H44fuU8
         f5HhzpYar4pbwCPRQg/5ER45XHMo1E85EYycQVhY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from MockUp.fritz.box ([77.10.124.214]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVN6t-1kXEN12R0B-00SRzQ; Sat, 02
 Jan 2021 22:38:44 +0100
From:   John-Eric Kamps <johnny86@gmx.de>
To:     johnny86@gmx.de
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: bluetooth: Add rtl8723ds-bluetooth
Date:   Sat,  2 Jan 2021 22:38:03 +0100
Message-Id: <20210102213803.1097624-1-johnny86@gmx.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LWF8OuNmTyzpbAEXamaZ+sJkA01ya1CV9Q4Dc7m/k3CO62xeWg9
 clVbhNxjRwqnO3cjcxpjR+3GRmNycTZaY6dpM7x9WRaSdRnCQERww/UVKddFEWJI/nrCVqo
 CX0E09lW5VFqa+udcwTara9RK/JT07YX6WknNTqfqBcDgFTV06vH1HLdIkWbokQ2jIG0P66
 l4Jgc9YAkABdkhFj8IHRw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ngujCwQuwgI=:4780t0qPnaeuBqssShDwcD
 apIGkLwc4AXQY9p1cmRMigZ4cOogrYX7kj/CxNTUFDma7hqROlvSw5ufOQBWZGuJnI1KA39vA
 n91VbylS6bsRmSJvvxyj4+ojE+J9Ao/OV+hZqpxDxjXe0sGqkJca/ACcp89Dj0R3pKNNgvcu4
 1+wjVDGwAoWC8NJGfEVSBobALYsqio/HAq5YVKcbC6x6AZ4/vmlw1/gIXkbx2eUNMlY8WqjF6
 D1DdE8IoQHfvnYhQMkYf1skrpAG/U6S5DRMbtjypEQjqNF/hW2AQNzKHG85iCiSG4U9MOOyNW
 0dwPiI8mfU7F2amFN9FX86Hb60Ve5HJPCkLhUX1+jQOymQ2BMLRYs6US4flh9kGF2osPTIoAN
 li362gbge+6kI23Wx70YYqbhsxAz77Ulsxf6K5OSduOZLcBKe2waCqi9S+TPD9mLGkkiK0sYz
 MHYRVavLU518CB+S8t2U4Jm1g0HcjLQMiQd1ZBFU1q9JtgLi3DXKJnAOoHugvpXr48g8gzHkg
 j8AnOk/1STeVbrPlz17duLbKP42+gwGNLFYdhlSxF6MuJauyGDIKlgOE1BI2fgw1OhhmY6SIb
 x3x21u8A30Z0Hg9kD9Em7w4tAVB1ESyQ2dBpEu6jclsYtNZ4Uy9Yv8Q4zLaboEgw42XrXbG5g
 7CiOkRPT4j30YBQBpsOgSFg7B+MmmDEiSUnj3b0tIwY/rtbWt4AM2Ywwq8ix6aBS7jKf6jJry
 Q8k5t54OVE/LRN7lVxqBAESml+ERl8w/20sy7J72uA+POSMX8UdHX2BuugYtEB/LmprSxgRAk
 poGn59W0wp7wHZ1yZz4oulncmvm3UeG9c6p9oYy7rLs/5Mp/o13haq36U1PI53KDj1heyx7RS
 1QC51pCvIvLef1S09XXA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding documentation for bluetooth part of RTL8723DS

Signed-off-by: John-Eric Kamps <johnny86@gmx.de>
=2D--
 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml =
b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 4f485df69ac3..3cc21dc056e0 100644
=2D-- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -4,14 +4,14 @@
 $id: http://devicetree.org/schemas/net/realtek-bluetooth.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#

-title: RTL8723BS/RTL8723CS/RTL8822CS Bluetooth Device Tree Bindings
+title: RTL8723BS/RTL8723CS/RTL8723DS/RTL8822CS Bluetooth Device Tree Bind=
ings

 maintainers:
   - Vasily Khoruzhick <anarsoul@gmail.com>
   - Alistair Francis <alistair@alistair23.me>

 description:
-  RTL8723CS/RTL8723CS/RTL8822CS is WiFi + BT chip. WiFi part is connected=
 over
+  RTL8723CS/RTL8723CS/RTL8723DS/RTL8822CS is WiFi + BT chip. WiFi part is=
 connected over
   SDIO, while BT is connected over serial. It speaks H5 protocol with few
   extra commands to upload firmware and change module speed.

@@ -20,6 +20,7 @@ properties:
     oneOf:
       - const: "realtek,rtl8723bs-bt"
       - const: "realtek,rtl8723cs-bt"
+      - const: "realtek,rtl8723ds-bt"
       - const: "realtek,rtl8822cs-bt"

   device-wake-gpios:
=2D-
2.25.1

