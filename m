Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89327F6ECA
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKKG5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:57:42 -0500
Received: from mout.gmx.net ([212.227.15.15]:39235 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfKKG5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 01:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573455362;
        bh=jyAikbVVRrPYgn/XSwbrVXcnTYEvKUjvXNC1/tigGeU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=C72sYSAFQFl3by4zU3weGmJQkmCfe3varVCoZL4nL9viiLliVOiFmChUGJnwmZ/05
         7pqZKncEzkCtiG4+bfvwOCuoVCPXue8d8Mz8L2jWI3uF0O7mH83NWI1pxMqC6JaqUX
         8ECWp2fkA+fe2VK4d4DLQvxdE+plYGu31j6gV01Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MGQjH-1ifwGV0InN-00Gsly; Mon, 11 Nov 2019 07:56:02 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V4 net-next 3/7] dt-bindings: net: bcmgenet: Add BCM2711 support
Date:   Mon, 11 Nov 2019 07:55:37 +0100
Message-Id: <1573455341-22813-4-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
References: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:2hB5ao/GcCOJ/sp3SAl2oL4SCzxVLtXCrSYNQ6upR9E0WsjjTdc
 ZO9EsdDfYGZI95Si0y4UmUMsaX8xzliUlOaUh69kRJqpSRtxJ1Qp3JzINmLC2+PCWyHZbz/
 0gxpPQIbnwLRtsF9kn/MmycDAZjey4tfyxbLOhNrf+veEESSxVCgKOaIwHOCo4pSwQkY2Lh
 33+ieyYe4X1c+YdZCZWIg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qWyXgYi9gYc=:lW3bEoSyQQZxKO8G9+DPdJ
 A/pnMjwBwOYGMnvIGXQ1StodIBbG9PnEd489MYVpLjzRuAgL9zYliaQG2CusQuJwZ3yWR+20H
 kYTwBcCRI0Ru2r5j4mZqFZ60JCuNFimHOeVLQsMgH4dFhf21R5hVEDDL2TGHY+3cCGy+IYrg2
 FEqtusPbdI39WX6TrMn+bYZ4c9LhQtI0X/CZKyAx+3/MS4TbH40ZWOvqph+6MpsAa76YtK4vV
 TRak/d3cNq/TQdvnFzSV+Kv1cYaVyPEP2oK5lMJQgUNiiPlxG+SWg/UhZ8ZqaLBHhLESMp1hj
 TQ+DxJfGKwEfsoh+7YoeLhO1xpgCwwf+cvJL/b2erq6KnuFpWn2dqLUxLlRJFdOLgAW82zA/0
 yMkTZOgNw1A4oFvHPvAdWQb37Pq39AlieD0Gehk+q+LXISiHisGZICvVjbBTl8tBBU7G2A3Sf
 WvJgtiXYtxMqtS4+qDf1I4sI4aDPN7TKf56H5oY+K3akNozjh70kHZZHAaaqLrk7bjF/QN6X1
 Zg8pvfp0OOn/5TlYiqsjz6HyvtgKYbyYKQ9XrLCXIYKR7Cw9CWkQZAzuduPfDtVskSTI4wCfF
 3vdwYAOHdmn0ZurGH7nDJZ7hKWHVEgzA0S4r82OBPj1jtapXN0g658xzafBTcS4yP3Kry/VJ0
 2DGQsXWuMOzR00ca+uUh9wrwq1BpzrS/VmjQ0h5y/SKFVxb1+8H2Q6qDZgR0A6nUhAbggmHm3
 ZM1OUp5khBXqF4d+jFIOM6hdj+7sIKht4sVK+dt3M+YFSCPIuYpQ6CZVTJOVw++vVTkzpVvuT
 wGfjCrneTik3GxiR4znhya372Jc79kIfbp4qNzDRh/+IEoSZ+0XTItB4XhK0+c9wXklIi+mtH
 nC4JBSZAs9Mt8/QWnqa8hCxY/oPo+gXM0DXpkZziDM8vGwck6dAhYgA0I1LWg8CmugxPkm1yg
 aUWVokm9J5e3Pv6pFewP1R/fDGf1ru3sIo6CxbCf8Tx5YNrI5D7Eg/WyWh5e2Mzmv8kjl3x+1
 AgHW79yYbhRlugV/SlmAmiajx6ca50H9avODGbhFl8e/5UlwK/vDCSAh7XX54GaOy+MUBOXV/
 1wZDFWEk1QEXXlTmTXag7pHQpSixmkA5YcOyyyRAQalmoXBzxqYNeJOPQodX2nfeh/z5f0H43
 4PUscjR7q1c6LzQtC8xeIdN264vK5lQ3/hbhrUD7RLYrmdt2D5wrJWytYn4igT+jVp240Keq1
 nCzPYldviO1dY44gWItmBEzWBRB/r9yhHobuXYQ==
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

