Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DF71ADE27
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 15:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgDQNV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 09:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729760AbgDQNV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 09:21:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75D4920724;
        Fri, 17 Apr 2020 13:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587129685;
        bh=J8eWNPPYvc/+m8n7EeDElpmichO9EaeG/pSP1F5xLaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KM+d2RWHl5hRqnIQMJDI8JdAWq5uLF7LZE45s9Jrrb5m2x6ViGABYKCOVtPOBmP1n
         +emWaocsfd+ajox0+3V9/r6MSbYiAcdWSMyzMSuzYU7CBsxvm1ID9GY22nDVfPkuVC
         V/S9k+ct6R5kf2mTe8jlNZ68iDMQ42+NnExezCSE=
Date:   Fri, 17 Apr 2020 09:21:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200417132124.GS1068@sasha-vm>
References: <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
 <20200416052409.GC1309273@unreal>
 <20200416133001.GK1068@sasha-vm>
 <550d615e14258c744cb76dd06c417d08d9e4de16.camel@mellanox.com>
 <20200416195859.GP1068@sasha-vm>
 <3226e1df60666c0c4e3256ec069fee2d814d9a03.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3226e1df60666c0c4e3256ec069fee2d814d9a03.camel@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 09:08:06PM +0000, Saeed Mahameed wrote:
>On Thu, 2020-04-16 at 15:58 -0400, Sasha Levin wrote:
>> Hrm, why? Pretend that the bot is a human sitting somewhere sending
>> mails out, how does it change anything?
>>
>
>If i know a bot might do something wrong, i Fix it and make sure it
>will never do it again. For humans i just can't do that, can I ? :)
>so this is the difference and why we all have jobs ..

It's tricky because there's no one true value here. Humans are
constantly wrong about whether a patch is a fix or not, so how can I
train my bot to be 100% right?

>> > > The solution here is to beef up your testing infrastructure
>> > > rather
>> > > than
>> >
>> > So please let me opt-in until I beef up my testing infra.
>>
>> Already did :)
>
>No you didn't :), I received more than 5 AUTOSEL emails only today and
>yesterday.

Appologies, this is just a result of how my process goes - patch
selection happened a few days ago (which is when blacklists are
applied), it's been running through my tests since, and mails get sent
out only after tests.

>Please don't opt mlx5 out just yet ;-), i need to do some more research
>and make up my mind..

Alrighty. Keep in mind you can always reply with just a "no" to AUTOSEL
mails, you don't have to explain why you don't want it included to keep
it easy.

>>
>> > > taking less patches; we still want to have *all* the fixes,
>> > > right?
>> > >
>> >
>> > if you can be sure 100% it is the right thing to do, then yes,
>> > please
>> > don't hesitate to take that patch, even without asking anyone !!
>> >
>> > Again, Humans are allowed to make mistakes.. AI is not.
>>
>> Again, why?
>>
>
>Because AI is not there yet.. and this is a very big philosophical
>question.
>
>Let me simplify: there is a bug in the AI, where it can choose a wrong
>patch, let's fix it.

But we don't know if it's wrong or not, so how can we teach it to be
100% right?

I keep retraining the NN based on previous results which improves it's
accuracy, but it'll never be 100%.

The NN claims we're at ~95% with regards to past results.

-- 
Thanks,
Sasha
