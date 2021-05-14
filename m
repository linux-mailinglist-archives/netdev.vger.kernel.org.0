Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063DA3808D3
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhENLrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENLq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 07:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B826145A;
        Fri, 14 May 2021 11:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620992747;
        bh=vPOcLTJAbLQBPG5xiHyVQ/jk3if4qn+FmRdZHvC68CA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZW68/04MHR/aUrnt8Phfslq713qqBllSrQ21S+z9KeMjDIeSxC51N1RnJvXr6KNBr
         ffbMUYam24ZbzOqeSiN2SshVx9KUVdzSB3Z2ZO8geE+Yph3WRcBcOR1fqkzhqnT4HO
         VbsWDRCBOU50msMTFGA0euQyw9MjZ1yZ1M+rnMpI=
Date:   Fri, 14 May 2021 13:45:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     David Miller <davem@davemloft.net>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, kuba@kernel.org, jirislaby@kernel.org
Subject: Re: [PATCH] sparc/vio: make remove callback return void
Message-ID: <YJ5i6F4zHPAR+HCF@kroah.com>
References: <20210505201449.195627-1-u.kleine-koenig@pengutronix.de>
 <20210505.132739.2022645880622422332.davem@davemloft.net>
 <20210506061121.3flqmvm4jok6zj5z@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210506061121.3flqmvm4jok6zj5z@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 08:11:21AM +0200, Uwe Kleine-König wrote:
> Hi Dave,
> 
> On Wed, May 05, 2021 at 01:27:39PM -0700, David Miller wrote:
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Date: Wed,  5 May 2021 22:14:49 +0200
> > 
> > > The driver core ignores the return value of struct bus_type::remove()
> > > because there is only little that can be done. To simplify the quest to
> > > make this function return void, let struct vio_driver::remove() return
> > > void, too. All users already unconditionally return 0, this commit makes
> > > it obvious that returning an error code is a bad idea and should prevent
> > > that future driver authors consider returning an error code.
> > > 
> > > Note there are two nominally different implementations for a vio bus:
> > > one in arch/sparc/kernel/vio.c and the other in
> > > arch/powerpc/platforms/pseries/vio.c. This patch only addresses the
> > > former.
> > > 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> Thanks for your Ack. My expectation was that this patch will go via a
> sparc tree. Does your Ack mean that you think it should take a different
> path?

I'll pick it up, thanks.

greg k-h
