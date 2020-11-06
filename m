Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4ED2A9908
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgKFQEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:04:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgKFQEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 11:04:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F42E20B80;
        Fri,  6 Nov 2020 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604678686;
        bh=PAvhrLJHoOJYZ8Xxoa+6bs6ZeKZpwZX1IK6tGRE4LG0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S0LLFzGzG2rWepMA3tLfdWw7rKQBKaAGgSKQdB+1A9wXzVkbtFQo3eRFnLRrTGAMO
         95R5emBFPCkhgMeJA8hbEkV9rzqvPV0NRcNEk56QKlyQITaudJzFgRedxtVUdRogS/
         Xsu1KRDJY3Rdk8B+0WnnVv5KdgFzu37OhxV9z9AM=
Date:   Fri, 6 Nov 2020 08:04:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, willemdebruijn.kernel@gmail.com,
        jhugo@codeaurora.org, hemantk@codeaurora.org
Subject: Re: [PATCH v10 1/2] bus: mhi: Add mhi_queue_is_full function
Message-ID: <20201106080445.00588690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106051353.GA3473@work>
References: <1604424234-24446-1-git-send-email-loic.poulain@linaro.org>
        <20201105165708.31d24782@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201106051353.GA3473@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 10:43:53 +0530 Manivannan Sadhasivam wrote:
> On Thu, Nov 05, 2020 at 04:57:08PM -0800, Jakub Kicinski wrote:
> > On Tue,  3 Nov 2020 18:23:53 +0100 Loic Poulain wrote:  
> > > This function can be used by client driver to determine whether it's
> > > possible to queue new elements in a channel ring.
> > > 
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>  
> > 
> > Applied.  
> 
> Oops. I should've mentioned this (my bad) that we should use an immutable
> branch to take this change. Because, there are changes going to get merged
> into the MHI tree which will introduce merge conflicts. And moreover, we
> planned to have an immutable branch to handle a similar case with ath11k.

Damn, sorry.

> Since you've applied now, what would you propose?

Do you need mhi_queue_is_full() in other branches, or are you just
concerned about the conflicts?

I'm assuming the concern is just about the mhi/core patch, or would 
you need to refactor something in the net driver as well?
