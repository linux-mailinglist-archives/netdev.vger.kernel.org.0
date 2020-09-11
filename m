Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04025265F19
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgIKL5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 07:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgIKL5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 07:57:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0EE6221E7;
        Fri, 11 Sep 2020 11:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599825466;
        bh=OGz8xp4DfNbeDLLobWhgOPaKtHeGjBzxJ1PU9o8tCI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HmkktZevp+Gs6mdLYJRyYRMZq9zekb9HXwVQ+kbJ2ZqfxN5gL02wCFOKbZHCVLuf1
         TdoaPTQtk4bYdFitgdzZTfz6RVOiJRoJtqokUWCNOTwRLGP69kDsyemX+KBPLX89wc
         Cl41jfFTQSeI0hKl/37dzwzPHmzDoKhW4F6Efe9I=
Date:   Fri, 11 Sep 2020 13:57:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH 4.19] net/mlx5e: Don't support phys switch id if not in
 switchdev mode
Message-ID: <20200911115752.GA3717176@kroah.com>
References: <20200807020542.636290-1-saeedm@mellanox.com>
 <20200807131323.GA664450@kroah.com>
 <fc4effe1bbe6e9c68f4bdd863e3d38cbab52a285.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc4effe1bbe6e9c68f4bdd863e3d38cbab52a285.camel@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:46:36AM -0700, Saeed Mahameed wrote:
> On Fri, 2020-08-07 at 15:13 +0200, Greg Kroah-Hartman wrote:
> > On Thu, Aug 06, 2020 at 07:05:42PM -0700, Saeed Mahameed wrote:
> > > From: Roi Dayan <roid@mellanox.com>
> > > 
> > > Support for phys switch id ndo added for representors and if
> > > we do not have representors there is no need to support it.
> > > Since each port return different switch id supporting this
> > > block support for creating bond over PFs and attaching to bridge
> > > in legacy mode.
> > > 
> > > This bug doesn't exist upstream as the code got refactored and the
> > > netdev api is totally different.
> > > 
> > > Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
> > > Signed-off-by: Roi Dayan <roid@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > ---
> > > Hi Greg,
> > > 
> > > Sorry for submitting a non upstream patch, but this bug is
> > > bothering some users on 4.19-stable kernels and it doesn't exist
> > > upstream, so i hope you are ok with backporting this one liner
> > > patch.
> > 
> > Also queued up to 4.9.y and 4.14.y.
> > 
> 
> Hi Greg, the request was originally made for 4.19.y kernel,
> I see the patch in 4.9 and 4.14 but not in 4.19 can we push it to 4.19
> as well ? 

Very odd, don't know what happened.

Now fixed up, thanks.

greg k-h
