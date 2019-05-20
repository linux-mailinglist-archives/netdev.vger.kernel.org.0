Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD61923C7E
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388243AbfETPqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:46:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45846 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731083AbfETPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:46:24 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id A816A4C00D4;
        Mon, 20 May 2019 15:46:22 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 May
 2019 08:46:18 -0700
Subject: Re: [RFC PATCH v2 net-next 2/3] flow_offload: restore ability to
 collect separate stats per action
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
 <b4a13b86-ae18-0801-249a-2831ec08c44c@solarflare.com>
 <49016cd0-c1c3-2bd7-d807-2b2039e12fa3@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <9790c274-445c-d3d6-a9eb-349af4103937@solarflare.com>
Date:   Mon, 20 May 2019 16:46:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <49016cd0-c1c3-2bd7-d807-2b2039e12fa3@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24624.005
X-TM-AS-Result: No-1.822800-4.000000-10
X-TMASE-MatchedRID: +c13yJDs903mLzc6AOD8DfHkpkyUphL9Ub4EdIZGxuDIxdMnZ7dlOuc8
        8VmQSVXW0UcWKbs8KfpPwZ7YSLrBJWk5Fql3Faa7oxjrap5AGQtGI9Mwxz8yaQv1OPvvDLzsTh4
        wP+rrxpO1IKRGwk5D1+IGJZ6+qv8rv1l2Uvx6idrQLWxBF9DMQcRB0bsfrpPI34T9cYMsdwyRwV
        Syfetr5Hytg1kXzfu7lxSrmZ4J6IgcdyIseFUCqaLya0+fqP3L1DXsKeBNv04EqZlWBkJWd7MZN
        ZFdSWvHG2wlTHLNY1JWXGvUUmKP2w==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.822800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24624.005
X-MDID: 1558367183-dhoD4cMWx8fk
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2019 21:35, Jamal Hadi Salim wrote:
> Your patch doesnt have U32. IIRC, I have seen stats on ixgbe with the
> u32 classifier last time i mucked around with it
> (maybe Pablo's changes removed it?).
I can't see anything stats-offload related in net/sched/cls_u32.c (just
 SW stats dumping in u32_dump()) and it doesn't call
 tcf_exts_stats_update() either.  Looking through ixgbe code I also
 don't see any sign there of stats gathering for offloaded u32 rules.

-Ed
