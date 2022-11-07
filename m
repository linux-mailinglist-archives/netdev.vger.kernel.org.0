Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEB961ECF1
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiKGIbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiKGIbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:31:41 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DCF14002
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 00:31:40 -0800 (PST)
Received: from gmx.fr ([181.118.49.178]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mt757-1p7R9b24z3-00tUUz; Mon, 07
 Nov 2022 09:31:27 +0100
Date:   Mon, 7 Nov 2022 04:31:22 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: [PATCH net v3 1/1] ip6_tunnel: Correct mistake in if statement.
Message-ID: <Y2jCWvICWQ8AiQyR@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:ZNuhJA3kCSNmjsv+m6lKmXnvgy6W/whdxVOeutRQVrrSPw0y1cR
 jwX9trCLx6wZ1WSMpUC6lRddq4zP3moFPMBmF3cCVcfGz/FwTXcyDRXZtabXJZGeUQAa6n4
 uTMYG5B+Fj79KdP+LQowjK+tEddbIJas96OL9Gpkal22fdZg0+1seMO80F3adjR2e1jAh4O
 xhbevsOQ/vCWwlcafXejQ==
UI-OutboundReport: notjunk:1;M01:P0:fAg3v0Dmc1k=;f985zcX7Z7j8YVLalLduMhlkx3c
 B8Jo0btzdH183kWbaWRqOLzp1jwFMb1NHqTDRTSxHIrMWPYWs8pOEMXPeAujwuhuRgqDXNCW9
 NizIJU2FqY2u+r1rKyWgl91DADhBnr6788Uq3oLOerTjIcfbERY1UM19DywUZW9lTLOblbM9s
 rm99maNDICaopBr2/+G0ST23LLRJuDjffbjCf3K4AOIfwobyazYwAoU2gerDkTvF3WLU5bEr1
 kU3RMeFMMAIeDOadOx93dwpbWw112eLInhOruQqUfBIxt8mF8DuFU5+NetkkW6L2J5WWmmN41
 pXoKe2ZoRA/5M94gUfD4MII8R9vDgz+hoigF6bTCzLZB3koLPbTK5yJN52oSZbFegXG4fZbsm
 JQY6RGUqQ/gDI/M8gGtrjxzBAyrcgyyTiz1FiNdmDcfhutK6i7EfrbOZSpCEp22bBjKDXMams
 0GdNwkC2Ae0IG7mfKwPdu+EmEa4tfHHezR0MJXOIXEc2sEEuI8f9wNiGfEDpulPUyFwdoJi5B
 mRjFjVicFGrHQN7At7zb6S5mpTkVYAB0c6XyFllH63tLOmIlg3VrxsyB31Pv3ZScmAT71aaxY
 J53D8T7HPMt1lx/N9qgbOy9b6oWF2N0dlRqPaxHvv+vm0oiOauX4ptib+wJuQ0dTj/62Zc8aX
 btokoYiubGn/kyWcDFVRHETwBeF98zhGYa9wxleUJVs7tOCBbk/IELBLTdFZC2Qdfj55q75BW
 2t724cu/2rlzfmEuhmId4oRLGJszQmU6LDL7dC+QzEi13Ri9P18E8Dql8rf3SUNoz57QtgCpG
 S3Nw3BlGHxJ3YNYR+1Klfny58B606Mlxoasz/dG6A7wkNM0K9Ej2505Yc/pE1cFRQUOe0Oimb
 HQaC559NYLUAVkmMYWsmh15SUiokocihKnJ0sO+RJlh0wzIGb31/tHYAfVPvH6dzvQX1q5iY1
 ShRi/HUeygeRg9hjCjv0spfn884=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure t->dev->flags & IFF_UP is check first for logical reason.

Fixes: 6c1cb4393cc7 ("ip6_tunnel: fix ip6 tunnel lookup in collect_md
mode")
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

