Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D86F60F8
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKITCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:02:13 -0500
Received: from mout.gmx.net ([212.227.15.15]:42585 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfKITCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 14:02:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573326040;
        bh=JVZl8W/9+KNx/j1P/L1YRs6FPMBmOMu1UabPhPEYHhk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DzQZLIz11T7B0jcpKMacTWNzT9xT9IJVM7VzKQz80cPYIi5oj0v/xhbcTADaPNBku
         eTntYI1c0nTMjAyVEKCx/iatQK0GsBh3Ne53zLMyf7RupV8rAEsv0goL+Lwd1FQYDo
         UK6sHj1gdc2RwVnsRY/2iGrdZkmC55Qi/e5auU6w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MaJ3n-1iNrBy3naH-00WDmc; Sat, 09 Nov 2019 20:00:40 +0100
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
Subject: [PATCH V3 net-next 3/7] dt-bindings: net: bcmgenet: Add BCM2711 support
Date:   Sat,  9 Nov 2019 20:00:05 +0100
Message-Id: <1573326009-2275-4-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
References: <1573326009-2275-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:pwOME3b6oWQDA7hj+VvM3FemGnxDGMVtUsrmvUWBojPjbsUJj5g
 300M716nvIH+/zzW6V95lzzIdameXkzy+65nxaA75HdvSqLrcJ2yZnwSz7FA1wfFpen+iQH
 tky3K6sTWcon0UzYKedln4kAsK8ye8zgkz9Hqpg4yb3xyM3Fk/zpM+a4O2QFOnMprCq0r1V
 BQN3WJ3jsfL9CLL4aRf0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KGhR4dW8DD4=:Ia2jekfGARc0JTClwjuthO
 Ggbca56CYDzUGE4+duwBPhXaaHf1RBeXFkdLcC3OaenVxeQ8lxnJgKLkZb1wmzpHZtNhXJgns
 jAUtGBK1aFiyazU3OPEAWh/zpQcI3kavjFedgFdmP4E3bhFF7aY5GemASALMGiNEC0ro67nzn
 OZSgGl7b0nAxzgwdZAody3dipOLABhxh9Vt5EH4PAnHh/riFe6ywP3Ezp2MOFlJ+zihhTiw5M
 h9q32ulShIW8c/dMTLZNog1pAZvGDFyieYjOiNajKCjnktVEnPk+Sguaelc6qD3+8bi+RImYL
 LpDHCRZUslUbawDEEXVuzpZxMwF2QhLhG0A74fkyGvsSk3Zw098XalWDPKh6Ce5kXmvtwN5PS
 bIKGepNUzZhMWdvSXHNVvWvSK/xbSUY4PnzNsgmBx6Mw1lOpxYvU7EUsLRDd8pwHthuG1ZDVA
 HzmeY1NIjsOGhsON9/ZmiJkhEDeh2VwWg5mqbQ7KGm4VpgTJUvgA+Z6cqSkf3VfyrDbcyhG1c
 ig65fhzxN/sQXtT2Ykl/z2jclURcPWEnEQvfchloqVpbPpan3vk0YlExdDk7xbLpxY7cIMc/4
 XnqS5+1M5njW5tNVy1rqFD8H09aGuzgjbDzykBsSHE6pN/jsSscn8ZAgqBx/jiIK3OaxMz0aO
 Ea3+t6NJA6VIJoLJjp2tz8uOOKKG3uERMrH5T/q1BRjNk1Kyb8Y+90AwRFUO5WG0yxqoW57a+
 GpYkZTldT/7noge/ElaTZp6KhBzHAc9YvLOo9yCoNuLCNYf0++otADT5fTSVM5StNF6gUFkga
 lwbsWcy5SCD4HFOK1OxxxRZ/pNHvxwa38razR/LW5Vu0zL8DpnNKRaUmjzLI8IQsP8b8UlIzQ
 gO5qcl7OZkjczFnZoxy4jQOrKxYbldepKHE74KK1bTBOR//si0ZEwj04h6GJbpMHpbR6q5JQe
 c33egWAWEKg08DvrzOd8fzPU3XQq52uPtmkzGzFe76+bbfeqPZ3jpBZzE0tngumXQ4pgMANkB
 IZ5Gw9k+IpY2UzE+LBwbxUM8WmI6/QvnihmhE6YRX1yyFGCT5k1tj8madseyz9FUTqkt1rxqz
 LLy3R5P/UMN1dlHfQVDbIPp/8YLODD91babv8SPolH5oZvM/KmjU2WgJn+YF3z+sbCdyh8DJV
 SKDGvx0e6vyeK01WtQbjcV7PIMaBtnvbftgzRhRMNIJZApR4tbqbBqMVxm8/Pm5QzXsUh7RiZ
 bCuM8wEp0xQXviYILNDj/NljX20pU72FLq8NOPg==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM2711 has some modifications to the GENET v5. So add this SoC
specific compatible.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
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

