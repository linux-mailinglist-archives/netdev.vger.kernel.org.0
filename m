Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C252D31BB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgLHSIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730478AbgLHSIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 13:08:01 -0500
Date:   Tue, 8 Dec 2020 10:07:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607450840;
        bh=33QJdY1Oomg8uXozWiDDXYsMlphB2O4Pp6fHPwahJr8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lsVyRZPyBzKz4JWx9ob3BW6IbKoUA1yFyOJagCTxEYGsRZlrJI822nw05e380N7vY
         zs6nND26tqzIw6SgnrjBwiuSZPQUBznquWAqaBFSpKv98BzQPRVRiLJCXemKz8Y7tA
         Mp7VTzRHLoQgR0dWchLPmjgLZUOz4tt3XfRRHaIydjx2zmTPoLPpyn1jdPhZPLdgpu
         h4z+Mrn4Q4ae+DTQoU1KsiECuzeG7f7Ul0wyWQ1epZgPxXBpNldzPKPRngJjmslysf
         eAVY1bZGVLzL6PGpEPXRI4drDYot3ES091bSe8CgJ/4VI3nKCYrH3VtZJDl2e3DjBD
         yUTYbC2miB5QA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Wagner <thwa1@web.de>, linux-can@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net 3/3] can: isotp: add SF_BROADCAST support for functional
 addressing
Message-ID: <20201208100718.5ed008dc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <752c8838-b478-43da-620b-e15bcc690518@hartkopp.net>
References: <20201204133508.742120-1-mkl@pengutronix.de>
        <20201204133508.742120-4-mkl@pengutronix.de>
        <20201204194435.0d4ab3fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b4acc4eb-aff6-9d20-b8a9-d1c47213cefd@hartkopp.net>
        <eefc4f80-da1c-fed5-7934-11615f1db0fc@pengutronix.de>
        <20201205123300.34f99141@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <ce547683-925d-6971-6566-a0b54146090a@pengutronix.de>
        <20201205130904.3d81b0dc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <752c8838-b478-43da-620b-e15bcc690518@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 13:54:28 +0100 Oliver Hartkopp wrote:
> On 05.12.20 22:09, Jakub Kicinski wrote:
> > On Sat, 5 Dec 2020 21:56:33 +0100 Marc Kleine-Budde wrote:  
> >> On 12/5/20 9:33 PM, Jakub Kicinski wrote:  
> >>>> What about the (incremental?) change that Thomas Wagner posted?
> >>>>
> >>>> https://lore.kernel.org/r/20201204135557.55599-1-thwa1@web.de  
> >>>
> >>> That settles it :) This change needs to got into -next and 5.11.  
> >>
> >> Ok. Can you take patch 1, which is a real fix:
> >>
> >> https://lore.kernel.org/linux-can/20201204133508.742120-2-mkl@pengutronix.de/  
> > 
> > Sure! Applied that one from the ML (I assumed that's what you meant).
> 
> I just double-checked this mail and in fact the second patch from Marc's 
> pull request was a real fix too:
> 
> https://lore.kernel.org/linux-can/20201204133508.742120-3-mkl@pengutronix.de/

Ack, I thought it was a fix to some existing code but it's a fix to
ISO-TP so we should probably get it in before someone start depending
on existing behavior - Marc should I apply that one directly, too?

> Btw. the missing feature which was added for completeness of the ISOTP 
> implementation has now also integrated the improvement suggested by 
> Thomas Wagner:
> 
> https://lore.kernel.org/linux-can/20201206144731.4609-1-socketcan@hartkopp.net/T/#u
> 
> Would be cool if it could go into the initial iso-tp contribution as 
> 5.10 becomes a long-term kernel.
> 
> But I don't want to be pushy - treat it as your like.

I think Linus wants to release 5.10 so that the merge window doesn't
overlap with Christmas too much. Let's not push our luck.
