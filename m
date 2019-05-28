Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD972CBF0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfE1Q2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:28:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:44472 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbfE1Q2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:28:00 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6B2D9280074;
        Tue, 28 May 2019 16:27:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 28 May
 2019 09:27:53 -0700
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
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
 <20190524100329.4e1f0ce4@cakuba.netronome.com>
 <355202da-6c69-1034-eb29-e03edfe0fe2c@solarflare.com>
 <20190524104436.35bf913b@cakuba.netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <445ff0d5-970b-630f-48ec-fbb142971f28@solarflare.com>
Date:   Tue, 28 May 2019 17:27:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524104436.35bf913b@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24642.005
X-TM-AS-Result: No-3.525200-4.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTrmLzc6AOD8DfHkpkyUphL9GUqOjzOC7IqkXmvMFAHUOguS
        BjgYIzxY437kaUxdodpHBaYvF0hxKC/BzHgNxUHbA9lly13c/gEXyU2CxtlxbxFEN8nvOwBuZVh
        gLjSOksbhtGvaWlcw9AvXaO85D6XXahH+l6+69liFU125L7WL70U0ajo7/0as5ff2v4XuwDAaeK
        cuYXKyDbhhvpywZ4GXqzgxN+XwmJnuezoCLR2EmSLwHWeM/YISQMOnckSMD0VJfyfUaPjAAaZk8
        Fiou8cBQOaAfcvrs35Cvtb/aH4jvb9ZdlL8eonaC24oEZ6SpSmb4wHqRpnaDhLP8yhMc0y6KGFL
        wooHhlUopizxUbg943tnHTUkalBwregeJjOvyas79UNXzTMqpLAPRkDTSgsJXZ+dvfNO4ZOwfdz
        UFYhYBYfMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYNFU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.525200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24642.005
X-MDID: 1559060879-4Dqh8IXkjJuQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2019 18:44, Jakub Kicinski wrote:
> On Fri, 24 May 2019 18:27:39 +0100, Edward Cree wrote:
>> On 24/05/2019 18:03, Jakub Kicinski wrote:
>>> Simplest would be to keep a list of offloaders per action, but maybe
>>> something more clever would appear as one rummages through the code.  
>> Problem with that is where to put the list heads; you'd need something that
>>  was allocated per action x block, for those blocks on which at least one
>>  offloader handled the rule (in_hw_count > 0).
> I was thinking of having the list per action, but I haven't looked at
> the code TBH.  Driver would then request to be added to each action's
> list..
The problem is not where the list goes, it's where the list_head for each
 item on the list goes.  I don't want the driver to have to do anything to
 make this happen, so the core would have to allocate something to hold a
 list_head each time a driver successfully offloads an action.

>> TBH I'm starting to wonder if just calling all tc blocks in existence is
>>  really all that bad.  Is there a plausible use case with huge numbers of
>>  bound blocks?
> Once per RTM_GETACTION?  The simplicity of that has it's allure..
OTOH I'm now finding that it's really quite hard to get "all tc blocks in
 existence" as a thing, so it's not as simple as it seemed, sadly.

> It doesn't give you an upstream user for a cookie, though :S
I don't think any of these approaches do; an upstream user necessarily
 involves an upstream driver that collects per-action stats, rather than
 the per-rule that they all do today.  RTM_GETACTION offload won't change
 that, because those drivers won't be able to support it either for the
 same reason.

-Ed
