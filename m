Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B82624EF28
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 20:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgHWSP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 14:15:59 -0400
Received: from mailrelay102.isp.belgacom.be ([195.238.20.129]:53438 "EHLO
        mailrelay102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbgHWSP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 14:15:58 -0400
IronPort-SDR: zIM6P8ffbkrc+YRO3HONKTuRLyO0PH06+gga4LTnGlMGnMxwajgJK7Vas6EP26SypTdufJ+Rgw
 vyls4H0hcFYQexwLNGetvvz7Nsw+Wb1gm8EO1+OWhi5hLhN8tfXQwTYL5QsgaFYRKGyB2wbjYW
 2Fnwr8miazCONtmB9VeKa5BPMleIJzGLsyoFvdebrJ5kLRekYkbm5Bq7Rki0IwG0aE7Dz2C/yI
 VqAaTpQLKIInHud6fGEZYgASf9/Ctt9aG0VHw8w8y5Tk7KlxORyNotT5X2vuSjutgJPZX32s2k
 XBo=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AySt2xh2yZ8zVUv+SsmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesUKfTxwZ3uMQTl6Ol3ixeRBMOHsqwC0rOI+Pm6ACQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagYL5+Ngi6oRjQu8UZnIduNLs9wQ?=
 =?us-ascii?q?bVr3VVfOhb2XlmLk+JkRbm4cew8p9j8yBOtP8k6sVNT6b0cbkmQLJBFDgpPH?=
 =?us-ascii?q?w768PttRnYUAuA/WAcXXkMkhpJGAfK8hf3VYrsvyTgt+p93C6aPdDqTb0xRD?=
 =?us-ascii?q?+v4btnRAPuhSwaMTMy7WPZhdFqjK9DoByvuQFxzYDXbo+SO/VwcbjQcc8ZSG?=
 =?us-ascii?q?dbQspcTTBNDp+6YoASD+QBJ+FYr4zlqlUOtxSxHgisC/npyjRVhnH2x7M13P?=
 =?us-ascii?q?k/HgHc3QwvA9EOu2nTodX7LqgdSu61wbLTzTXAb/JW3yny6JTSfh86v/6BRL?=
 =?us-ascii?q?R9etfexkczDQ3KlEmQqZD7MDOP0OQAq2aV4ulkWOyvimMqqx99rzavyMoxlo?=
 =?us-ascii?q?XFm54Zx1HL+yt23Ys4K8O1RVN7bNOmDpZeuD2WOYV5TM4mQ29muDg2x7kAtJ?=
 =?us-ascii?q?WmfyYK0IwqyhrCZ/CdboSF4QzvWPyMLTp5hH9pYq+zihe0/EO90OPzTNO030?=
 =?us-ascii?q?xPriddl9nMsW0C2ALL58icT/t94l+h2TGS1wDP8u1EIV47la7cK5M5xr4wkY?=
 =?us-ascii?q?Ycvl7HHi/2n0X2l7OWel8g+uiv9+voeLHmqYKbN49xkA7+M6IultS+AeQ+LA?=
 =?us-ascii?q?cOQ3CW9OCh2LH54EH0Q6tGgucrnqTYsJ3WP9kXq6+hDw9QyIkj6hK/Dzm80N?=
 =?us-ascii?q?QfmHkKNFxFdwicgIjnIFzOO/P4DPe5g1uyjDdn3evJMaP5DpXXMnfDiKvhfa?=
 =?us-ascii?q?p660NE0Ao818tQ55ZTCrwaJvL8RFPxtNLZDh89Lwy73fznBM961oMEVmKFGr?=
 =?us-ascii?q?WZP7/KsV+U+uIvJPGBZIwPtzngL/gq+eLhgGQ/mVADYamp05oXaHSkHvt4OU?=
 =?us-ascii?q?WVe33sgs0OEW0SpAoxUPTqiEGeUT5Uf3uyUaw96yogCIK6F4fDQp6igLqb0C?=
 =?us-ascii?q?imAJJcfnpGBUyUEXf0a4WEXO8BaDmJLc97kzwES7mhS4g62BG0qgD11rpnIf?=
 =?us-ascii?q?DI+iECqZ3j09117fXJlR4u7Tx0E9id02aVQmFygGwIWzE23KF7oUxh1FiDy7?=
 =?us-ascii?q?F0jOFGGtxN+fxJVhw3NYDTz+NkEdD+QAHBccmTSFagXNqmBSs9TtUrw98Be0?=
 =?us-ascii?q?x9Acmtjgjf3yq2BL8Yj6CEBJsu8q3Cw3j+Odxyy3Pd2aknkVYmXsVPNWyihq?=
 =?us-ascii?q?5j6QfTHZTFk0KDl6alba4cxjLC9H+fzWqSu0FVSAhwXrvZXX8CeETWs8/05l?=
 =?us-ascii?q?3NT7CwE7QrKAhBxtCYKqtMdNLpiU9KRPD5ONTRe2ixgXu/BQ6UxrOQa4rnY2?=
 =?us-ascii?q?sd0z/GB0gKiA0T5nWGNAg4Bii/v2LSFidhGky8K3/rpPF3one8Zkk50w+La1?=
 =?us-ascii?q?Fszfyy4BFRzf+VR/ce1ZoCtTsvqjFoEUz72MjZT5KOuCJ6YL9YbNV77FoDnX?=
 =?us-ascii?q?nTrQ1jP5uINa1uhlcCNQ9wuhDAzRJyX6tJm8kjqjsE1gd+JLiZ21AJIz2R15?=
 =?us-ascii?q?7YIb7GLGTuuhqiPf2FkmrC2cqbr/9coM8zrE/u6Vmk?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BeCQArsUJf/xCltltfgRCBRYMYVF+?=
 =?us-ascii?q?NOJJKkgILAQEBAQEBAQEBJw0BAgQBAYRMgkclOBMCAwEBAQMCBQEBBgEBAQE?=
 =?us-ascii?q?BAQUEAYYPRUMWAYFdIoNSASMjgT8SgyYBglcpsCiCKIQQhGmBQIE4AYgjhRm?=
 =?us-ascii?q?BQT+BEYNOhASGMAS2P4JtgwyEWn6RMQ8hoDKSQ6FagXpNIBiDJAlHGQ2caEI?=
 =?us-ascii?q?wNwIGCgEBAwlXAT0BjAWBWYJGAQE?=
X-IPAS-Result: =?us-ascii?q?A2BeCQArsUJf/xCltltfgRCBRYMYVF+NOJJKkgILAQEBA?=
 =?us-ascii?q?QEBAQEBJw0BAgQBAYRMgkclOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRUMWA?=
 =?us-ascii?q?YFdIoNSASMjgT8SgyYBglcpsCiCKIQQhGmBQIE4AYgjhRmBQT+BEYNOhASGM?=
 =?us-ascii?q?AS2P4JtgwyEWn6RMQ8hoDKSQ6FagXpNIBiDJAlHGQ2caEIwNwIGCgEBAwlXA?=
 =?us-ascii?q?T0BjAWBWYJGAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 23 Aug 2020 20:15:55 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 1/5 nf] selftests: netfilter: fix header example
Date:   Sun, 23 Aug 2020 20:15:37 +0200
Message-Id: <20200823181537.13254-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_flowtable.sh is made for bash not sh.
Also give values which not return "RTNETLINK answers: Invalid argument"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2 = V1

 tools/testing/selftests/netfilter/nft_flowtable.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index a47d1d8322104..28e32fddf9b2c 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -11,7 +11,7 @@
 # result in fragmentation and/or PMTU discovery.
 #
 # You can check with different Orgininator/Link/Responder MTU eg:
-# sh nft_flowtable.sh -o1000 -l500 -r100
+# nft_flowtable.sh -o8000 -l1500 -r2000
 #
 
 
-- 
2.27.0

