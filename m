Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157851AD325
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 01:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgDPXXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 19:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgDPXXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 19:23:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE3C2078B;
        Thu, 16 Apr 2020 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587079383;
        bh=5noirhgriO9wYK1PbudBThy0C8L02azMslLMaA2CbMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X15/hBBkNgmo9CDdKrd58kYO2Wb2G/svsenYu6qEv5gwY9a5o1J07GnrepjO7cY75
         mfIgH1jm8DNL+US68LcUrCI5t0QZWEFxzcucCiB7H7W+Y36V0ERSZKeLIk+bwcZyIc
         EpFB1hgNpnuHCfiLUwgPUP3ZFwus+kKbp0u2EkG4=
Date:   Thu, 16 Apr 2020 19:23:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416232302.GR1068@sasha-vm>
References: <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
 <20200416172001.GC1388618@kroah.com>
 <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
 <20200416195329.GO1068@sasha-vm>
 <829c2b8807b4e6c59843b3ab85ca3ccc6cae8373.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <829c2b8807b4e6c59843b3ab85ca3ccc6cae8373.camel@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 09:32:47PM +0000, Saeed Mahameed wrote:
>On Thu, 2020-04-16 at 15:53 -0400, Sasha Levin wrote:
>> If we agree so far, then why do you assume that the same people who
>> do
>> the above also perfectly tag their commits, and do perfect selection
>> of
>> patches for stable? "I'm always right except when I'm wrong".
>
>I am welling to accept people making mistakes, but not the AI..

This is where we disagree. If I can have an AI that performs on par with
an "average" kernel engineer - I'm happy with it.

The way I see AUTOSEL now is an "average" kernel engineer who does patch
sorting for me to review.

Given I review everything that it spits out at me, it's technically a
human error (mine), rather than a problem with the AI, right?

>if it is necessary and we have a magical solution, i will write good AI
>with no false positives to fix or help avoid memleacks.

Easier said than done :)

I think that the "Intelligence" in AI suggests that it can be making
mistakes.

>BUT if i can't achieve 100% success rate, and i might end up
>introducing memleack with my AI, then I wouldn't use AI at all.
>
>We have different views on things.. if i know AI is using kmalloc
>wrongly, I fix it, end of story :).
>
>fact: Your AI is broken, can introduce _new_ un-called for bugs, even
>it is very very very good 99.99% of the cases.

People are broken too, they introduce new bugs, so why are we accepting
new commits into the kernel?

My point is that everything is broken, you can't have 100% perfect
anything.

>> Here's my suggestion: give us a test rig we can run our stable
>> release
>> candidates through. Something that simulates "real" load that
>> customers
>> are using. We promise that we won't release a stable kernel if your
>> tests are failing.
>>
>
>I will be more than glad to do so, is there a formal process for such
>thing ?

I'd love to work with you on this if you're interested. There are a few
options:

1. Send us a mail when you detect a push to a stable-rc branch. Most
people/bots reply to Greg's announce mail with pass/fail.

2. Integrate your tests into kernelci (kernelci.org) - this means that
you'll run a "lab" on prem, and kernelci will schedule builds and tests
on it's own, sending reports to us.

3. We're open to other solutions if you had something in mind, the first
two usually work for people but if you have a different requirement
we'll be happy to figure it out.

-- 
Thanks,
Sasha
