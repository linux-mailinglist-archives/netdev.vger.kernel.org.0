Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E0398877
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 02:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbfHVA1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 20:27:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36035 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbfHVA1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 20:27:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so2360174pgm.3
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 17:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IWQruhoXkG2kgJ7lqP8J7Zhyg6A9R/F57b2coq/PMDI=;
        b=X1JhO12Yt+CuSnUx7tuMEUZQPSSJALocXSF5Zztlu0mKdrK6T13In9QxlR0TcSks9t
         c2C3hnZCnt7SlxYaalcttakUDspmPGPW8dccB+Q1uQasasksSzTPTSYsxg4mpIrs3fhm
         COVCcTheQH6m7sTFm5sdBDz68l5jXJwZWda/e4FvH/rW8s8MnBeTHcD2uhjazN7xaO6i
         6eI72pyt+bQJvjivAAWQh/eKm8vscX2pdiEtihqHjk+TXfedi8S1vHIPweEokTDd5HQ0
         7TZKpopcZLcdcPkk0e1+MJ4ckgr1UVGl30GHM+tq7aXISCADtXkug6/8I3qFG+EpY7/+
         sFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IWQruhoXkG2kgJ7lqP8J7Zhyg6A9R/F57b2coq/PMDI=;
        b=VWvQGmAQX2OyJxivRSuOVHZeSTJEsY0iwKidFXlB/H4TYh+3aODZDEMq2BHhS5QnB1
         yoyOdd7AR9rBV1spzA8XqybHVL6kAf3EQ4PCUsCJUOHvdjoZKL91wJeNLOZmp/yNcKnD
         fVmYmlJTCOOPb6J1PfYgSj/oFh3SU0vTTefPWWvRq3Bhug9YUtHNvj3C+fDUbWC2S7UI
         08Ph6N0tAMOuyzNOqXWudqmH7RnMzlzOpNeTQ/1eLOdu3g/6Hn30zn+s+Ml+j/oQlIQp
         e7prKu5AyrnslLLpDb55NEr3g6fcGJWCkjon+LJAfqK1PYc6S4Ni++Nelu9A08+34rmO
         IpxQ==
X-Gm-Message-State: APjAAAXcsRIohAFz0IAqlG4w+KBr41yHC/c7wCIxoA+9cVcP/1N1N1ED
        ECDnTBiapAIqNQoxsJdDTQs29PqG
X-Google-Smtp-Source: APXvYqzpLiiIaRVgNe0M20EXJWwrpdhs0FrYghd8fhjmExupPvUrtlIqvInhRridwX5bNnDc+H0edw==
X-Received: by 2002:a63:2252:: with SMTP id t18mr31421544pgm.5.1566433626216;
        Wed, 21 Aug 2019 17:27:06 -0700 (PDT)
Received: from Husky.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h70sm21905538pgc.36.2019.08.21.17.27.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 21 Aug 2019 17:27:05 -0700 (PDT)
From:   Yi-Hung Wei <yihung.wei@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH net] openvswitch: Fix log message in ovs conntrack
Date:   Wed, 21 Aug 2019 17:16:10 -0700
Message-Id: <1566432970-13377-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
---
 net/openvswitch/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 45498fcf540d..0d5ab4957ec0 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1574,7 +1574,7 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
 		case OVS_CT_ATTR_TIMEOUT:
 			memcpy(info->timeout, nla_data(a), nla_len(a));
 			if (!memchr(info->timeout, '\0', nla_len(a))) {
-				OVS_NLERR(log, "Invalid conntrack helper");
+				OVS_NLERR(log, "Invalid conntrack timeout");
 				return -EINVAL;
 			}
 			break;
-- 
2.7.4

