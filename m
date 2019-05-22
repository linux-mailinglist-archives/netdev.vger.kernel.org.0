Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED290271BF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbfEVVii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:38:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39156 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729691AbfEVVih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:38:37 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A04AA4C0060;
        Wed, 22 May 2019 21:38:36 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 22 May
 2019 14:38:32 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 3/3] flow_offload: include linux/kernel.h from
 flow_offload.h
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
Message-ID: <2f98e4a0-d0cc-46af-fb12-cbfe23c8cbe9@solarflare.com>
Date:   Wed, 22 May 2019 22:38:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24630.004
X-TM-AS-Result: No-1.606200-4.000000-10
X-TMASE-MatchedRID: xeF2JCuG660uQK2tsehFmmhCG8qMW+Ky9e5am3m57X0d0WOKRkwsh0Ac
        6DyoS2rICNLuPteRDHeGDu7ShAWPZxgHZ8655DOPOX/V8P8ail2cIZLVZAQa0IwZVlv5NpEAUEh
        Wy9W70AFYF3qW3Je6+z9ZilJtYlDDsoQk03GIzlwSY7ecXl4wFgPQXz5y+3164AI1n6c9Dz9Ol/
        NQkuCg/TgpiscYAwVkT7ywttmULMoG76l3NxGiSzHCqV7rv9Y1QDMFuK2P9FjtoWavEW7HRE3Z8
        jKJCdR04mqLFh5vfmx+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.606200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24630.004
X-MDID: 1558561117-AnbjQFhBtyUx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

flow_stats_update() uses max_t, so ensure we have that defined.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/net/flow_offload.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index ae7cf27cd5e3..7554e88581d2 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -1,6 +1,7 @@
 #ifndef _NET_FLOW_OFFLOAD_H
 #define _NET_FLOW_OFFLOAD_H
 
+#include <linux/kernel.h>
 #include <net/flow_dissector.h>
 
 struct flow_match {
