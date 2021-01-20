Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E00E2FDB01
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387838AbhATUj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732169AbhATUhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 15:37:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69950233FC;
        Wed, 20 Jan 2021 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611174961;
        bh=LikNbco49Fp0cV/R7LXralZjgkOCB6bhi5ixJuHU1xY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VOpPHGAqF//Glk9f7ts2njyS78kP5BCSmH9/LPxr4Ni7TSUnR+RJp8iNE42NM6X6I
         GfDVob9Rmu7sxv9rfeEAKptHRcxNoav3u2jmygmYvR0KsIkdP8eSMoPb+JN2G4D8QI
         T/d49RfY2dZ0QhAWi3fKoBn4O3vRHYsfMCQj4z/3yEFN44cpY1iaCMNekI/79ZDevZ
         8YkvMc9BBHpG2gqG6S4MpcfJKMBlBoHeWpTdMhRpyCgVGNIiGoTeWK74BlvMVBL22m
         YWrHZO9zd1AHf1asGhoNvKx9x133f9w9Mf5vVmUjp/wcMg4FNI5zi9oHkQjPW0FWgT
         rmPTEi3M2q+Yg==
Date:   Wed, 20 Jan 2021 12:36:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2021-01-20
Message-ID: <20210120123600.3e2a4356@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <410e7552-a6bd-d48c-6530-e4b5154687d2@pengutronix.de>
References: <20210120125202.2187358-1-mkl@pengutronix.de>
        <20210120091955.54a52e09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <410e7552-a6bd-d48c-6530-e4b5154687d2@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 21:20:13 +0100 Marc Kleine-Budde wrote:
> On 1/20/21 6:19 PM, Jakub Kicinski wrote:
> >> this is a pull request of 3 patches for net/master.
> >>
> >> All three patches are by Vincent Mailhol and fix a potential use after free bug
> >> in the CAN device infrastructure, the vxcan driver, and the peak_usk driver. In
> >> the TX-path the skb is used to read from after it was passed to the networking
> >> stack with netif_rx_ni().  
> > 
> > Pulled, thanks.
> > 
> > Seems like the PR didn't show up in patchwork at all :S Hopefully I can
> > still pull reight manually without the scripts :)  
> 
> Fingers crossed. :D
> 
> Today I noticed a lag of >4h on vger.kernel.org. Even this mail of yours hasn't
> made it to the linux-can list, yet. It's 3h delayed.

It's been reported but it's unclear what's causing this one :(

> >> Note: Patch 1/3 touches "drivers/net/can/dev.c". In net-next/master this file
> >> has been moved to drivers/net/can/dev/dev.c [1] and parts of it have been
> >> transfered into separate files. This may result in a merge conflict. Please
> >> carry this patch forward, the change is rather simple. Drop us a note if
> >> needed. Are any actions needed with regards to linux-next?  
> > 
> > Thanks for the note, I'm sending the PR to Linus now, so I think
> > linux-next may never see the the conflict.  

The merge has been done now, could you double check?
