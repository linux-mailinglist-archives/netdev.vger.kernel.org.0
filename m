Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500583A4D2C
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 08:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFLGtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 02:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhFLGte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 02:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE49361374;
        Sat, 12 Jun 2021 06:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623480455;
        bh=F5y+YxGh2ZzyAaLBCYryN+lp+Xf1wbgV8sL48alQO04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gK2HyrYXQ2yAy8XJUDFTQiDcW2mbQqnIsdnS0cqYxZGln1+DwDZQ/KFF7jEAEW0/x
         q2rhB+P+6597Pv+62oDtt95DAVmhacyQr1fsN4uM3kEBurXPgK7Rt2etjQN83AS3Xa
         iBCXspwQ6UA6oyGFsxL6NBvPz13iRlmtOyzAXRhd9qlBmIFjiGGUoyI5dHNn2uveNe
         5pG9OznEhn7SHjOfp1X9nrIE44XQRUi1k2jMLC84/Q0rMww423jlNwmq/9x8U3sFOA
         rqyF4I8ea2waC/1tqOKzGAYqI9qofqcx6lkHB3ZuUIEZ5oCTMaKg6lXQQqzQDFDMkS
         j7vjVTjvSr0Gg==
Date:   Sat, 12 Jun 2021 12:17:22 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] bus: mhi: Add inbound buffers allocation flag
Message-ID: <20210612064722.GA22149@thinkpad>
References: <1621603519-16773-1-git-send-email-loic.poulain@linaro.org>
 <20210521163530.GO70095@thinkpad>
 <CAMZdPi8FVWRhU69z6JygsqoqMCOJTKGfo6vTWtv35kT-Ap8Drg@mail.gmail.com>
 <20210611113117.23846e75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611113117.23846e75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 11:31:17AM -0700, Jakub Kicinski wrote:
> On Fri, 11 Jun 2021 09:00:16 +0200 Loic Poulain wrote:
> > > On Fri, May 21, 2021 at 03:25:19PM +0200, Loic Poulain wrote:  
> > > > Currently, the MHI controller driver defines which channels should
> > > > have their inbound buffers allocated and queued. But ideally, this is
> > > > something that should be decided by the MHI device driver instead,
> > > > which actually deals with that buffers.
> > > >
> > > > Add a flag parameter to mhi_prepare_for_transfer allowing to specify
> > > > if buffers have to be allocated and queued by the MHI stack.
> > > >
> > > > Keep auto_queue flag for now, but should be removed at some point.
> > > >
> > > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > > Tested-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > > > Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > > > Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> > > > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > > ---
> > > >  v2: Update API in mhi_wwan_ctrl driver
> > > >
> > > >  drivers/bus/mhi/core/internal.h  |  2 +-
> > > >  drivers/bus/mhi/core/main.c      | 11 ++++++++---
> > > >  drivers/net/mhi/net.c            |  2 +-
> > > >  drivers/net/wwan/mhi_wwan_ctrl.c |  2 +-  
> > >
> > > Since this patch touches the drivers under net/, I need an Ack from Dave or
> > > Jakub to take it via MHI tree.  
> > 
> > Could you please ack|nack this patch?
> 
> Looks fine.

Thanks, I'll take it as an Ack.

Regards,
Mani
