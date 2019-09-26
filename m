Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024A3BF506
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 16:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfIZO0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 10:26:31 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:35968 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbfIZO0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 10:26:31 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 30699B40056;
        Thu, 26 Sep 2019 14:26:29 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 26 Sep
 2019 07:26:09 -0700
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
 <08f58572-26ed-e947-5b0c-73732ef7eb35@solarflare.com>
 <ecfb7918-7660-91f0-035e-56f58a41dc17@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3aff5059-c28c-f194-72f0-69edddf89f84@solarflare.com>
Date:   Thu, 26 Sep 2019 15:26:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ecfb7918-7660-91f0-035e-56f58a41dc17@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24934.005
X-TM-AS-Result: No-8.489400-4.000000-10
X-TMASE-MatchedRID: Jm7Yxmmj9OnmLzc6AOD8DfHkpkyUphL9Y8ipJLwHMqHVU2WiOk7jaPf9
        5jG0giQwhL51VcQsjLNibFMXO8aJ79oA6mgeU1rtfDrjzXCwK0KWGk93C/VnSk3hJDbXzhXf64b
        NpTYv99LXMBcv3R4pcoDH02jiwWT8T09fC9Tx660TF1LtYW9la6a83Mq89i9dWoQBC/aPk1tVds
        3zwgq4tHmX776TUspq++EeQgqoy14vKbWkeTMxcoA7SSmAp7NElzlaNFD3vRQKawseZ6xdsTPqf
        jabMGZqdsHCDX3Hk45hwxcuUkADDm2VJqCRBdqh/ccgt/EtX/2wqLgRdvwAirobGHR5ejtr5wxI
        yyhRieMbkKUBXyytFeE6dTjJ5eoVbKQR9AbhCu/stdmnk4+gs32K69afcnwqFb73eKpG9fun+Dt
        AMiWC3aTXq8CAzkn17uiIyPP00OurrSkYGEOTNRlJKXOepS1tELbqrOgWzyekXmvMFAHUOjuzT+
        42naSwbvKbDDavj3aABhmXQhuiGL9ZdlL8eonaRjjVhf+j/wpKdDgyPBo71yq2rl3dzGQ1hH05f
        N5bubBmL8kBav/KgkTCcso1LKwHqGQa5dcwM646s2kyA7ZEKA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.489400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24934.005
X-MDID: 1569507990-8dKCloKJsZnt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2019 14:56, Paul Blakey wrote:
>>> In nat scenarios the packet will be modified, and then there can be a miss:
>>>
>>>              -trk .... CT(zone X, Restore NAT),goto chain 1
>>>
>>>              +trk+est, match on ipv4, CT(zone Y), goto chain 2
>>>
>>>              +trk+est, output..
>> I'm confused, I thought the usual nat scenario looked more like
>>      0: -trk ... action ct(zone x), goto chain 1
>>      1: +trk+new ... action ct(commit, nat=foo) # sw only
>>      1: +trk+est ... action ct(nat), mirred eth1
>> i.e. the NAT only happens after conntrack has matched (and thus provided
>>   the saved NAT metadata), at the end of the pipe.  I don't see how you
>>   can NAT a -trk packet.
> Both are valid, Nat in the first hop, executes the nat stored on the 
> connection if available (configured by commit).
This still isn't making sense to me.
Until you've done a conntrack lookup and found the connection, you can't
 use NAT information that's stored in the connection.
So the NAT can only happen after a conntrack match is found.

And all the rest of your stuff (like doing conntrack twice, in different
 zones X and Y) is 'weird' inasmuch as it's beyond the basic minimum
 functionality for a useful offload, and inherently doesn't map to a
 fixed-layout (non-loopy) HW pipeline.  You may want to support it in
 your driver, you may be able to support it in your hardware, but it's
 not true that "even nat needs that" (the nat scenario I described above
 is entirely reasonable and is perfectly workable in an all-or-nothing
 offload world), so if your changes are causing problems, they should be
 reverted for this cycle.

>> AFAICT only 'deliverish' actions (i.e. mirred and drop) in TC have stats.
>> So stats are unlikely to be a problem unless you've got (say) a mirred
>>   mirror before you send to ct and goto chain, in which case the extra
>>   copy of the packet is a rather bigger problem for idempotency than mere
>>   stats ;-)
> All tc actions have software stats, and at least one (goto, mirred, 
> drop) per OvS generated rule will have hardware stats.
Ooh, goto has hardware stats?  That's something I hadn't spotted *re-
 draws hardware design slightly*

> All OvS datapath rules have stats, and in turn the translated TC rules 
> all have stats. OvS ages each rule independently.
TC rules do not have stats.  Only TC actions have stats.  (The offload
 API currently gets confused about this and it's really annoyed me...)
