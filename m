Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC0324BE0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 09:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhBYIQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 03:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhBYIQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 03:16:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B2A64E20;
        Thu, 25 Feb 2021 08:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614240961;
        bh=+u3cp1lmOAXIi0NxPbTp9wmhsfShRK28whSVTGPGfqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E30e1dYHhRYrP6Litfeah9aKiIAdm1UcSDN95zX05PjqzLViUao7onNx95OksgbkQ
         04d/csNHQ9AnReIgMRoKIeKr/gpzrpfWWoz4+FTEg0mpYoGlAaptZeB6Dqq21igfTs
         3csKknzQcq8nHOpvFD0o5JyE1qhpvIcJi9b2Fak8=
Date:   Thu, 25 Feb 2021 09:15:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, olteanv@gmail.com, sashal@kernel.org
Subject: Re: [PATCH stable 0/8] net: dsa: b53: Correct learning for
 standalone ports
Message-ID: <YDdcvkQQoAs2yc3C@kroah.com>
References: <20210225010853.946338-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225010853.946338-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 05:08:53PM -0800, Florian Fainelli wrote:
> From: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> Hi Greg, Sasha, Jaakub and David,
> 
> This patch series contains backports for a change that recently made it
> upstream as:
> 
> commit f3f9be9c58085d11f4448ec199bf49dc2f9b7fb9
> Merge: 18755e270666 f9b3827ee66c
> Author: Jakub Kicinski <kuba@kernel.org>
> Date:   Tue Feb 23 12:23:06 2021 -0800
> 
>     Merge branch 'net-dsa-learning-fixes-for-b53-bcm_sf2'

That is a merge commit, not a "real" commit.

What is the upstream git commit id for this?

> The way this was fixed in the netdev group's net tree is slightly
> different from how it should be backported to stable trees which is why
> you will find a patch for each branch in the thread started by this
> cover letter.
> 
> Let me know if this does not apply for some reason. The changes from 4.9
> through 4.19 are nearly identical and then from 5.4 through 5.11 are
> about the same.

Thanks for the backports, but I still need a real git id to match these
up with :)

greg k-h
