Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEFABBF9
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389219AbfIFPNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:13:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55682 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729088AbfIFPNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:13:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1403AB8005A;
        Fri,  6 Sep 2019 15:13:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Sep
 2019 08:13:18 -0700
Subject: Re: [PATCH net-next,v3 0/4] flow_offload: update mangle action
 representation
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jakub.kicinski@netronome.com>,
        <jiri@resnulli.us>, <saeedm@mellanox.com>, <vishal@chelsio.com>,
        <vladbu@mellanox.com>
References: <20190906000403.3701-1-pablo@netfilter.org>
 <679ced4b-8bcd-5479-2773-7c75452c2a32@solarflare.com>
 <20190906105638.hylw6quhk7t3wff2@salvia>
 <b8baf681-b808-4b83-d521-0353c3136516@solarflare.com>
 <20190906131457.7olkal45kkdtbevo@salvia>
 <35ac21be-ff2f-a9cd-dd71-28bc37e8a51b@solarflare.com>
 <20190906145019.2bggchaq43tcqdyc@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <be6eee6b-9d58-f0f7-571b-7e473612e2b3@solarflare.com>
Date:   Fri, 6 Sep 2019 16:13:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190906145019.2bggchaq43tcqdyc@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24892.005
X-TM-AS-Result: No-12.941200-4.000000-10
X-TMASE-MatchedRID: cxtZ8fwm3r8eimh1YYHcKB4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYHQ7
        c/s1EnkfFjGWt2FXzm3YnvwuHYT0lueiDxJcK5MJi+quUbDYb+T2hUAowGKip63IiVD2OFIx6Za
        mopeZkvkka5MiZO1ulOdnr/in5DtFNKnO1vGWufXB7F9jxUX48iILdc+InEErVtYy28d/67qYgr
        VekbVGjWMOYwJcWd0kSYJ/FzwnGEbImuJG/muc0aKa0xB73sAAeouvej40T4j3auHSPFNajADCX
        Bzs8w7j/aTpeC4wsRTm08Df+RptejCitzEOtuK1hUy0TABax1xJaD67iKvY00eRNQFi4zev7kOM
        rBz6LknZYix/V81kpaY9k5zFch27Hv8ZmUNd5ssmGnPVO3QinxfbPFE2GHrVRJts9OIxqBMz6n4
        2mzBmalWrn6UBj2xcJrqaPLhEiE9BJacAbR6CMQrgwFF/sjum9l9p8mNlkgkcbecIrrLrmRbC99
        SYja1gplohFVq6HxmwTxtH2eEAisoWpgSv7kVyW1M77Gh1ugYKF0jiwuWuOBf/NXBpnlbDmKbhu
        5KaCkcaBejRu8ydpl+24nCsUSFNt7DW3B48kkHdB/CxWTRRu25FeHtsUoHuvJ2XGXgMtBBVrwhn
        OSWcXTEyKdvVWdNBdcn17rSLztmwFMlIPaIBbQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.941200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24892.005
X-MDID: 1567782813-3q_YbmY8-GSn
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2019 15:50, Pablo Neira Ayuso wrote:
> On Fri, Sep 06, 2019 at 02:37:16PM +0100, Edward Cree wrote:
>> On 06/09/2019 14:14, Pablo Neira Ayuso wrote:
>>> OK, I can document this semantics, I need just _time_ to write that
>>> documentation. I was expecting this patch description is enough by now
>>> until I can get to finish that documentation.
>> I think for two structs with apparently the same contents but different
>>  semantics (one has the mask bitwise complemented) it's best to hold up
>>  the code change until the comment is ready to come with it, because
>>  until then it's a dangerously confusing situation.
> The idea is that flow rule API != tc front-end anymore. So the flow
> rule API can evolve regardless the front-end requirements. Before this
> update there was no other choice than using the tc pedit layout since
> it was exposed to the drivers, this is not the case anymore.
I'm not saying that they have to be the same.
I'm saying that they're _almost_ the same, and having things that are
 _almost_ the same but subtly different is a recipe for misunderstandings
 and bugs, and so must must must have very visible comments in the code.

>> So an IPv6 address mangle only comes as a single action if it's from
>>  netfilter, not if it's coming from TC pedit.
> Driver gets one single action from tc/netfilter (and potentially
> ethtool if it would support for this), it comes as a single action
> from both subsystems:
>
>         front-end -----> flow_rule API -----> drivers
>
> Front-end need to translate their representation to this
> FLOW_ACTION_MANGLE layout.
>
> By front-end, I refer to ethtool/netfilter/tc.
In your patch, flow_action_mangle() looks only at the offset and type
 (add vs. set) of each pedit, coalesces them if compatible (so, unless
 I'm misreading the code, it _will_ coalesce adjacent pedits to
 contiguous fields like UDP sport & dport, unlike what you said),
 because it doesn't know whether two contiguous pedits are part of the
 same field or not (it doesn't have any knowledge of 'fields' at all).
And for you to change that, while still coalescing IPv6 pedits, you
 would need flow_action_mangle() to know what fields each pedit is in.
It is not possible for code that doesn't know about fields to both:
 (a) not coalesce edits of contiguous fields, and
 (b) coalesce edits of larger-than-u32 fields

>>  Yes, but we don't add code/features to the kernel based on what we
>>  *could* use it for later
> This is already useful: Look at the cxgb driver in particular, it's
> way easier to read.
Have you tested it?  Again, I might be misreading, but it looks like
 your flow_action_mangle() *will* coalesce sport & dport, which it
 appears will break that cxgb code.

> Other existing drivers do not need to do things like:
>
>         case round_down(offsetof(struct iphdr, tos), 4):
>
> and the play with masks to infer if the user wants to mangle the TOS
> field, they can just do:
>
>         case offsetof(struct iphdr, tos):
>
> which is way more natural representation.
Proper thing to do is have helper functions available to drivers to test
 the pedit, and not just switch on the offset.  Why do I say that?
Well, consider a pedit on UDP dport, with mask 0x00ff (network endian).
Now as a u32 pedit that's 0x000000ff offset 0, so field-blind offset
 calculation (ffs in flow_action_mangle_entry()) will turn that into
 offset 3 mask 0xff.  Now driver does
    switch(offset) { /* 3 */
    case offsetof(struct udphdr, dest): /* 2 */
        /* Whoops, we never get here! */
    }
Do you see the problem?

-Ed
