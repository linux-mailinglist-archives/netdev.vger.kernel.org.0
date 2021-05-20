Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1455638B38C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhETPtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhETPs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A3C2610A2;
        Thu, 20 May 2021 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621525656;
        bh=SfbXmZWa34A4DSU595iEI+9Kif4u+sQdLe1xcNRgXAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BKkfUngZ0Fsdd2JTr6SdGcGLyckZYQPGnAet6TfsSCmNqwcOh7tbC2vPv7W2wkNTx
         sYP+xCxOjYycyy67aul69tTX7bNqmCGP9OSckwHNTJ4nFYLEUj9ntYAXpgcsRAJ91U
         EAqyRl6zLLI6OQuliapY5uh7fLBt4MI+dS/KdrJ3gdMF+mPDCDnxlOCaQVsdgClshv
         eg1puEGrx3qU4FB5/QhgKGCcM3kQwbJ/z8GJwUpdlMYSc68mjO2buOHPrF0JJlhJNH
         xZ46koCzvGvoG7jiVjEAvaOaLlotVgeSgyjO6EGcnlkA3687HmzWtg4FeLscwellMF
         IgJ49vX1Xr2jQ==
Date:   Thu, 20 May 2021 08:47:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Subject: Re: [PACTH ethtool-next v3 0/7] ethtool: support FEC and standard
 stats
Message-ID: <20210520084735.27fe0b6b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210520154418.l3bwpdmizgab7fgm@lion.mk-sys.cz>
References: <20210503160830.555241-1-kuba@kernel.org>
        <20210518154214.22060227@kicinski-fedora-PC1C0HJN>
        <20210520154418.l3bwpdmizgab7fgm@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 May 2021 17:44:18 +0200 Michal Kubecek wrote:
> On Tue, May 18, 2021 at 03:42:14PM -0700, Jakub Kicinski wrote:
> > On Mon,  3 May 2021 09:08:23 -0700 Jakub Kicinski wrote:  
> > > This series adds support for FEC requests via netlink
> > > and new "standard" stats.  
> > 
> > Anything I can do to help with those? They disappeared from 
> > patchwork due to auto archiving being set to 2 weeks.  
> 
> Sorry for the delay, the series is applied now (with one additional
> commit masking spurious "make check" failure).

Thank you!
