Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943DB2635F3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgIIS0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:26:41 -0400
Received: from mailrelay105.isp.belgacom.be ([195.238.20.132]:5273 "EHLO
        mailrelay105.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgIIS0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:26:32 -0400
IronPort-SDR: bD8uNhFGVHwEVPYlwW5V5w67iMWVYwJpup2/wKODiZDjkJl4W0UA0clZ2xOG5QUebakvN+0kVg
 pAHcfR1bvr4gvRFOh+S5nE50W5IKd1PSD6xCcwORVr0mPm0c7dRc/TW4+8CAj9CvJ5gSGXlV5k
 4FaEoD94Kb38IuHnrxv7DrhLcYw8A7G2P9zLhIgqSoYxDdSXUZfnjzfy906E1yaLU5sH/THK/F
 K/JzVEwplBFApBINpeijljEch+QjLiFVVgHxqs/IRk3jPCx7QwdAnV8t07xUDK6WWc/HAxuJSb
 GKk=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3ADmRruhcXQ/3uiqyw0Dyk0imOlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc27YheN2/xhgRfzUJnB7Loc0qyK6v6mADFdqsbQ+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAi3oAnLq8UbgYtvJqkyxx?=
 =?us-ascii?q?bNv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/WfKgcJyka1bugqsqRxhzYDJbo+bN/1wcazSc94BWW?=
 =?us-ascii?q?ZMXdxcWzBbD4+gc4cCCfcKM+ZCr4n6olsDtRuwChO3C+Pu0DBIgGL9060g0+?=
 =?us-ascii?q?s/DA7JwhYgH9MSv3TXsd74M6kSXvquw6nG1jjDdPBW2Df76IfWbhAtu+qDUq?=
 =?us-ascii?q?xpfMfX1EIgGB/LgE+Kpoz5IzOayP4Ns26D4uRuVu+ij24ppgBxrzSxyMoiip?=
 =?us-ascii?q?TEip4IxlzY9Ch3z4k7KMC2RUNlfNOpEJlduj+VOYdqTM0sTGVltiY6xLEYvZ?=
 =?us-ascii?q?O2ejUBxpc/xxPHb/GLbpKE7g/gWeqPOzt0mXNodbKlixqv8EWtzPD3WNOu31?=
 =?us-ascii?q?ZQtCVFl8HBtnUK1xPO9MeKUuB9/kK92TaX0ADT9/1ELVg0laXFL54hxaY9lp?=
 =?us-ascii?q?4UsUvfBCD2nEX2jKiNdkU44OSo7+Pnban8qZ+YKoB0jQT+Pb4vmsy5Geg4Mw?=
 =?us-ascii?q?4OUHaH+emk0LDv4Ff1TKhJg/EoiKXVrZHXKMQBqqKkAgJZyoMj5Ay+Dzei3t?=
 =?us-ascii?q?QYh34HLFdddRKJlYfmIF/OLevjDfe8g1Wslilkx+zcMrL6HJrBNmLDn6v5fb?=
 =?us-ascii?q?Zh905czxI+zchF6J1PDrEBJ+n+Wknvu9zEAB85Mgi0w/r5B9VnzI8eXniPAq?=
 =?us-ascii?q?CBOqPIrVCI/v4vI/WLZIINuzbyMeUq5/rwgnAlglIde7em3YcZaHC5GvRmP1?=
 =?us-ascii?q?uWYWD2jtcGC2cKsRI0TPb2h12aTT5Te3GyUroy5jA1E4+mFpvDRpqpgLOf2i?=
 =?us-ascii?q?e3BIBZaX5eAFCWDXjob5mEW+sLaC+KJM9ujCAEVbagS48lyRGhqhX6x6N6Ie?=
 =?us-ascii?q?XK5C0Xq5bj2cNr5+3cix4y7yZ4D8eD3GGXSWF7gGcISyUx3KBlrkx30k2D3r?=
 =?us-ascii?q?Rgg/xECdxT4OtEXRs9NZ7G0eN6F879VRjEftqSTlapXMmmAT8wTtI1398BfV?=
 =?us-ascii?q?x9F8+ljhDZ0CqgG6UVmKCTBJwo7qLc2GD8J8BjxHbayaYukUcmT9BRNW2pmK?=
 =?us-ascii?q?F/7RLfB43XnEWDkaala6Ac0DTK9GeZwmqEpFtYXxJoUaXZQXAfYVPbrdrj6U?=
 =?us-ascii?q?zZQb+jEq8nMghByM6ENKRKdsflgk5YS6SrBNOLe2u7n2CYAxuUyLKIcIfwPW?=
 =?us-ascii?q?IH02GVC0EIlw0Y1XCLKQY/AjusuSTZFjMqXVzwS1jw6+1zrjW3Qxwa1QaPOm?=
 =?us-ascii?q?No3bu8/FY7n/GQRukS1bFM7CkooTtcB1Ws2d/KTdCN8VkyNJ5AaM8wtQ8UnV?=
 =?us-ascii?q?nSsBZwa8St?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CmQgCXHVlf/xCltltfGgEBAQEBPAE?=
 =?us-ascii?q?BAQECAgEBAQECAQEBAQMBAQEBHIFKgRyBfFVfjTqSUZICCwEBAQEBAQEBASM?=
 =?us-ascii?q?RAQIEAQGES4IUJTgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E?=
 =?us-ascii?q?/EoMmAYJXKbUihBCEdYFCgTgBiCuFGYFBP4RfhASGMAS2aoJvgw2EXX6ROw8?=
 =?us-ascii?q?hoFYtkiShaoF6TSAYO4JpCUcZDY4oGo4mQjA3AgYKAQEDCVcBPQGKbIJGAQE?=
X-IPAS-Result: =?us-ascii?q?A2CmQgCXHVlf/xCltltfGgEBAQEBPAEBAQECAgEBAQECA?=
 =?us-ascii?q?QEBAQMBAQEBHIFKgRyBfFVfjTqSUZICCwEBAQEBAQEBASMRAQIEAQGES4IUJ?=
 =?us-ascii?q?TgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/EoMmAYJXKbUih?=
 =?us-ascii?q?BCEdYFCgTgBiCuFGYFBP4RfhASGMAS2aoJvgw2EXX6ROw8hoFYtkiShaoF6T?=
 =?us-ascii?q?SAYO4JpCUcZDY4oGo4mQjA3AgYKAQEDCVcBPQGKbIJGAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 09 Sep 2020 20:26:30 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/3 nf] selftests: netfilter: fix nft_meta.sh error reporting
Date:   Wed,  9 Sep 2020 20:26:13 +0200
Message-Id: <20200909182613.23784-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When some test directly done with check_one_counter() fails,
counter variable is undefined. This patch calls ip with cname
which avoids errors like:
FAIL: oskuidcounter, want "packets 2", got
Error: syntax error, unexpected newline, expecting string
list counter inet filter
                        ^
Error is now correctly rendered:
FAIL: oskuidcounter, want "packets 2", got
table inet filter {
	counter oskuidcounter {
		packets 1 bytes 84
	}
}

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 17b2d6eaa2044..1f5b46542c14c 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -90,7 +90,7 @@ check_one_counter()
 	if [ $? -ne 0 ];then
 		echo "FAIL: $cname, want \"$want\", got"
 		ret=1
-		ip netns exec "$ns0" nft list counter inet filter $counter
+		ip netns exec "$ns0" nft list counter inet filter $cname
 	fi
 }
 
-- 
2.27.0

