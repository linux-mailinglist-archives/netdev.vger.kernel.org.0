Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A28BF3BE
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfIZNJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:09:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55912 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbfIZNJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 09:09:19 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A03CC10006E;
        Thu, 26 Sep 2019 13:09:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 26 Sep
 2019 06:09:12 -0700
Subject: Re: CONFIG_NET_TC_SKB_EXT
To:     Paul Blakey <paulb@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
 <1569153104-17875-1-git-send-email-paulb@mellanox.com>
 <20190922144715.37f71fbf@cakuba.netronome.com>
 <68c6668c-f316-2ceb-31b0-8197d22990ae@mellanox.com>
 <d6867e6c-2b81-5fcd-1d88-46663bed6e26@solarflare.com>
 <4f99e2b6-0f09-9d2c-6300-dfc884d501a8@mellanox.com>
 <3c09871f-a367-56ca-0d25-f0699a7b79d0@solarflare.com>
 <541fde6d-01ce-edf3-84e4-153756aba00f@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <08f58572-26ed-e947-5b0c-73732ef7eb35@solarflare.com>
Date:   Thu, 26 Sep 2019 14:09:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <541fde6d-01ce-edf3-84e4-153756aba00f@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24934.005
X-TM-AS-Result: No-3.266000-4.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1jmLzc6AOD8DfHkpkyUphL9IiTd2l7lf6EW6M2A15L1QIi6
        yFTH7VfQssXNVaazvgK0+AmH3RJfFxLmJd2F/yFupqbreSinCdP2hUAowGKipwS4ecLQ371kAUq
        wO9pSIT3pJqptUa8m8FeXIe0wAGNURXNf1eTQ0pviHyvyXeXh5pbfXHbtT1BiabJxhiIFjJkWd4
        rBwTzCYVSJctOIDSePm5pMGphf0ZXT1VVKbhb4L1xWWs3RUcVrg995jv1FbzMqAZlo5C3Li2ajM
        +Kk6cVqvpXyASBuZYSC5hlnEK02ZTXfM+vmulo5Iwk7p1qp3JYZSo6PM4LsihERaA/AH4sBLN7Y
        /j9rSN/gjmbI74RE4uNlgvH35nu1v1l2Uvx6idoPXo4gvwUD3Up0ODI8GjvXKrauXd3MZDV+ULr
        uOUpvPtEF4FuLhcGnoa6lCpSUq7tLI8vsziJZizIBT6ZW9CLp8pgGQs1Es89m+fwXMrUlSK36Xy
        PGjmB4YRb7LQzIelBKvg/6pXRnywbEQIfFpkwHBtlgFh29qnpKzBwu5JpklloKRXQm7FH3
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.266000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24934.005
X-MDID: 1569503359-D1GYN67-OWWT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2019 08:30, Paul Blakey wrote:
> Ok, I thought you meant merging the rules because we do want to support 
> those modifications use-cases.
I think the point is that your use-case is sufficiently weird and
 obscure that code in the core to support it needs to be unintrusive;
 and this clearly wasn't (you managed to piss off Linus...) so it
 should be reverted, and held off until a more palatable solution can
 be produced.  I agree with Alexei on this.
Neither currently-supported-by-drivers cases nor the first step that's
 likely to be added (the simple conntrack with modifications only at
 the end) needs this, it's for capabilities that are farther in the
 future, so there's really no need for it to be in the tree when it's
 not ready, which appears to be the case at present.
> In nat scenarios the packet will be modified, and then there can be a miss:
>
>             -trk .... CT(zone X, Restore NAT),goto chain 1
>
>             +trk+est, match on ipv4, CT(zone Y), goto chain 2
>
>             +trk+est, output..
I'm confused, I thought the usual nat scenario looked more like
    0: -trk ... action ct(zone x), goto chain 1
    1: +trk+new ... action ct(commit, nat=foo) # sw only
    1: +trk+est ... action ct(nat), mirred eth1
i.e. the NAT only happens after conntrack has matched (and thus provided
 the saved NAT metadata), at the end of the pipe.  I don't see how you
 can NAT a -trk packet.

> Also, there are stats issues if we already accounted for some actions in 
> hardware.
AFAICT only 'deliverish' actions (i.e. mirred and drop) in TC have stats.
So stats are unlikely to be a problem unless you've got (say) a mirred
 mirror before you send to ct and goto chain, in which case the extra
 copy of the packet is a rather bigger problem for idempotency than mere
 stats ;-)
