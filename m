Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EFA451C90
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346128AbhKPAU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347416AbhKOVMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 16:12:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BDA61B4B;
        Mon, 15 Nov 2021 21:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637010579;
        bh=om6FJZiL4uGOCVc3SoVSzocZS9dT+KxiCifRHEJEPTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bgVNozWD99+bIi8/alyDJ5eLhftjUfKPjoKoBrawkB+MjDjOOeoM9SOmw+pSfTaoT
         P43bALStKm3iHQ7NSA66v4Glug2+uLbax5zN+SzWjrM1LuYmFJUNGxxZbxSuSJ2p5S
         Wy7Q9zsw+yhDvN01GaYbYwAz/EgPOf2NOqvNErnfjQnyfMO6GJqyCZW3SlhmkVM8Hi
         DZzeoL3dxTrA13+oUSs8DzZcZNXk+lorBgWv8P1XcCPjlvB5UG6l8hu0y9+vVvb/dr
         7KbmozRpN6oVvTnY16rZdmUdwnprOt53KuzawkVVB/YYqck3PRc63cEJES2/87JqXi
         cLBBpTDiV5a+w==
Date:   Mon, 15 Nov 2021 13:09:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2021-11-02
Message-ID: <20211115130938.49b97c8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABBYNZJPanQzSx=Nf9mgORvqixbgwd6ypx=irGiQ3CEr6xUT1A@mail.gmail.com>
References: <20211102213321.18680-1-luiz.dentz@gmail.com>
        <CABBYNZ+i4aR5OjMppG+3+EkaOyFh06p18u6FNr6pZA8wws-hpg@mail.gmail.com>
        <CABBYNZJPanQzSx=Nf9mgORvqixbgwd6ypx=irGiQ3CEr6xUT1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 11:53:15 -0800 Luiz Augusto von Dentz wrote:
> > Any chance to get these changes in before the merge window closes?  
> 
> I guess these won't be able to be merged after all, is there a define
> process on how/when pull-request shall be sent to net-next, Ive assume
> next-next is freezed now the documentation says the the merge window
> lasts for approximately two weeks but I guess that is for the Linus
> tree not net-next?

I'm not sure what the exact rules are for net-next.

We had some glitches this time around, IMHO. Here is what I have in
mind for the next merge window but note that I haven't had a chance 
to discuss it with Dave yet, so it's more of me blabbering at this
point than a plan:
 - net-next would not apply patches posted after Linus cuts final;
 - make sure all trees feeding net-next submit their changes around
   rc6 time so that we don't get a large code dump right as the merge
   window opens;
 - any last minute net-next PRs should be ready by Monday night PST;
 - we'd give the tree one day to settle, have build issues reported etc
   and submit PR on Wednesday.

If we go with a more structured timeline along these lines I'll try 
to send reminders.
