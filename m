Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B801D3511
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgENP22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:28:28 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45512 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgENP21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 11:28:27 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 290C96004F;
        Thu, 14 May 2020 15:28:27 +0000 (UTC)
Received: from us4-mdac16-5.ut7.mdlocal (unknown [10.7.65.73])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 272318009B;
        Thu, 14 May 2020 15:28:27 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9B9E2280077;
        Thu, 14 May 2020 15:28:26 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ED40C80067;
        Thu, 14 May 2020 15:28:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 14 May
 2020 16:28:18 +0100
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
 <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
 <20200514144938.GD2676@nanopsycho>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <9f68872f-fe3f-e86a-4c74-8b33cd9ee433@solarflare.com>
Date:   Thu, 14 May 2020 16:28:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200514144938.GD2676@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25418.003
X-TM-AS-Result: No-7.636200-8.000000-10
X-TMASE-MatchedRID: WMT2WRIkHPPmLzc6AOD8DfHkpkyUphL9tb3wUEoASahjQ6o1zjtGHmly
        s1PDhWLozIy4Q+OIZUdSRjDchGmLVbgbDPVqku26elGHXZKLL2vnaaW2UTafyDa3GWz2bI6y8L/
        ILA9mjjEYo7RMqStNcbDwMtEIPtS51/wsMGlHprqTCCj1265aFzQAl7cHmp8GvPwQoyIZS6ec/2
        wcFt9opK1u9NkuhgWrLE9oBaZFmG8PYhHfxrN+Web3p4cnIXGNSWg+u4ir2NOQ4Ed55cYAep0lh
        LiscuITjv6fRVEmNSozEHCDmE/LW/V/oQGRS0ppSVHYMTQ1F1qATgUFUNHeQ0l/J9Ro+MABMbzd
        fw2kMg0rqZTTVWKH2K2dpW2xaCxL/VKd+1TPKc6/W88A/PbYWczzMs2dyeyVUCgEErrUGFwaVcz
        YFcSVKMIXpS6Zk3foQIHljAlJOfGfImtD24d/xJ4CIKY/Hg3AcmfM3DjaQLHEQdG7H66TyMdRT5
        TQAJnAG0IV3ngEbr3RqRsfyHxKmn5sRqrftACXPkGoS9kJm8+eqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.636200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25418.003
X-MDID: 1589470107-M8g8fmyk0Lhy
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/05/2020 15:49, Jiri Pirko wrote:
> Thu, May 14, 2020 at 04:04:02PM CEST, ecree@solarflare.com wrote:
>> Either way, the need to repeat the policy on every tc command suggests
>>  that there really ought to instead be a separate API for configuring
>>  conntrack offload policy, either per zone or per (zone, device) pair,
>>  as appropriate.
> You don't have to repeat. You specify it in the first one, in the rest
> you omit it.
Ok, well (a) the commit message needs changing to make that clear, and
 (b) that kind of implicit action-at-a-distance slightly bothers me.
If you don't repeat, then the order of tc commands matters, and any
 program (e.g. OvS) generating these commands will need to either keep
 track of which zones it's configured policy for already, or just
 repeat on every command just in case.
It really doesn't feel like an orthogonal, Unixy API to me.

<offtopic rambliness="very">
TBH I think that when a tc rule with a ct action is offloaded, drivers
 should get three callbacks in order:
1) a CT zone callback (if the CT zone is 'new')
2) an action callback, including a pointer to the CT zone info (in case
  the driver chose to ignore the CT zone callback because it had no
   offloading work to do at that point) (if the action is 'new')
3) a rule callback, including a pointer to the action info (in case the
   driver ignored the action creation).
And each of these should be drivable directly from userspace as well as
 being called automatically by the level below it.
Currently we have (2) as a distinct entity in TC, but no-one offloads
 it (and as I've ranted before, that makes a mess of stats) and AIUI
 it's not called when user creates a rule, only when using 'tc action'
 command directly).  And (1) doesn't exist at all; drivers just have
 to notice the first time a tc ct action they're offloading mentions a
 given zone, and call into nf_flow_table_offload to register for
 tracked conns in that zone.  I feel that this hierarchical 'offload
 dependencies first' model would make drivers simpler and more robust,
 as well as helping to ensure different drivers share a consistent
 interpretation of the API.
RFC on the above?  Obviously I'm not likely to start implementing it
 until after we have a TC-supporting sfc driver upstream (it's coming
 Real Soon Now™, I swear!) but I thought it worthwhile to throw the
 design up for discussion earlier rather than later.
</offtopic>

-ed
