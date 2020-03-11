Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332A9181FB9
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgCKRmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:42:03 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35326 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbgCKRmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:42:03 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7AEDAB4007D;
        Wed, 11 Mar 2020 17:42:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 11 Mar
 2020 17:41:55 +0000
Subject: Re: [PATCH net-next ct-offload v3 04/15] net/sched: act_ct:
 Instantiate flow table entry actions
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>, Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <1583937238-21511-5-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5b3b483b-28c8-6c08-7ce8-365cb717061a@solarflare.com>
Date:   Wed, 11 Mar 2020 17:41:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1583937238-21511-5-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25282.003
X-TM-AS-Result: No-3.240900-8.000000-10
X-TMASE-MatchedRID: +c13yJDs903mLzc6AOD8DfHkpkyUphL9B4bXdj887A8Lt1T6w2Ze0t5Q
        ZVAH5Zt2YWTnOnMH547fbYqgOvx6nZ6CKaYYGfNGR0BY8wG7yRA1TzP60UkdHQpCjqVELlwVAUq
        wO9pSIT3FvR79VTGSepGTpe1iiCJq71zr0FZRMbCWlioo2ZbGwdmzcdRxL+xwKrauXd3MZDXR6k
        VvraNdYkLqIQZwo5PWrYEMs97jbn6w+vCBTngIWBrlB7/RN6LRYXj+q70+6YlGC69Fzy85mSvEG
        xffHBZ50N8JQB37LON71rPJhqlKdCmrallLEixoqiftjGsrnVLHLBltO4st2oaYisIWXdvdQwym
        txuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.240900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25282.003
X-MDID: 1583948522-055wKUv4I1KR
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2020 14:33, Paul Blakey wrote:
> NF flow table API associate 5-tuple rule with an action list by calling
> the flow table type action() CB to fill the rule's actions.
>
> In action CB of act_ct, populate the ct offload entry actions with a new
> ct_metadata action. Initialize the ct_metadata with the ct mark, label and
> zone information. If ct nat was performed, then also append the relevant
> packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).
>
> Drivers that offload the ft entries may match on the 5-tuple and perform
> the action list.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Edward Cree <ecree@solarflare.com>
