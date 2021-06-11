Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D463A48B4
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFKSdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 14:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhFKSdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 14:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D4C7613C6;
        Fri, 11 Jun 2021 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623436278;
        bh=z04LjOdxKMrcbY56RV4bW9OK2gAOj88lt8chaxg+7mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kCUEq2nPNo5a/uxRdnUlk0WjqL3pJcGcOu7a1P6WiY8RO7ROnFb4sL6Nwd4fOt+1u
         ZKA02ZcTunar2AlzHF612Ev7jflfyRl1aKgppMOydvIfADDH/AwDHkwUox5xOoRjhX
         2eAK6QzwWWUhn2v1dUFEVQTcI8vJkqQKNJPLklmKO4/bzt0QhdG9vgw9hs7aNiDxPm
         ay6YNxZfuE9HhbU+k7nmtTFuMzwlolmQEw41axXPokJF2YpvlHe7B57xjomkiY7DtT
         9wKcqqROPC14s2E4Tb1ZZqpf432mP184H4hd8Ayj2N5ZePn4kWuwGP65PU5rLUQZyS
         9LWYsD2BN/v4Q==
Date:   Fri, 11 Jun 2021 11:31:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        David Miller <davem@davemloft.net>,
        Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] bus: mhi: Add inbound buffers allocation flag
Message-ID: <20210611113117.23846e75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMZdPi8FVWRhU69z6JygsqoqMCOJTKGfo6vTWtv35kT-Ap8Drg@mail.gmail.com>
References: <1621603519-16773-1-git-send-email-loic.poulain@linaro.org>
        <20210521163530.GO70095@thinkpad>
        <CAMZdPi8FVWRhU69z6JygsqoqMCOJTKGfo6vTWtv35kT-Ap8Drg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Jun 2021 09:00:16 +0200 Loic Poulain wrote:
> > On Fri, May 21, 2021 at 03:25:19PM +0200, Loic Poulain wrote:  
> > > Currently, the MHI controller driver defines which channels should
> > > have their inbound buffers allocated and queued. But ideally, this is
> > > something that should be decided by the MHI device driver instead,
> > > which actually deals with that buffers.
> > >
> > > Add a flag parameter to mhi_prepare_for_transfer allowing to specify
> > > if buffers have to be allocated and queued by the MHI stack.
> > >
> > > Keep auto_queue flag for now, but should be removed at some point.
> > >
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > Tested-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > > Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > > Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> > > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > ---
> > >  v2: Update API in mhi_wwan_ctrl driver
> > >
> > >  drivers/bus/mhi/core/internal.h  |  2 +-
> > >  drivers/bus/mhi/core/main.c      | 11 ++++++++---
> > >  drivers/net/mhi/net.c            |  2 +-
> > >  drivers/net/wwan/mhi_wwan_ctrl.c |  2 +-  
> >
> > Since this patch touches the drivers under net/, I need an Ack from Dave or
> > Jakub to take it via MHI tree.  
> 
> Could you please ack|nack this patch?

Looks fine.
