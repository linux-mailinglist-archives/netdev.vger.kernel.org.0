Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB20E24EF34
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 20:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHWSRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 14:17:25 -0400
Received: from mailrelay102.isp.belgacom.be ([195.238.20.129]:53532 "EHLO
        mailrelay102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbgHWSRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 14:17:25 -0400
IronPort-SDR: Kv8tzqIQ8yr2Gm0qthsnJDSaxzw4SMHHtHSivb3GI/4NbBnCBlM/epqpNOrVqZxfxYc7ZRkF7o
 0AuFTnUlVuqpZFhOZkdwENWVns5xwX1Ed9zjk1IzvUqeJ52ddjbEUcVWEIDkPfjkvjP+Cke2TX
 9kk46FR2JMhoTUeqQ2fQa87srX5TYv6KDjP41UBtWMLx7l7MevAzghPX5CM7BpHRAPRORgK12t
 axRQkkbikAnvFxGWfVWJhLg56H/SR9wxCxm1clPYYuGz7Z9UE8vUT2lFotwbkjt7NGSUMLze5S
 fTI=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3ACFMU2xNzKLGYaWmhmVEl6mtUPXoX/o7sNwtQ0K?=
 =?us-ascii?q?IMzox0K/74r8bcNUDSrc9gkEXOFd2Cra4d1ayP6v6rADZbqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba5zIRmssAndq8gbjYR/JqovxB?=
 =?us-ascii?q?bCv2dFdflRyW50P1yYggzy5t23/J5t8iRQv+wu+stdWqjkfKo2UKJVAi0+P2?=
 =?us-ascii?q?86+MPkux/DTRCS5nQHSWUZjgBIAwne4x7kWJr6rzb3ufB82CmeOs32UKw0VD?=
 =?us-ascii?q?G/5KplVBPklCEKPCM//WrKiMJ/kbhbrQqhqRJh3oDaboKbOv1xca3SZt4WWW?=
 =?us-ascii?q?lMU9xNWyFbHo+wc40CBPcBM+ZCqIn9okMDoxukCga3BePg0DlIjWL2060gze?=
 =?us-ascii?q?suDB/J3BYhH90Ss3TfsdL4NKkIXu+uwqnF1i7Db/BW2Df79ofIbgotruqSUr?=
 =?us-ascii?q?9pd8fa1EYgGR/fgFqKtYzlIy2a1v4Ls2WD4eRtVuaihW4mpgxxvDSiyMcih5?=
 =?us-ascii?q?TVio4I1lzJ9Cp3zokoKNC2VkN2fN6pHZlOui+VK4d4TMwsTmVotig61LELvZ?=
 =?us-ascii?q?i2dzUJxpQ/3xPSb+GLf5KV7h/gSuqdOyp0iXNldb6lmhq/8E6twfDmWMauyl?=
 =?us-ascii?q?ZFtC9Fn8HJtnAKyhPc9NCKSuB4/ke9wTaP0B3T6v1cLUA0i6XbL5khz6Y0lp?=
 =?us-ascii?q?oUrUvMBCv2mEXxjK+NakUo4Oyo6+P7bbr8op+TKoh0igTkPaQvnMyzGeU4Mg?=
 =?us-ascii?q?4QUGiH4emx0KDv8VfkTLhJkPE6iLTVvZHaKMgBu6K0AhdZ0oM55Ba+Czem3s?=
 =?us-ascii?q?4YnX4CLF9ddhKIlZPmO1/VLfDjDve+g1Ksnyl3x/zcJbLuHI3BLmLfn7f5Yb?=
 =?us-ascii?q?Z990lcxRIrzd9F/J1UDrYBLen1WkDvqNzYAB45Mwiow+n5EtVxzIQeWXiAAq?=
 =?us-ascii?q?WBKqPdrUeI5v4zI+mLfIIVuyzyJOUh5/HwkXA0glkdcre13ZsZaXC4GuhmLF?=
 =?us-ascii?q?uDYXb2hdcBC2gKtBIkTOP2kF2CTSJTZ3GqUqIy6DA2E5mmDZvZRoCpnrOB2j?=
 =?us-ascii?q?23EYBIaWpeEFCDDW/od5mYW/cLcC+SOdRukiYFVbi/So8h0gqjtBXkxLV6Lu?=
 =?us-ascii?q?rb4DEYuYj/29hy4u3ZjQsy+iBsD8SBz2GNSHl5nmUWSD8q0qB/oEh9ykud3q?=
 =?us-ascii?q?himvBXCMJc5+1XXQc+LpPc0eN6BM7oWg7bfdeGVkymQtO4DjE1VN4xxMUOY0?=
 =?us-ascii?q?llEdW4kh/DxzaqA6MSl7GTGJM09bjc0GbtJ8lj0XnG0bIsj184TctTO22mh6?=
 =?us-ascii?q?p/9xTNCI7TiUmZkLyqdasE1i7X6GiD1XaOvF1fUANoV6XKQ2wfaVbIotTn/U?=
 =?us-ascii?q?7CUbCuBqo9Mgdbys6NNLFKatv3glVCXvvjP87eY22pkWeqGRmI3q+MbJbte2?=
 =?us-ascii?q?gF0iXSElMLkw4I8HadNgg/BiGhrHzCDDB0Dl3gfRCkze4rsHqxSkgcyQyWYU?=
 =?us-ascii?q?xly7evvBkPirjUSPof2r8PkCEstzt1GEqwxZTREdXE7wR+VL5Ae9cw5hFL2C?=
 =?us-ascii?q?aRrAZnP4KhKIh4i1IeehgxtETrhDttDYAVv8EgrXoshCRoJK6VylJKdHvM05?=
 =?us-ascii?q?n6NJXMKXj08QzpYaOAiQKW68qf5qpasKdwkF7kpgz8Tkc=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DjAQB9skJf/xCltltfHQEBAQEJARI?=
 =?us-ascii?q?BBQUBR4EyBQELAQGDGFRfjTiSSpICCwEBAQEBAQEBAScNAQIEAQGETIJHJTc?=
 =?us-ascii?q?GDgIDAQEBAwIFAQEGAQEBAQEBBQQBhg9FQxYBgV0ig1IBIyOBPxKDJgGCVym?=
 =?us-ascii?q?yT4QQhGeBQIE4AYgjhRmBQT+BEYNOihIiBJoPnDCCbYMMhFp+kTEPIaAyLZI?=
 =?us-ascii?q?WoVmBe00gGIMkCUcZDZxoQjA3AgYKAQEDCVcBPQGMBYQfAQE?=
X-IPAS-Result: =?us-ascii?q?A2DjAQB9skJf/xCltltfHQEBAQEJARIBBQUBR4EyBQELA?=
 =?us-ascii?q?QGDGFRfjTiSSpICCwEBAQEBAQEBAScNAQIEAQGETIJHJTcGDgIDAQEBAwIFA?=
 =?us-ascii?q?QEGAQEBAQEBBQQBhg9FQxYBgV0ig1IBIyOBPxKDJgGCVymyT4QQhGeBQIE4A?=
 =?us-ascii?q?YgjhRmBQT+BEYNOihIiBJoPnDCCbYMMhFp+kTEPIaAyLZIWoVmBe00gGIMkC?=
 =?us-ascii?q?UcZDZxoQjA3AgYKAQEDCVcBPQGMBYQfAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 23 Aug 2020 20:17:22 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 3/5 nf] selftests: netfilter: remove unused variable in make_file()
Date:   Sun, 23 Aug 2020 20:17:07 +0200
Message-Id: <20200823181707.13361-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'who' variable was not used in make_file()
Problem found using Shellcheck

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: new patch

 tools/testing/selftests/netfilter/nft_flowtable.sh | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index dc05c99405979..1058952d1b364 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -212,7 +212,6 @@ ns2out=$(mktemp)
 make_file()
 {
 	name=$1
-	who=$2
 
 	SIZE=$((RANDOM % (1024 * 8)))
 	TSIZE=$((SIZE * 1024))
@@ -304,8 +303,8 @@ test_tcp_forwarding_nat()
 	return $lret
 }
 
-make_file "$ns1in" "ns1"
-make_file "$ns2in" "ns2"
+make_file "$ns1in"
+make_file "$ns2in"
 
 # First test:
 # No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
-- 
2.27.0

