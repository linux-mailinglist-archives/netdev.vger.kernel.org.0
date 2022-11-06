Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6512D61E651
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 22:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiKFVKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 16:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiKFVK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 16:10:28 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B157C05
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 13:10:16 -0800 (PST)
Received: from gmx.fr ([181.118.49.178]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MvsEn-1pBWLZ0iXP-00szLc for
 <netdev@vger.kernel.org>; Sun, 06 Nov 2022 22:10:14 +0100
Date:   Sun, 6 Nov 2022 17:10:06 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     netdev@vger.kernel.org
Subject: [PATCH net v2] ip6_tunnel: Correct mistake in if statement.
Message-ID: <Y2giri0PIEIlQQC9@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:CYKQ6GEBP7rMHArrYRTyFEnwKxi20Cc/SQPC93XcIP0B2J5CeDt
 RizeESyXuYCpM8nTcVbjpPG1rraNsUGFZTdffDU79SG9kDw0xx7LyQj3ffsPr+k2yUSdIz1
 IHjn5cVVD9COIjhSGMs9If1y+YeB1b79TK6cdkVGI93wKY8z8+y4tRZlgy+rw/M3BMh8YBF
 Dkg51wegUpCzbYZ+nZLHQ==
UI-OutboundReport: notjunk:1;M01:P0:qv5AWsRSYDI=;2HZCFCK8l6mM4w7ZbakQ15obTe8
 TgZDQE1ESQOjbigbYtsWp1PIj11I0WhCvwiikK5qIH7i85gCUho1VF4+RKvA12OZzpT73KR0/
 Qc9DH7gD4foKgVBI3Ab9zvzj75e++HN86dgoGM5f2Bk9tb2SbPxZuEXLaagL4ejPLBZDOGTNc
 rMvUUBpv9bmGGvCFw5QJ5AuYj+jaAvk1YtBDv1eMsonyGoqQmzfQRVw1grHRLG7xIdA4VYy0X
 QuBCkmJvaR5TleccR832VG3OuH+q3ojQaw7auAf7JB8UzuAJJIXKpCvU5o+9gvJBH4mCGYTU6
 qbY025iyNDrkxAR4QrE5mT2ppYEU1pLqYnhMC1PXiSyBrJgFfbsQCeKPHtpeO4ogxQo1tk4L3
 y8arSfDyQ76vAECq94srmTxXsD1FIk1oKFWK8HP5rvT6b/4MpNzkHqExjSWAQkYUwo1y0jhCV
 57vojp6gcZihbkFCAHfMe1wSzbTPMs8PBSVO+bRXTJkY2ikSroM17dIneO2I4tOPkp7BzKYc3
 6GBTSqld+1u2tyef3lPs/ltX6DVNHuLks3kJTf8DugDhKoxZ+y0Po6V9xI/RDYmXjTNfORxc+
 LiF8yBnrd+d5xzNktnsGVsHy0WajCWZPnEdWHvet5W6xlNGJ7hlRqfJYcu4Mv3Qoj42dkxvvf
 /rwTozQCvz6/Iu9GhD4r2QiTh4eER8ZpBthqaK9Tg7lCBDg3vFtNFnsLj1ML/4ZF6g4PR+B2e
 PWYnvEaUdUgZ9891BRzAqViamwNZVr5zM1te3aT/eaensIJgsYzo+3uEKKhr3wzmk++Bmb8AW
 PFi8Lrp4E851WpOYCyzAuJiwH3+BerjTcpTC5Gw0t6KhOmvZ6eVKJUd61BQISWvo/NmX5nZJ2
 qJYrwk5utIHi3EUrpHhYeSw85T4J0MFivbFNb4UORZVdMpkmZyqU/PkWg7Vt452dp1vzKV+U3
 rmz2IzxkF6Xzj6e7yBAwkOnoJpE=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure t->dev->flags & IFF_UP is check first for logical reason.

Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2fb4c6ad7243..22c71f991bb7 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -162,7 +162,7 @@ ip6_tnl_lookup(struct net *net, int link,
 		return cand;
 
 	t = rcu_dereference(ip6n->collect_md_tun);
-	if (t && t->dev->flags & IFF_UP)
+	if (t && (t->dev->flags & IFF_UP))
 		return t;
 
 	t = rcu_dereference(ip6n->tnls_wc[0]);
-- 
2.28.0

