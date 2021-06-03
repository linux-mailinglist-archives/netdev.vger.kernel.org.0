Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6D939A963
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhFCRlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:41:42 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:13605 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhFCRlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:41:40 -0400
Received: (Authenticated sender: sosthene@guedon.gdn)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 5F63B240003;
        Thu,  3 Jun 2021 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=guedon.gdn; s=gm1;
        t=1622741994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hxmsmj2eERkqi/UDK1wWwdwwUgMwJebsvpvxjB0smIw=;
        b=Rqj/36ZGRhYdJ+ShM0SjtVA7PZjDYqqLnm6N8l9YGns6MZR2fA3XuKngwetHnC+pxO0+4b
        D/SYXaqXY0J6Q7g12P6q+yoBA1FnXfLKfQMzQEMCffT5VhGpPqUiS+EfenkntG9bKbNmk/
        FjLhOLJW429mQ2IAt7ZU27PgXF1yAGU3yUgXVzOCYfWFwmMJFRDlnEiX0X6/ZPysDoU3iy
        6jPqLG6ybkIRrTQu+Q3Vsrkhcu8Qan5Cl5VcJG+poFDJY8whA4GIflvhLwWo59mRNMLkAA
        wSUbPdVJ2LkXfdbcInbYG9+u+HEm12HpIQJJy22luHuLmORmyJkm5Mr8xWSIfw==
Date:   Thu, 3 Jun 2021 19:39:39 +0200
From:   =?iso-8859-1?Q?Sosth=E8ne_Gu=E9don?= <sosthene@guedon.gdn>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/wireless/nl80211.c: Fix typo pmsr->pmsr
Message-ID: <YLkT27RG0DaWLUot@arch.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sosthène Guédon <sosthene@guedon.gdn>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fc9286afe3c9..9ebda31e2f5e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -330,7 +330,7 @@ nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
 };
 
 static const struct nla_policy
-nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
+nl80211_pmsr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
 	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR,
 	[NL80211_PMSR_PEER_ATTR_CHAN] = NLA_POLICY_NESTED(nl80211_policy),
 	[NL80211_PMSR_PEER_ATTR_REQ] =
@@ -345,7 +345,7 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
 	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
 	[NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
 	[NL80211_PMSR_ATTR_PEERS] =
-		NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
+		NLA_POLICY_NESTED_ARRAY(nl80211_pmsr_peer_attr_policy),
 };
 
 static const struct nla_policy
-- 
2.31.1

