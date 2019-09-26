Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8BEBF749
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfIZRCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:02:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:42778 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbfIZRCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 13:02:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2C8C9340081;
        Thu, 26 Sep 2019 17:02:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 26 Sep
 2019 10:02:27 -0700
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
 <3aff5059-c28c-f194-72f0-69edddf89f84@solarflare.com>
 <5ae6ca73-3683-b907-85fd-3d09bed9b68e@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <6211913e-739e-77ac-e63d-e6ac3af901e7@solarflare.com>
Date:   Thu, 26 Sep 2019 18:02:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5ae6ca73-3683-b907-85fd-3d09bed9b68e@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24934.005
X-TM-AS-Result: No-4.087300-4.000000-10
X-TMASE-MatchedRID: gjZGo2H/wj/mLzc6AOD8DfHkpkyUphL9Y8ipJLwHMqHVU2WiOk7jaPf9
        5jG0giQwhL51VcQsjLNibFMXO8aJ79oA6mgeU1rtfDrjzXCwK0KWGk93C/VnSk3hJDbXzhXf64b
        NpTYv99LXMBcv3R4pcoDH02jiwWT8T09fC9Tx660TF1LtYW9la6a83Mq89i9dWoQBC/aPk1tVds
        3zwgq4tHmX776TUspq++EeQgqoy14+oSWIq9TCHLRjNHAQ1DONNACXtweanwZVCTrtVIPWukdIT
        nzIXC0rM/bMSwa+JiaoopjLD0sPPTiULkq/3BRubRZGrsoeW/gZSo6PM4Lsil4PeqT5cXCSiMhu
        xJgbFV0B1yfHlSIChb6Asf18V7tNcB7/IGzaDP4SaNOldpR03uqhuTPUDQDt+frbXg+Uc4XUoby
        HIcIzrjdJ8QfbChLF2SdFMmtXAB2oGSK7rXzPTUV3YrpGUAoBwyHj5gB7sg97eGs179ltWYstNW
        RuMmhqTAGkGOzdOEoN59c8+PodVDcpdZ3fQiLdgxsfzkNRlfLaf1N18C+ZAhe9CQaLe2PPjoczm
        uoPCq1JDy4UEI2WZGc++YYLQnMODjbR0dS01ohAFYSErQN8g83ZD/jg9Bl+oed+SvBN2uKysETr
        LPCQyfnn5aRHJOe4o207Lf7eejji+fTMx9KaNitss6PUa4/cD6GAt+UbooSj1CO4X0Eqed8x3qz
        oMNxx
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.087300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24934.005
X-MDID: 1569517353-92i4mbEKSyZ8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2019 16:14, Paul Blakey wrote:
> On 9/26/2019 5:26 PM, Edward Cree wrote:
>> On 26/09/2019 14:56, Paul Blakey wrote:
>>>>> In nat scenarios the packet will be modified, and then there can be a miss:
>>>>>
>>>>>               -trk .... CT(zone X, Restore NAT),goto chain 1
>>>>>
>>>>>               +trk+est, match on ipv4, CT(zone Y), goto chain 2
>>>>>
>>>>>               +trk+est, output..
>>>> I'm confused, I thought the usual nat scenario looked more like
>>>>       0: -trk ... action ct(zone x), goto chain 1
>>>>       1: +trk+new ... action ct(commit, nat=foo) # sw only
>>>>       1: +trk+est ... action ct(nat), mirred eth1
>>>> i.e. the NAT only happens after conntrack has matched (and thus provided
>>>>    the saved NAT metadata), at the end of the pipe.  I don't see how you
>>>>    can NAT a -trk packet.
>>> Both are valid, Nat in the first hop, executes the nat stored on the
>>> connection if available (configured by commit).
>> This still isn't making sense to me.
>> Until you've done a conntrack lookup and found the connection, you can't
>>   use NAT information that's stored in the connection.
>> So the NAT can only happen after a conntrack match is found.
> That's how it works, CT action restores the metadata (nf_conn on the 
> SKB), you can then, if needed,  execute the nat,
Yes, and 'setting metadata' is idempotent (or reversible, if you prefer)
 so it doesn't matter if HW does it and then says "oops, can't do this"
 and software path starts from chain 0.
Problems only appear if you have _more matching_ after executing the NAT,
 in which case you're not a "simple NAT use-case" any more but rather the
 more complicated thing.

> The change didn't cause any problem
I mean, this whole thread is here because it *did* cause a problem:
 skb-extensions being turned on when not really needed.

> As we are discussing the config default, I've sent a patch to set the
> config to N.
As others have pointed out upthread, distros will just enable it anyway,
 regardless of the default.  As Daniel said,
> Adding new skb extensions should really have a strong justification behind
> it (close but slightly less strict to how we treat adding new members to
> skb itself). 
I'd also like to see a clear explanation of why you need extra out-of-skb
 storage space for this and can't use skb->tc_index as suggested by Pravin.
