Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3640421EA2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhJEGFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:05:53 -0400
Received: from mout.perfora.net ([74.208.4.197]:37485 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231752AbhJEGFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:05:48 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M87rr-1mkN9P3L2P-00vham;
 Tue, 05 Oct 2021 08:03:47 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 1/4] dt-bindings: net: dsa: marvell: fix compatible in example
Date:   Tue,  5 Oct 2021 08:03:31 +0200
Message-Id: <20211005060334.203818-2-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211005060334.203818-1-marcel@ziswiler.com>
References: <20211005060334.203818-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+a9YHR773ht0gGFZfRrAW3chQK1C5VW5Pft8ZjwQT+arALWpez4
 O3EbK9cbpkjYHjkUeOS7aZURHUVu4fwZ2C5TEqAj3EydxzC0TdnWpcuCKNoLiYWn0hwJziy
 FDwuQHCpvfoUBrtu51eATG/poD1vLkG9NaEcNh3iUJZKRVY/Of/MjOxgtoHlcwHmiOcOzKB
 fQxoTzeNh3e+kdBaIGiOA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QyNV/EuuHlM=:9Nc5UcBha6ZisSU8HdOep6
 7PXXCpLlZv0UesOaItQtLFABMdHYx+CfLNpHXzGcdV6xG5OGf2HcjqY9S2Pr0YLl92TD1PQfU
 Qp4MUz/2/DwLQP6leLSgoO5nTSh6rg0WN4Nb4Tl0DJKLD3+PkPLsuO0npPXQrUG+sEKZOvAgX
 EkgDgmkuRnEkWfPfkJxD62rfwz+QEc9xWHptxurRIeMWEuX0ir5ZcSFmVFHscGa5b4lyuWluo
 X6+WM2JAsdk/u7IvoskBL9z9MCkoCDGa+Wv+CAwYp9eL042/aBAkkV+9eSqbVtoBGbwRdaxuK
 qsWHqT0GFTXbPFKzz6wKcu34s9KAhLCwlg+HBk9YxH5wn+Ub0mxXnqOiUoxniDFDeXtC0zc5i
 HvEv9XlRBdUsVKE3swP30TocS3oEWwfzoe8Bk6mStTHPkDeiFzwgRTIHcbQA4J91zD3TeSqQA
 ai6LeY47VbmCCb1zq3ccTocDKaueyhlwxNgzd93gLpNOxt1Kd/cfgPXgw3pG1/qx1kb6pSji2
 8a0UZxC5Re0MUHaSqP0j+R9GN4Tk8OaKahKgl0WSLIX29Hpg9nQrJRcsQgGVc9vIf40SqV37r
 yezTqUCtAOf/1DC1m+0XpDjgA8arjKNhHeYj6WovNVQ0Wc/t1WNF1/oqKxZcpHASUJCHxM6m/
 DWkhYVu0BhorjwliJUXW9z/6IqwIJzdq7y0q8XvDl5/MEN8UkQCPOSuDOLJG1eonBCU9c9Jko
 wjMQ6vvLo8QOAws5jGjUAzfugclw07Sc3skeow==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the MV88E6390 switch chip exists, one is supposed to use a
compatible of "marvell,mv88e6190" for it. Fix this in the given example.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---

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

