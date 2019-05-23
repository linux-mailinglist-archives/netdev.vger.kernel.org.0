Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C27283F9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfEWQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:40:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:41888 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730860AbfEWQkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:40:15 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 91BBD100081;
        Thu, 23 May 2019 16:40:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 23 May
 2019 09:40:10 -0700
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
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
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
Date:   Thu, 23 May 2019 17:40:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523091154.73ec6ccd@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24632.005
X-TM-AS-Result: No-6.766400-4.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/mLzc6AOD8DfHkpkyUphL9XJA/Fl7SXBZXPwnnY5XL5I0G
        9GYox3FwOz1E6FgFv0Kr/o2jetZa3hEg9BQLlw7hH9HlIp7fUBEiJN3aXuV/oYe/yi1B5QhCXjw
        VeD9RB3i3yLre9zwqKJUzqv7eBI1ybux2SLvUTJCuYnHEVdQN2Iab/1O/b86BHWtVZN0asTj7pf
        +naBsGbOrWwuhgi5lwAEedHd6FwXOO6ma37ITh7r5k9lVEXoZaCDfsc2VilxDMJPlLTHpcvKPFj
        JEFr+olA6QGdvwfwZYNXwNUB3oA790H8LFZNFG7hqz53n/yPnp/6p0dIXsQat/I/DDwUbiHuER7
        9p07z+xNTJsDyaQJfklLd09OvFjP
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.766400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24632.005
X-MDID: 1558629615-Ei3lYHM__ADw
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2019 17:11, Jakub Kicinski wrote:
> On Thu, 23 May 2019 09:19:49 -0400, Jamal Hadi Salim wrote:
>> That would still work here, no? There will be some latency
>> based on the frequency of hardware->kernel stats updates.
> I don't think so, I think the stats are only updated on classifier
> dumps in Ed's code.
Yep currently that's the case, but not as an inherent restriction (see
 my other mail).

> But we can't be 100% sure without seeing driver code.
Would it help if I posted my driver code to the list?  It's gonna be
 upstream eventually anyway, it's just that the driver as a whole
 isn't really in a shape to be merged just yet (mainly 'cos the
 hardware folks are planning some breaking changes).  But I can post
 my TC handling code, or even the whole driver, if demonstrating how
 these interfaces can be used will help matters.

-Ed
