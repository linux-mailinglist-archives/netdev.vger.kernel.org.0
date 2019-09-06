Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 951D3ABE0A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392283AbfIFQu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:50:29 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39566 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbfIFQu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:50:29 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A111680070;
        Fri,  6 Sep 2019 16:50:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Sep
 2019 09:49:09 -0700
From:   Edward Cree <ecree@solarflare.com>
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
 <be6eee6b-9d58-f0f7-571b-7e473612e2b3@solarflare.com>
 <20190906155804.v4lviltxs72a45tq@salvia>
Message-ID: <1637ec50-daae-65df-fcaa-bfd763dbb1d9@solarflare.com>
Date:   Fri, 6 Sep 2019 17:49:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190906155804.v4lviltxs72a45tq@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24892.005
X-TM-AS-Result: No-6.447500-4.000000-10
X-TMASE-MatchedRID: 6lay9u8oTUMeimh1YYHcKB4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYMei
        MUc2ahXMBqA7CNiHt1aKUKec2gj23f4t5/APWrYh7k/A+V4ALMJQ87hSn/DSk/8yJFu97gAOLUw
        eeW1jbU43GbfgvQ9IgnLFBxl01kMzNDbolUN89NDm2EH1fEek22lx94YAg21yRjHvrQ40Nxbqr8
        lH/+vRosGLsnJdGXELBLKWMSvL2T5thJ7IXRIqNsmR5yDJkPg4jHhXj1NLbjAda1Vk3RqxOIid2
        zVEaYMLlFshCrJ3AIuZ3eRr2UpQzgmGbpOMTi81ttAWxuM5sl6W31x27U9QYjqaX1166ot195ri
        4fhj2G/5bYSVqPXjc8c23EbFTAfHeZuXD1T+SS0AhUzEvZ6RYzB4tWHctlhI+frbXg+Uc4U4Hju
        n30xe7OfOVcxjDhcwAYt5KiTiutmJhnKtQtAvVsRB0bsfrpPInxMyeYT53Rnl6ACZJWJ3AEaMpP
        yzMnL27l4AyzAz6JrTm5J/yBAF+AxX+Hk3P44Hf2GYuMA2BmtOnw0K6/0VTurMpaT7qMEwgrV3R
        rZDzioaEFYXAylB9SUSM5mwacGkICQpusqRi2ejpeaEV8oRRFZca9RSYo/b
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.447500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24892.005
X-MDID: 1567788628-bZuFuLLkOmgt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2019 16:58, Pablo Neira Ayuso wrote:
> In tc pedit ex, those are _indeed_ two separated actions: 
I read the code again and I get it now, there's double iteration
 already over tcf_exts_for_each_action and tcf_pedit_nkeys, and
 it's only within the latter that you coalesce.

However, have you considered that iproute2 (i.e. tc tool) isn't
 guaranteed to be the only userland consumer of the TC uAPI?  For all
 we know there could be another user out there producing things like
 a single pedit action with two keys, same offset but different
 masks, to mangle sport & dport separately, which your code now
 _would_ coalesce into a single mangle.  I don't know if that would
 lead to any problems, but I want to be sure you've thought about it ;)

>> Proper thing to do is have helper functions available to drivers to test
>> the pedit, and not just switch on the offset.  Why do I say that?
>>
>> Well, consider a pedit on UDP dport, with mask 0x00ff (network endian).
>> Now as a u32 pedit that's 0x000000ff offset 0, so field-blind offset
>> calculation (ffs in flow_action_mangle_entry()) will turn that into
>>  offset 3 mask 0xff.  Now driver does
>>     switch(offset) { /* 3 */
>>     case offsetof(struct udphdr, dest): /* 2 */
>>         /* Whoops, we never get here! */
>>     }
>>
>> Do you see the problem?
> This scenario you describe cannot _work_ right now, with the existing
> code. Without my patchset, this scenario you describe does _not_ work,
>
> The drivers in the tree need a mask of 0xffff to infer that this is
> UDP dport.
>
> The 'tc pedit ex' infrastructure does not allow for the scenario that
> you describe above.
>
> No driver in the tree allow for what you describe already.
Looks to me like existing nfp_fl_set_tport() handles just fine any
 arbitrary mask across the u32 that contains UDP sport & dport.
And the uAPI we have to maintain is the uAPI we expose, not the subset
 that iproute2 uses.  I could write a patched tc tool *today* that does
 a pedit of 'UDP header, offset 0, mask 0xff0000ff' and the nfp driver
 would accept that fine (no idea what the fw / chip would do with it,
 but presumably it works or Netronome folks would have put checks in),
 whereas with your patch it'll complain "invalid pedit L4 action"
 because the mask isn't all-1s.
And if I made it produce my example from above, mask 0x000000ff, you'd
 calculate an offset of 3 and hit the other error, "unsupported section
 of L4 header", which again would have worked before.
