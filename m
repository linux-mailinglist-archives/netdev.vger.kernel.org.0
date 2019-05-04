Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D1139F3
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfEDNEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:04:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39794 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEDNEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:04:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id a9so11228151wrp.6
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pZf3Kr/dvKu+by85EdZNNlFNFQgQi6qBW+dyWhz6NUA=;
        b=aGfhRVKvFtYTO4nyNlldYmi0ryTJMCCpp/UxRZWG86qIBO2jP+CDhNqF4166UoyZwk
         33iORbp/kxuGtJGL2F3J+cLniE0XiizY+XcZzWefqSU7zRtFy0nhqRCCmlTsHXSE078B
         19zf54ADeLj3O+4R6SPpeN6T2FN60QIWEfKcTDXpsFOL5QS/yVWOTySgY2Rgx27dLgAI
         WrAzeKmP8o0Woq5zvKg5Rdwl/JBjYLqNFNzaGp64BngmHyN1ZSDHubvros8WKK12klLo
         icDPjFymXrpsGh2PTwqBoMIfLxO3dOsrgSh+kEEx7dyo+R6U7JY8vww+affqIJdGpAWp
         azYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pZf3Kr/dvKu+by85EdZNNlFNFQgQi6qBW+dyWhz6NUA=;
        b=TA7dKLOA4aV8KNrl0BWL8A6ovsAua5YAReZUMw4mYNfKRj4phdA4pTCxsT/XrWkhCW
         dL5w3C9OI+oz5/Wm5PSk2/CueQEmD9mLwI0/O3vtiMoXyXZsTAwUB9TpV3wV4Qd9WPMh
         H4L/XpAvBCiFAzYiV/XpRu2+sCICcZ/Z2isZpEzI/nQc9qVFRA8la08oxpN5EH6z9Tqv
         b6viFHY5NSu8Q8C71LlKl6XXhVjj+ySgK4mlpZ7xUYd4xHyN2OSxBARCubDQHQHqNWwc
         s+RzdoSWt35eMdeFUmvP2piFbvuTT4pOnk18CgBmtWyAL5BO66M1I4TxHjVDvQiJttau
         f92A==
X-Gm-Message-State: APjAAAXIAPdqYSD8ajzQgHz1eEje/x8Pv1cSJCNBKz9oDWd4fcmrFs2u
        zF62HP65CAJdlHZA/F9Xj2k4Ug==
X-Google-Smtp-Source: APXvYqyrx2L3ZnWgzy6xvgkPJmHU7Vv5rRSeLz1+esoI/EKmL7mEwPyvZ78xzjHCPiWDVDpiuxY7RA==
X-Received: by 2002:adf:eec8:: with SMTP id a8mr9040151wrp.64.1556975058747;
        Sat, 04 May 2019 06:04:18 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 10sm5993927wmn.4.2019.05.04.06.04.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:04:18 -0700 (PDT)
Date:   Sat, 4 May 2019 15:04:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>
Subject: Re: [PATCH net-next 06/13] net/sched: move police action structures
 to header
Message-ID: <20190504130417.GG9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-7-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-7-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:21PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Move tcf_police_params, tcf_police and tc_police_compat structures to a
>header. Making them usable to other code for example drivers that would
>offload police actions to hardware.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Note that Joergen Andreasen is pushing similar patch as a part of his
patchset:
[PATCH net-next 1/3] net/sched: act_police: move police parameters into separate header file



>---
> include/net/tc_act/tc_police.h | 70 ++++++++++++++++++++++++++++++++++
> net/sched/act_police.c         | 37 +-----------------
> 2 files changed, 71 insertions(+), 36 deletions(-)
> create mode 100644 include/net/tc_act/tc_police.h
>
>diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
>new file mode 100644
>index 000000000000..8b9ef3664262
>--- /dev/null
>+++ b/include/net/tc_act/tc_police.h
>@@ -0,0 +1,70 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+#ifndef __NET_TC_POLICE_H
>+#define __NET_TC_POLICE_H
>+
>+#include <net/act_api.h>
>+
>+struct tcf_police_params {
>+	int			tcfp_result;
>+	u32			tcfp_ewma_rate;
>+	s64			tcfp_burst;
>+	u32			tcfp_mtu;
>+	s64			tcfp_mtu_ptoks;
>+	struct psched_ratecfg	rate;
>+	bool			rate_present;
>+	struct psched_ratecfg	peak;
>+	bool			peak_present;
>+	struct rcu_head rcu;
>+};
>+
>+struct tcf_police {
>+	struct tc_action	common;
>+	struct tcf_police_params __rcu *params;
>+
>+	spinlock_t		tcfp_lock ____cacheline_aligned_in_smp;
>+	s64			tcfp_toks;
>+	s64			tcfp_ptoks;
>+	s64			tcfp_t_c;
>+};
>+
>+#define to_police(pc) ((struct tcf_police *)pc)
>+
>+/* old policer structure from before tc actions */
>+struct tc_police_compat {

Why do you need this in header?


>+	u32			index;
>+	int			action;
>+	u32			limit;
>+	u32			burst;
>+	u32			mtu;
>+	struct tc_ratespec	rate;
>+	struct tc_ratespec	peakrate;
>+};
>+
>+static inline bool is_tcf_police(const struct tc_action *act)
>+{
>+#ifdef CONFIG_NET_CLS_ACT
>+	if (act->ops && act->ops->id == TCA_ID_POLICE)
>+		return true;
>+#endif
>+	return false;
>+}
>+
>+static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
>+{
>+	struct tcf_police *police = to_police(act);
>+	struct tcf_police_params *params;
>+
>+	params = rcu_dereference_bh(police->params);
>+	return params->rate.rate_bytes_ps;
>+}
>+
>+static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
>+{
>+	struct tcf_police *police = to_police(act);
>+	struct tcf_police_params *params;
>+
>+	params = rcu_dereference_bh(police->params);
>+	return params->tcfp_burst;
>+}
>+
>+#endif /* __NET_TC_POLICE_H */
>diff --git a/net/sched/act_police.c b/net/sched/act_police.c
>index b48e40c69ad0..e33bcab75d1f 100644
>--- a/net/sched/act_police.c
>+++ b/net/sched/act_police.c
>@@ -22,42 +22,7 @@
> #include <net/act_api.h>
> #include <net/netlink.h>
> #include <net/pkt_cls.h>
>-
>-struct tcf_police_params {
>-	int			tcfp_result;
>-	u32			tcfp_ewma_rate;
>-	s64			tcfp_burst;
>-	u32			tcfp_mtu;
>-	s64			tcfp_mtu_ptoks;
>-	struct psched_ratecfg	rate;
>-	bool			rate_present;
>-	struct psched_ratecfg	peak;
>-	bool			peak_present;
>-	struct rcu_head rcu;
>-};
>-
>-struct tcf_police {
>-	struct tc_action	common;
>-	struct tcf_police_params __rcu *params;
>-
>-	spinlock_t		tcfp_lock ____cacheline_aligned_in_smp;
>-	s64			tcfp_toks;
>-	s64			tcfp_ptoks;
>-	s64			tcfp_t_c;
>-};
>-
>-#define to_police(pc) ((struct tcf_police *)pc)
>-
>-/* old policer structure from before tc actions */
>-struct tc_police_compat {
>-	u32			index;
>-	int			action;
>-	u32			limit;
>-	u32			burst;
>-	u32			mtu;
>-	struct tc_ratespec	rate;
>-	struct tc_ratespec	peakrate;
>-};
>+#include <net/tc_act/tc_police.h>
> 
> /* Each policer is serialized by its individual spinlock */
> 
>-- 
>2.21.0
>
