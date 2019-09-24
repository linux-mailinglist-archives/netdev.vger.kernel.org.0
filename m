Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4782BCC72
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632818AbfIXQ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 12:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437807AbfIXQ2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 12:28:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B6E2146E;
        Tue, 24 Sep 2019 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569342511;
        bh=gpnIkcA2Sc4+vF8ZGFxu6NtNfcgnFR+Awsv13jfaTLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CoSdAujrxScdh4N76DBI3QuutuxZBIlC0vvwsuP3FZwA6JuZIP7PHKXNzv8/0bsyn
         3HZx0QY+N3K5vusP92TNIW4gT4G/fNUMRpdcrinIYfzz5+ouGNmJCXKalJb66E8ngM
         JeexCx4lh/+OSR5IZM5FcIQ3xuu9cdGm7GPX4RPo=
Date:   Tue, 24 Sep 2019 18:28:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     saeedm@mellanox.com, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 0/7] mlx5 checksum fixes for 4.19
Message-ID: <20190924162829.GC793386@kroah.com>
References: <20190923123917.16817-1-saeedm@mellanox.com>
 <20190923.175106.799482393811705736.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923.175106.799482393811705736.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 05:51:06PM +0200, David Miller wrote:
> From: Saeed Mahameed <saeedm@mellanox.com>
> Date: Mon, 23 Sep 2019 12:39:57 +0000
> 
> > This series includes some upstream patches aimed to fix multiple checksum
> > issues with mlx5 driver in 4.19-stable kernels.
> > 
> > Since the patches didn't apply cleanly to 4.19 back when they were
> > submitted for the first time around 5.1 kernel release to the netdev
> > mailing list, i couldn't mark them for -stable 4.19, so now as the issue
> > is being reported on 4.19 LTS kernels, I had to do the backporting and
> > this submission myself.
> >  
> > This series required some dependency patches and some manual touches
> > to apply some of them.
> > 
> > Please apply to 4.19-stable and let me know if there's any problem.
> > I tested and the patches apply cleanly and work on top of: v4.19.75
> 
> FWIW, I'm fine with this.

Thanks for the review, will go queue these up now...

greg k-h
