Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA4F4516F9
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348075AbhKOV4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:56:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347883AbhKOVz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 16:55:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90413619E3;
        Mon, 15 Nov 2021 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637013183;
        bh=aopc2cQN9EBmwspgyuB9J0jVCEM1SuUTAj8Bjg4Kses=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cp2GNhEpJ61QNkwpjv1Fe7yTRAXwy3LpeuxpLnF/9Irgm8XyoQbSJnxn26yKeIlho
         JwhQGfk2pCjzXOS2oYqtIjGqFcSyMfT7UCfBnjGyF7vsIPJrPEhJZDegBHY+tv7reY
         HGs5prlZN6rf2pwGe9H8EqmaWqCJMdwcgw73oUlJia3Vr6WDcnMjix3BDYiBqdAaMY
         +bwQ8iKm2jIqjgi4HRFnicngadGaKjNZJf2BdHjtQfCiDkFXft+B1kaf7RZa+VSvEI
         pLeLFus5x3Z+0KZNb/kEFSJnplGEqLqIhFYE23569TZv4EjBEhJg+gJL5z/PfSMXhv
         4cUWNKTl7wMvA==
Date:   Mon, 15 Nov 2021 13:53:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2021-11-02
Message-ID: <20211115135302.4ad246e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABBYNZ+fAVW1Go+UUirgFsbNjffEKdUv-9ArM6MiFxMYEGOM6w@mail.gmail.com>
References: <20211102213321.18680-1-luiz.dentz@gmail.com>
        <CABBYNZ+i4aR5OjMppG+3+EkaOyFh06p18u6FNr6pZA8wws-hpg@mail.gmail.com>
        <CABBYNZJPanQzSx=Nf9mgORvqixbgwd6ypx=irGiQ3CEr6xUT1A@mail.gmail.com>
        <20211115130938.49b97c8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CABBYNZ+fAVW1Go+UUirgFsbNjffEKdUv-9ArM6MiFxMYEGOM6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 13:40:30 -0800 Luiz Augusto von Dentz wrote:
> > > I guess these won't be able to be merged after all, is there a define
> > > process on how/when pull-request shall be sent to net-next, Ive assume
> > > next-next is freezed now the documentation says the the merge window
> > > lasts for approximately two weeks but I guess that is for the Linus
> > > tree not net-next?  
> >
> > I'm not sure what the exact rules are for net-next.
> >
> > We had some glitches this time around, IMHO. Here is what I have in
> > mind for the next merge window but note that I haven't had a chance
> > to discuss it with Dave yet, so it's more of me blabbering at this
> > point than a plan:
> >  - net-next would not apply patches posted after Linus cuts final;
> >  - make sure all trees feeding net-next submit their changes around
> >    rc6 time so that we don't get a large code dump right as the merge
> >    window opens;  
> 
> So net-next has a merge window open during the rc phase, until rc6? I
> assume if the rc goes further than rc7 it also would extend the merge
> window of net-next as well?

Yes, net-next has the inverse rules to Linus's tree basically. 
We accumulate the code outside the merge window. And then during
the merge window try to focus on fixes and conflicts introduced 
by merging with other -next trees outside networking.

> >  - any last minute net-next PRs should be ready by Monday night PST;
> >  - we'd give the tree one day to settle, have build issues reported etc
> >    and submit PR on Wednesday.
> >
> > If we go with a more structured timeline along these lines I'll try
> > to send reminders.  
> 
> +1, that would be great to have reminders for the merge window
> open/close that way if for some reason if you guys decide to change
> your merge window that would be noticed by us.
