Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3514237FF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhJFGdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:33:12 -0400
Received: from mout.perfora.net ([74.208.4.196]:38059 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhJFGdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 02:33:08 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Mdb8U-1m8fZp1vpc-00POao;
 Wed, 06 Oct 2021 08:31:09 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     netdev@vger.kernel.org
Cc:     Marcel Ziswiler <marcel@ziswiler.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dt-bindings: net: dsa: marvell: fix compatible in example
Date:   Wed,  6 Oct 2021 08:31:04 +0200
Message-Id: <20211006063104.351685-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:bwPCWM1KaDIOapc+svZsmpskDbmtCqqnbkTEsB8xCAKanMgObpa
 f2AQ3NzvczTc8Icmnlj3KkxzCp54/qw4oFw9R+YxWrKxtqGHdw5sIqnknaPvRTeteXQklSN
 +60cq3Ccw2BH9T1dNv4tdUIl4vS1aMhbyZQBLX6o1ViGV6sTlQimHP/4y0Yz9AJof823kYd
 OjZe3cxo9tKdmEDAYKWJA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2A6y0lpMwT4=:SU/m/q6gKPnnAZJhzhZwey
 TByeEFbUNV+tJOvCuY6bxoIFEzEPyixwVMznLOItUngbKWD2LX/u36ErV2ORZADr2cSJhHZDz
 O4Yjiq8jVkvILayvfn6qpdHQqEj2qQw0dkpSNBDidpMgaR6pyLHpEj02PAbIYTcLSgmp5l/lQ
 97mtSjR9/198dzuqsKH9u8fpgh19WEEXl20+O/ocmiZhbjMREKYwSidGhSzAC2ScXQCLuEXOb
 VZSHMUX0szeNyrHxvpRsWPbW4Mwa9FR+p8ZSXKTPr6TbEEwxtD+QwVb88NfNCjfW+uvV5+C/n
 rW64P0yvO0rxHZba9eN8YaA85fj0vZDWAvxz5IFAn1ywmQCVNUX4FoAjUyoGHneYO5I+jLgSs
 /LHkIww0N0fv8TnA9Hn2ILzTH7lDUihGEdsMR+R+hXj22Vqnz1O43UPM6AkUxwjkqtt9WBOxH
 DbJobBruY0LRzK1mRHsRE71KSxTzVlaJzQ5z+5dvOiuTR3n+3qo2i/eQLVh0z3sle5jqyjnvl
 4uGXQOxVEy29ZxcZHSisA2gmKldtWBqcpgnqx92Lnm9ojsntYE/Dh2ed2lr6LJ3o7qaSyvxpS
 1f1edntvkkvSc42hGLE2MYhifG5yykqk2RB7S7g+e/ozjhR2zKYPaRQF4MmzgTJQzuXJJxwHf
 5ovZ5KqGfP/AOs+3SG2QtwNhnIHtFa/GMb2auUBVRV5v6usIYOavKHy3qvnUVGCKca4nJViy2
 aVjSwKAvjNGaY+UiEhBV8i79KTAzfApmmByPOw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the MV88E6390 switch chip exists, one is supposed to use a
compatible of "marvell,mv88e6190" for it. Fix this in the given example.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---

Changes in v2:
- Add fixes tag, Andrew's reviewed-by and separately send to netdev
  mailing list.

 Documentation/devicetree/bindings/net/dsa/marvell.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 30c11fea491bd..2363b412410c3 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -83,7 +83,7 @@ Example:
 		#interrupt-cells = <2>;
 
 		switch0: switch@0 {
-			compatible = "marvell,mv88e6390";
+			compatible = "marvell,mv88e6190";
 			reg = <0>;
 			reset-gpios = <&gpio5 1 GPIO_ACTIVE_LOW>;
 
-- 
2.26.2

