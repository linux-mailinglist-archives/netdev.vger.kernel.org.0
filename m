Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E74244E99
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgHNSzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 14:55:41 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:13738 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgHNSzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 14:55:41 -0400
IronPort-SDR: psrl8GDBY0a4SrwAWD8aleYzVyoJsX9T3b4VnLT8emiGuEF5TZPJzabP9Eq7lMhKtNT0kKgSvk
 Vq+DK3F+LQHQRX6Lp9cn3s8ixClZY+CIV43iMbWilvKj9YyFswMQglR6Rn5aaEdc/4o7+q324W
 umDiQ6ZbpRUwC7L2IKWD2Pc95GnOKxsgv6BU+cMDApitSELq4875NLIQFiDT3lGCOw2WDpyNh+
 eaWxEdyLkMqki1fRakLJhMSZ2jGTwbLHQaekV8b4iuffWcpTZK8RJNm7/HqdiYBYoz1oY3g4oF
 r+4=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3A5SrVTh8D0kEz8/9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+0uwVIJqq85mqBkHD//Il1AaPAdyFraMbwLOM6OjJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVhTexe7d/IRe5oQnMqMUbj5ZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxLulSwJNSM28HvPh8JwkqxVvRyvqR94zYHbb4+YL+Zyc6DHcN8GX2?=
 =?us-ascii?q?dNQtpdWipcCY28dYsPCO8BMP5YoYbnvFQOrAGxBQ+xD+3v0D9HmGL50rMg0+?=
 =?us-ascii?q?QgDQ7G3xErEtUAsHvOt9r1OrwfUfu2zKjIyzXMce9W1S3m54fWax0sp+yHUr?=
 =?us-ascii?q?1sf8TL00YvCx/FgUuKqYzjJz6b2OcAvmyb4edhVe+jlWAqpQFsrzSz28sglo?=
 =?us-ascii?q?jEiI0axF3Z+yh03ps4KN26RUNlbtCoDJVeuS6eOoV2Qs0uXWVltSAnwbMFoZ?=
 =?us-ascii?q?62ZCwHxIk9yxLCaPGLbZKE7g/iWeuROzt0mXNodbSijBio60eg0PfzVsys3V?=
 =?us-ascii?q?ZPqSpKj8fDu2gW1xzW9siHUvx9/lq92TqX1wDc9OVEIUcsmKrfLJ4u3qQ/lp?=
 =?us-ascii?q?4TsUTEBS/2hF/6jKuRdko44Oeo7/noYrLjppCGNo90jBnyMqUomsOhHeQ1Kg?=
 =?us-ascii?q?wDU3WB9eih17Dv41f1TKhLg/A2iKXVrZHXKdwepqGjAg9V1ogj6wy4DzejyN?=
 =?us-ascii?q?kYk2MII0lLeB+clIjpOFHPIPbmAvejmVijiylky+jcPrL9GpXNMmTDkLD5cL?=
 =?us-ascii?q?Zl8UFT0w4zzddE6pJSFL4BPPzzWk71tNzEEBA5KRa4w+H9CNVyzokeQ36AAr?=
 =?us-ascii?q?eFMKPOtl+F/uEvLPORa48RpjnyN+Mo5/jwgn8ll18dfK2p3YcJZ3CiBPhmJF?=
 =?us-ascii?q?+ZYXX0iNcbDWgKphY+TPDtiFCaXz5SaW2/X7kg5jEhDIKpE4HDSpqwj7OfxC?=
 =?us-ascii?q?27BIFZZnhaClCQFnflb4OEVOkQaCKcI89hliAEWqa7S4M4yB6hqhH6xKRjLu?=
 =?us-ascii?q?fP5C0Yuozs1MJv6+3Qix4y7zp0ANqZ022XSGF0hGwITScs3K9juUx91kuD0a?=
 =?us-ascii?q?9gjvNEEtxT/e1GUhskOpHGyux3ENbyVRzdfteHSVamRsmmDi8rTt4rxN8OeU?=
 =?us-ascii?q?l9Ec24jh/fxyqqH6MVl7uTCZwy7K3cw2X+KNhjy3vdyqkhgEcpQtFVOW2lmK?=
 =?us-ascii?q?F/7Q7TCJDNk0mDkKaqb6sc1jbX9Gif1WqOoF1YUAloXKXLR38QfUXWoM/i5k?=
 =?us-ascii?q?PBT76uD6ooMhdbxcGZNKQZIuHu2E1PTvPkENLTf2ywn3u9H1CP3LzIJInjd2?=
 =?us-ascii?q?EQ1w3bBVQKkgQP8GzAMhIxQm+vvErFECZqGFSpb06/3/N5rSaVR0U1xgfCQV?=
 =?us-ascii?q?ds27ev+xUWzaiSQvkd9qkHqSEst3N+EQDujJrtF9Ocql85L+1natQn7QIf2A?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CCBADp3DZf/xCltltegRCBQ4MaVF+?=
 =?us-ascii?q?NOJI1kXsLAQEBAQEBAQEBJw0BAgQBAYRMgkolNwYOAgMBAQEDAgUBAQYBAQE?=
 =?us-ascii?q?BAQEFBAGGD0WCNyKDUQEjI4E/EoMmAYJXKbImgiiEEIUagUCBOIgihRWBQT+?=
 =?us-ascii?q?BEYNOhASGMAS2LoJsgwuEWn6RLQ8hoB+SOKFNgXtNIBiDJAlHGQ2caEIwNwI?=
 =?us-ascii?q?GCgEBAwlXAT0BjUaCRgEB?=
X-IPAS-Result: =?us-ascii?q?A2CCBADp3DZf/xCltltegRCBQ4MaVF+NOJI1kXsLAQEBA?=
 =?us-ascii?q?QEBAQEBJw0BAgQBAYRMgkolNwYOAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCN?=
 =?us-ascii?q?yKDUQEjI4E/EoMmAYJXKbImgiiEEIUagUCBOIgihRWBQT+BEYNOhASGMAS2L?=
 =?us-ascii?q?oJsgwuEWn6RLQ8hoB+SOKFNgXtNIBiDJAlHGQ2caEIwNwIGCgEBAwlXAT0Bj?=
 =?us-ascii?q?UaCRgEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 14 Aug 2020 20:55:37 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/2 nf] selftests: netfilter: fix header example
Date:   Fri, 14 Aug 2020 20:55:22 +0200
Message-Id: <20200814185522.8677-1-fabf@skynet.be>
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

