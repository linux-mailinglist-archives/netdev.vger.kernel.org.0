Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42981D48A7
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgEOIio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726894AbgEOIin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 04:38:43 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D1FC05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 01:38:42 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id e125so347491lfd.1
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 01:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sXRSs/9NMJKgVBS5peisoJGVjTMEyPBHrie3FIkiVVo=;
        b=ESGDxtEwDZMyvCjTLjTXkHtxqcj/ILNJpSRAuD9+GoJtCNy5ZOZGmWpSeRq2Ok+SXR
         464LnTE7p1J1qLbQ7tf/DGPzM0MzCMR6SOujzfUptAPyh3/noO6XhdALEhxjf1oLXN3D
         /3tXiYrqaPVbZL02DueqmzidRr/v+Hq1xXtUgyPzW2W4nhFdmZhWtX4sS0mVgmYScDQu
         xTwitk00AMMKQgs+VAhUcGe62oTZyog4I/E6v9NL0oJzN1EcV6c7MXkVBC9BCe+W8+tt
         AOJuNalHurQpRs034FRbfpmAha6AtWXpb4V/Il2qNNMYHLcW5HkSXAMoXR0fO8eF+ZLV
         RjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sXRSs/9NMJKgVBS5peisoJGVjTMEyPBHrie3FIkiVVo=;
        b=fmSdbl/SdIOKRfVu/UC0toJr4HJDQaDLyhd9WicxmvJAy6Y6gpgIpXpyAExmf0Mg6R
         3UOuP/S0kUdkpxGG9Unc5QKaqa7E5sKWw0VW9sVYUZPwtAXjZec3p0yp7pRuRsX0ZO5r
         RgPMhmlbGTaUaNSxtpC/M93AzHyP70PV9U6AhLx87g/mfhYbJIf3eLNlmHX/0tHliixQ
         hAgv++cBqT857p+rHNUxg8iZWUfAOySSfXGJH9tFSZJYNyCNryj0gIMinAqFs+uv0Atk
         5iVdzK30owxCrEIcY4j8fpg9N8JELUMI5c7DOUfwJk9u2DdmnzIZnVzYXJpHGjxb0/TU
         cHkQ==
X-Gm-Message-State: AOAM5315NLCE8PCjVDbWVNuHuFDmCOQzIsfivNdCZPIVPgLMxpOioasC
        k012b3X3cF9s0RHnAmYg4S3T/Q==
X-Google-Smtp-Source: ABdhPJxIwCfPo7LL1CDPr/t6yU3XEg1Qyl7PhP16CcGW8J2V1WPxl0r6u9lzfrC6c5/h2dtxoGZvJQ==
X-Received: by 2002:a19:84:: with SMTP id 126mr890626lfa.174.1589531920961;
        Fri, 15 May 2020 01:38:40 -0700 (PDT)
Received: from buimax ([109.204.208.150])
        by smtp.gmail.com with ESMTPSA id q16sm1067188lfp.9.2020.05.15.01.38.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 May 2020 01:38:40 -0700 (PDT)
Date:   Fri, 15 May 2020 11:38:38 +0300
From:   Henri Rosten <henri.rosten@unikie.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: stable/linux-4.4.y bisection: baseline.login on
 at91-sama5d4_xplained
Message-ID: <20200515083836.GA5005@buimax>
References: <5eb8399a.1c69fb81.c5a60.8316@mx.google.com>
 <2db7e52e-86ae-7c87-1782-8c0cafcbadd8@collabora.com>
 <20200512111059.GA34497@piout.net>
 <980597f7-5170-72f2-ec2f-efc64f5e27eb@gmail.com>
 <20200512211519.GB29995@sasha-vm>
 <20200515081357.GA3257@buimax>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515081357.GA3257@buimax>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 11:14:00AM +0300, Henri Rosten wrote:
> On Tue, May 12, 2020 at 05:15:19PM -0400, Sasha Levin wrote:
> > On Tue, May 12, 2020 at 01:29:06PM -0700, Florian Fainelli wrote:
> > > 
> > > 
> > > On 5/12/2020 4:10 AM, Alexandre Belloni wrote:
> > > > Hi,
> > > > 
> > > > On 12/05/2020 06:54:29+0100, Guillaume Tucker wrote:
> > > > > Please see the bisection report below about a boot failure.
> > > > > 
> > > > > Reports aren't automatically sent to the public while we're
> > > > > trialing new bisection features on kernelci.org but this one
> > > > > looks valid.
> > > > > 
> > > > > It appears to be due to the fact that the network interface is
> > > > > failing to get brought up:
> > > > > 
> > > > > [  114.385000] Waiting up to 10 more seconds for network.
> > > > > [  124.355000] Sending DHCP requests ...#
> > > > > ..#
> > > > > .#
> > > > >  timed out!
> > > > > [  212.355000] IP-Config: Reopening network devices...
> > > > > [  212.365000] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> > > > > #
> > > > > 
> > > > > 
> > > > > I guess the board would boot fine without network if it didn't
> > > > > have ip=dhcp in the command line, so it's not strictly a kernel
> > > > > boot failure but still an ethernet issue.
> > > > > 
> > > > 
> > > > I think the resolution of this issue is
> > > > 99f81afc139c6edd14d77a91ee91685a414a1c66. If this is taken, then I think
> > > > f5aba91d7f186cba84af966a741a0346de603cd4 should also be backported.
> > > 
> > > Agreed.
> > 
> > Okay, I've queued both for 4.4, thanks!
> 
> I notice 99f81afc139c was reverted in mainline with commit b43bd72835a5.  
> The revert commit points out that:
> 
> "It was papering over the real problem, which is fixed by commit
> f555f34fdc58 ("net: phy: fix auto-negotiation stall due to unavailable
> interrupt")"
> 
> Maybe f555f34fdc58 should be backported to 4.4 instead of 
> 99f81afc139c?

Notice if f555f34fdc58 is taken, then I believe 215d08a85b9a should also 
be backported.

-- Henri
