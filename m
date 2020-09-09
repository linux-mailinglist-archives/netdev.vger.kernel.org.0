Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6292635F7
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgIIS0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:26:51 -0400
Received: from mailrelay105.isp.belgacom.be ([195.238.20.132]:5273 "EHLO
        mailrelay105.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729525AbgIIS0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:26:44 -0400
IronPort-SDR: pNX6ncdP65mDe1+h142elqQ5LUq0gy5gtBLRwL9zTsIHJwzLSrJgbGrLD0LA18UefqzTjMEMAQ
 2UwwWg87erL19RWH2XZUyxL6AEnit+lISd0MnlokClJzSPyP6VjYQrrsAX0exVhAJ56NLg6dSP
 30Ta4D2VfWvUzChbFtR0419icVua4PzeDPGDrCO6a0NUOc31vPfCp/aKdu3WSfQzf63YjXXw0g
 yzXMlMAeZzB/pa13tSygbcGqAe9Ya0xXbp31ueY5ZuszsA/ZtQYHPDNLqY0FYE6VQ8VrCttS2c
 FxE=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3Aa5HhahRaTOHR35jRawbZFyIxhNpsv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa67ZRKEt8tkgFKBZ4jH8fUM07OQ7/m+HzVdvN3R4TgrS99lb1?=
 =?us-ascii?q?c9k8IYnggtUoauKHbQC7rUVRE8B9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUh?=
 =?us-ascii?q?rwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9IRmrrAjdrNQajItiJ6o+yR?=
 =?us-ascii?q?bEpmZDdvhLy29vOV+dhQv36N2q/J5k/SRQuvYh+NBFXK7nYak2TqFWASo/PW?=
 =?us-ascii?q?wt68LlqRfMTQ2U5nsBSWoWiQZHAxLE7B7hQJj8tDbxu/dn1ymbOc32Sq00WS?=
 =?us-ascii?q?in4qx2RhLklDsLOjgk+2zRl8d+jr9UoAi5qhJ/3YDafY+bOvl5cKzSct0XXn?=
 =?us-ascii?q?ZNU8VLWiBdGI6wc5cDAuwcNuhYtYn9oF4OoAO+Cwa2H+zvyyVHhnnr1qM6ye?=
 =?us-ascii?q?QuDxzJ0xI6H9IPrHvUr8j+OaAcUe+v16bIwy7Ob+hV2Tb97ojHbAwhreuXUr?=
 =?us-ascii?q?1uaMfcz1QkGAzZgFuKs4PlIy+V2foXs2id9+duW+GihmonpQxwojWj2MkhhI?=
 =?us-ascii?q?nUi44J11zI6SR0zok6K9ClRkN2f8OpHZtSuiyEOIV6Xs0sTW5stSg6yrMKp5?=
 =?us-ascii?q?q2cS4Xw5ok3x7Sc/iKf5WS7h7+V+udPy10iG9kdb+/nRq+7Emtx+vhXceuyl?=
 =?us-ascii?q?lKtDBKktzUu3AI0Bzc99aIR+Nm/kekxTaPzwfT6vxYIUwslarUNZohwrkom5?=
 =?us-ascii?q?oXtkTMAjX5mEH2jK+RbUUk5vKk6+DgYrr6vJCcM5J7igb7Mqs0m8y/B/w0Mg?=
 =?us-ascii?q?kIX2eF5eSxzLnu8VDjTLlXjfA6jLPVvI3bKMkbvKK1Hg5Y3p4m6xmlDjem1N?=
 =?us-ascii?q?oYnWMALFJAYB+HgZLmNErAIP3jFve/gFStkDF1yPDaJLHuGYvCImDZkLj9Zb?=
 =?us-ascii?q?Z991JcyA0rwNBH/Z1bEbUBIPXoV0/3qtPYEhE5Mw2ww+b7Ftp9zJkSWWWVAq?=
 =?us-ascii?q?+WKKnSq0OH5vozI+mQY48YoDX9JOI46P7qk3A2hUQQfa+30psLZnC4H/BmI1?=
 =?us-ascii?q?mHbnr2mNsBFn0KvgUmRuzwlFKCSSJTZ2q1X68k6DE6BpmrDZzfRoC3hLyOwi?=
 =?us-ascii?q?G7EodLaW9YElqMC2vnd52YW/cQbyKfOslhnSIYVbivSo8h0Q2uuxHgy7Z+M+?=
 =?us-ascii?q?Xb5DMYuozn1NVu+e3Tmg899SZuA8SezW6NVWd0kX0MRzMs26B/u0N9wE+Z0a?=
 =?us-ascii?q?dkm/xYCcBT5/RRXwgmMp7c1fJ1C8zsVQ3be9eEU1CmTcu6ATE/T9Ixx8MObF?=
 =?us-ascii?q?hnG9m4iRDDxSWqCacPl7OXHJw07r7c33/pKsZ71XnGyLQugEc4QsZUK22mib?=
 =?us-ascii?q?Bw9xLJC47KjUqZjaCqeroY3CLX82eD12WOtllCUAFsSaXFQWwfZkzOoNT3/E?=
 =?us-ascii?q?zNVLGuBK88MgtCyc+CLLVFasHzgVpdWviwcOjZNnq4kWO3LRCF2r2NaJbnYS?=
 =?us-ascii?q?MaxiqZQEsNnwQe9l6AOBQwByO9rniYCyZhURrhfGv37fN6pXX9QkJn4RuNah?=
 =?us-ascii?q?hP3rC08xhdq+aRR/4J37kH8HMvoj96NE2+ztTbF5yKqlwyL+1nfdoh7QIfhi?=
 =?us-ascii?q?rivAtnM8n4Ig=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AZEgCXHVlf/xCltltfHAEBATwBAQQ?=
 =?us-ascii?q?EAQECAQEHAQEcgUqBHCACAQEBgVdVX406klGSAgsBAQEBAQEBAQEjEQECBAE?=
 =?us-ascii?q?BhEuCFCU4EwIDAQEBAwIFAQEGAQEBAQEBBQQBhg9Fgjcig1IBIyOBPxKDJgG?=
 =?us-ascii?q?CVym1IoQQhHWBQoE2AgEBAQEBiCeFGYFBP4ERg06KNAS2aoJvgw2EXX6ROw8?=
 =?us-ascii?q?hoFaSUaFqgXpNIBg7gmkJRxkNjlaOEkIwNwIGCgEBAwlXAT0BjTIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AZEgCXHVlf/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQEBgVdVX406klGSAgsBAQEBAQEBAQEjEQECBAEBhEuCFCU4EwIDA?=
 =?us-ascii?q?QEBAwIFAQEGAQEBAQEBBQQBhg9Fgjcig1IBIyOBPxKDJgGCVym1IoQQhHWBQ?=
 =?us-ascii?q?oE2AgEBAQEBiCeFGYFBP4ERg06KNAS2aoJvgw2EXX6ROw8hoFaSUaFqgXpNI?=
 =?us-ascii?q?Bg7gmkJRxkNjlaOEkIwNwIGCgEBAwlXAT0BjTIBAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 09 Sep 2020 20:26:41 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/3 nf] selftests: netfilter: remove unused cnt and simplify command testing
Date:   Wed,  9 Sep 2020 20:26:24 +0200
Message-Id: <20200909182624.23834-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cnt was not used in nft_meta.sh
This patch also fixes 2 shellcheck SC2181 warnings:
"check exit code directly with e.g. 'if mycmd;', not indirectly with
$?."

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 1f5b46542c14c..18a1abca32629 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -7,8 +7,7 @@ ksft_skip=4
 sfx=$(mktemp -u "XXXXXXXX")
 ns0="ns0-$sfx"
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! nft --version > /dev/null 2>&1; then
 	echo "SKIP: Could not run test without nft tool"
 	exit $ksft_skip
 fi
@@ -86,8 +85,7 @@ check_one_counter()
 	local want="packets $2"
 	local verbose="$3"
 
-	cnt=$(ip netns exec "$ns0" nft list counter inet filter $cname | grep -q "$want")
-	if [ $? -ne 0 ];then
+	if ! ip netns exec "$ns0" nft list counter inet filter $cname | grep -q "$want"; then
 		echo "FAIL: $cname, want \"$want\", got"
 		ret=1
 		ip netns exec "$ns0" nft list counter inet filter $cname
-- 
2.27.0

