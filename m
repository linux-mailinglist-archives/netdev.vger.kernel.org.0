Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56EBAF8083
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfKKTvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:38 -0500
Received: from mout.gmx.net ([212.227.15.18]:48039 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfKKTvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501791;
        bh=jyAikbVVRrPYgn/XSwbrVXcnTYEvKUjvXNC1/tigGeU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=i/dlo/DUcvwxzGVktgQW99DJ2Vq+tJF6Cd2QGH1Ud0ws5cwuYr67vyCqFtqYfqVxt
         G7v/oy115FdmaJLyecIxDw/4nJYObyvHjJIHf/pcIIeVoAssAvTs+FoiWGecOkeF7x
         aAPAjHGANJEie+Zp2bt9+i077vRr/Yg+mIMHu0R4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MzhnH-1hhUek2jXl-00vdsF; Mon, 11 Nov 2019 20:49:51 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V5 net-next 3/7] dt-bindings: net: bcmgenet: Add BCM2711 support
Date:   Mon, 11 Nov 2019 20:49:22 +0100
Message-Id: <1573501766-21154-4-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:xBehJ0MPIR6kysFz74j6TneXJCtJsc8Ik14GvPjliUkZNbYE5eu
 se1t/umwYp46w7t9aSD9NTCBzsAd+4QG+tnUKdP/UpGT2RlHrzfj/Qrw8n5oxS7+gnscMdD
 UaWtdt7hCIvHSx0kxpSfA4vbH4trDFbPW5UkYhgL4C+y+CCboLoRLOiTS738Ct+MVogLK1A
 +EqmHZOIHj02BhcZn7IbQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aHNgqRhvbKQ=:1eqhjT4X88JxB5c8xm91rE
 txFPAcx26aPKZK74X8qLWqydluXMDviQ3StJ8WTgy5My/CKLihzvLfqrXbv0r2r8nJlGiWjkW
 5FCu5zSO3U9ebdi2KVwKr2OqvOYYm/u6rGrdgLXZXTRsQrDfKFN69El5r3veHh9xC5j2AqeGA
 tcqMzeiyXJ3UcZbJX4Er8tL27pg0LnaGAShqw7pjlw4XB5Yl5oK3hHUMdgPfhTpSPt6hNoBsD
 Jn1LmfbvgU+zNt2E2NQ3YJCXo57Oqaj+AnTw3aNiYxP+jiOI/JbsnZoDKvPfZzWQC+3cEavlB
 mNZ/hPFOF4CiSiD8B/YBZ09ND6TR6KinPVdCBD+KhYf5TaP8Ax3Le6CHHeLZUA1vgkHeQKZCm
 /VG9N226znsUQvyhpapIbp1vm5jG0u/Kytb58P/r32O493PG1du2XLGwiDfB1fsAG/CtTScN5
 cNjlIPzxHhspJXcu3IKLIB3cKDCaBegkqd5v+FAYL277Lb3UDdoGxdNNGbuMUQ121jW7NAP3x
 cHDsjOPNoMsgzlLKT9+S42goB0+qdZE1QZYlH+DL4M0HNypq5AaJ5Tw/Tl9CAh89lsl3YHXUH
 77bglIDa2QILjK4ep8iFeMRdGXa7C33KHNW5okQwKjx7pmngq8HeRloqT1V3Vo98QbDfDSi+O
 F3hM6/tw/AWlCVQpIpWczpaDeX2yGfiqCZUSzXfM9GrHyWH9Yz4PnfyukM3WUH3oQw8MwSt5Z
 4y2uLh+kH5laXhIScerz5eFJ8xK3jwb/JmAcw0hOlTQhkWFRnL9va3xF5LA1xRncatWzhtP5L
 GJZC/qAl/DsUsjkrXczdxIZmSPLj5qMSe5KPxEiO1G92bgSK5h9kzxQJAp7BYSRctAqieQdoI
 QQf8ltYr1Jt6wy0E79ZWP5m6VHBdKjO+siK5JSYipra1qv8RfOiqTIwUjXTm7gHnfQ0ETllPx
 PiOyO1DUT2zuWqwb6/D+pX5S1yL1FZHlERbUWouXsVpfJHXW+CS600AQ6MG9WiitIceCgi8Pl
 3WSe+IHTM2T9wULMTlLx2Y4uinmFoRIwqOuv8FIZ+YmNJK8hJcT39d4BfZa8Ad+TrO4eYG8H+
 pDzL19DHyT+eVQ9+dF6bMbLHyuWFp9GjX8J+yNa6OkAGNS8Vv/NPE8jDkTk+rLIFskgtKdzQW
 LyxAOZnuncaEDN4IZ4AHE9sFoB9Byzfq4TE6Shp7Xf5J/GGBcrYF2LKyvAnyE9Ll++Lm9Gfnq
 EJB1YuRp6X6H8ZKW36yDN0PL2BqM+5/uTii9UuA==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM2711 has some modifications to the GENET v5. So add this SoC
specific compatible.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
=2D--
 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt b/Doc=
umentation/devicetree/bindings/net/brcm,bcmgenet.txt
index 3956af1..33a0d67 100644
=2D-- a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
+++ b/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
@@ -2,7 +2,7 @@

 Required properties:
 - compatible: should contain one of "brcm,genet-v1", "brcm,genet-v2",
-  "brcm,genet-v3", "brcm,genet-v4", "brcm,genet-v5".
+  "brcm,genet-v3", "brcm,genet-v4", "brcm,genet-v5", "brcm,bcm2711-genet-=
v5".
 - reg: address and length of the register set for the device
 - interrupts and/or interrupts-extended: must be two cells, the first cel=
l
   is the general purpose interrupt line, while the second cell is the
=2D-
2.7.4

