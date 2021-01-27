Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CA830659B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhA0VF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231218AbhA0VF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 16:05:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20BB364D9A;
        Wed, 27 Jan 2021 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611781516;
        bh=StvuAbz3TJtisCQHC2a2FIPp+hdE4Yv8PttGddc4zx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TpJFIcfUP8rwdsXF48qELkqwHKVVNnBd7g39kOVn4j8b+K/YUJ5Uyw9AT33Zwwuzq
         Eeg2Oc5o6JlOwAF1R/+lcBFmFDk7f91fzkWHoFirgcbWpPbeacXTon85Y5OR44jrNi
         rEAU/rv+BjYuSqqPIhxDQm02M0p7aaykqp5Krt2aRkW6avIAkn7WqkBQwXlMrIwLNh
         g7KxXybrolDX+OXsp3vGzd3NzsEKj4DCCh+/ox7A6aVsGD4dA/hxfgFuamNK5CrV8Q
         8IsIJLGnzvMa0134ih3IE3kBDhk0GgmpKeEaDMS3J4pYpyb89qK5Crk6RpiGddJ6Kz
         ztSbsKH1blJcw==
Date:   Wed, 27 Jan 2021 13:05:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: Re: [PATCH net-next 1/3] bus: mhi: core: Add helper API to return
 number of free TREs
Message-ID: <20210127130513.4d73b7e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127112317.GA3141@work>
References: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
        <20210113193301.2a9b7ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114035749.GA4607@work>
        <20210113200246.526d4dc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210127112317.GA3141@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 16:53:17 +0530 Manivannan Sadhasivam wrote:
> On Wed, Jan 13, 2021 at 08:02:46PM -0800, Jakub Kicinski wrote:
> > On Thu, 14 Jan 2021 09:27:49 +0530 Manivannan Sadhasivam wrote:  
> > > On Wed, Jan 13, 2021 at 07:33:01PM -0800, Jakub Kicinski wrote:  
> > > > On Mon, 11 Jan 2021 19:07:40 +0100 Loic Poulain wrote:    
> > > > > From: Hemant Kumar <hemantk@codeaurora.org>
> > > > > 
> > > > > Introduce mhi_get_free_desc_count() API to return number
> > > > > of TREs available to queue buffer. MHI clients can use this
> > > > > API to know before hand if ring is full without calling queue
> > > > > API.
> > > > > 
> > > > > Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> > > > > Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> > > > > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>    
> > > > 
> > > > Can we apply these to net-next or does it need to be on a stable branch
> > > > that will also get pulled into mhi-next?    
> > > 
> > > We should use the immutable branch for this so that I can pull into
> > > mhi-next.  
> >   
> 
> Please find the immutable branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/mani/mhi.git/log/?h=mhi-net-immutable
> 
> I've now merged this into mhi-next!

Loic, please prepare a proper pull request based on that with the other
patches included.
