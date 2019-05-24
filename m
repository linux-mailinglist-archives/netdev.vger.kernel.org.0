Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0859E29A9E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389195AbfEXPJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:09:40 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34692 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389115AbfEXPJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:09:40 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F109C4C0058;
        Fri, 24 May 2019 15:09:38 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 24 May
 2019 08:09:34 -0700
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
 <20190522152001.436bed61@cakuba.netronome.com>
 <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
 <20190523091154.73ec6ccd@cakuba.netronome.com>
 <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
 <20190523102513.363c2557@cakuba.netronome.com>
 <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
 <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
 <93ee56f3-6e58-5c16-a20a-0aa6330741f7@mojatatu.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <7c472cb2-f98d-d25b-1b4a-9ecef99a20a3@solarflare.com>
Date:   Fri, 24 May 2019 16:09:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <93ee56f3-6e58-5c16-a20a-0aa6330741f7@mojatatu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24634.005
X-TM-AS-Result: No-3.618100-4.000000-10
X-TMASE-MatchedRID: 1GZI+iG+MtfmLzc6AOD8DfHkpkyUphL9N7FjQ+zMUh4jRiu1AuxJTNBw
        gtcF4hPytFCehSTHSffefX4+R+34xHzg44E3a45/CuDAUX+yO6apvf+jmz45wxK76+XRgurJ8GP
        Tc3PN8WhKKf7zZZFJTl7DLRKN2Zwt8VFKgEI2S3KLCYYg4B+SYevcTjVWUqx9GUs9b7xvtJoK3l
        Xnq1dqiqELFvGPZNIAQwcch8Mq0rTdqnLPvx77w8zSKGx9g8xhWjWsWQUWzVoL9Tj77wy87Hzcu
        34zeIg9uPI6Pg6StiQKKi2aCDg6YfSCkSozt+9hikdH3EQaETV9iuvWn3J8KsuSXx71bvSLCLfQ
        2FIi+mvvJlF/DXgODl+24nCsUSFNjaPj0W1qn0SujVRFkkVsm85tcF9lSXs4KbgzpT9SZUHbi9s
        2PFxL3G6cI1mPH3+qftM46/1Tl8eH+S3Bh76/Uo9FiHtsikWFVAL1ltj13F/HdSTn1yri2oVyAl
        z5A0zC7xsmi8libwVi6nHReNJA8sM4VWYqoYnhs+fe0WifpQo=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.618100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24634.005
X-MDID: 1558710580-AMPR864xHHsA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2019 15:44, Jamal Hadi Salim wrote:
> On 2019-05-24 9:57 a.m., Edward Cree wrote:
>> Argh, there's a problem: an action doesn't have a (directly) associated
>>  block, and all the TC offload machinery nowadays is built around blocks.
>> Since this action might have been used in _any_ block (and afaik there's
>>  no way, from the action, to find which) we'd have to make callbacks on
>>  _every_ block in the system, which sounds like it'd perform even worse
>>  than the rule-dumping approach.
>> Any ideas?
>
> If you have the hardware just send the stats periodically to the kernel
> and manage to map each stat to an action type/index (which i think your
> cookie seemed able to do) wouldnt this solve the problem?
Oh, a push rather than pull model?
That could work, but I worry about the overhead in the case of very large
 numbers of rules (the OVS people talk about 1 million plus) each pushing
 a stats update to the kernel every few seconds.  I'd much rather only
 fetch stats when the kernel asks for them.  (Although admittedly drivers
 already have to periodically fetch at least the stats of encap actions
 so that they know whether to keepalive the ARP entries.)
Also, getting from the cookie back to the action wouldn't be trivial; if
 there were only TC it would (just cast cookie back to a struct
 tc_action *) but soon some of these will be NF actions instead.  So
 something slightly smarter will be required.

-Ed
