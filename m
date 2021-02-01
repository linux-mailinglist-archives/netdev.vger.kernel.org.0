Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC530A653
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 12:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhBALQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 06:16:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233338AbhBALQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 06:16:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95EE964D7F;
        Mon,  1 Feb 2021 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612178154;
        bh=NqfSKLyeP6vCC7FfsygaVBCG73kVJRObo8V8nDcpzdQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s43J2fRi+fvPdHVUFvu2h8tmKi/g1xWSdlWOpKYUeKtgF8yfQR5El1/3KaPJc7Q4J
         fcO+9VYTx6Z8adBcU65vPQBjcSlN+Fl4DW3A8TBT/jOH1KVdxQjrPDtScslfPdqYJH
         YGz2xqXv+z3aO6vL7+eRQp8rPVTsfqWl4TnMIi/Y=
Date:   Mon, 1 Feb 2021 12:15:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <YBfi573Bdfxy0GBt@kroah.com>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work>
 <YBGDng3VhE1Yw6zt@kroah.com>
 <20210201105549.GB108653@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201105549.GB108653@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 04:25:49PM +0530, Manivannan Sadhasivam wrote:
> Hi Greg,
> 
> On Wed, Jan 27, 2021 at 04:15:42PM +0100, Greg KH wrote:
> > On Wed, Jan 13, 2021 at 08:56:25PM +0530, Manivannan Sadhasivam wrote:
> > > Hi Greg,
> > > 
> > > On Wed, Jan 06, 2021 at 10:44:13AM -0800, Hemant Kumar wrote:
> > > > This patch series adds support for UCI driver. UCI driver enables userspace
> > > > clients to communicate to external MHI devices like modem. UCI driver probe
> > > > creates standard character device file nodes for userspace clients to
> > > > perform open, read, write, poll and release file operations. These file
> > > > operations call MHI core layer APIs to perform data transfer using MHI bus
> > > > to communicate with MHI device. 
> > > > 
> > > > This interface allows exposing modem control channel(s) such as QMI, MBIM,
> > > > or AT commands to userspace which can be used to configure the modem using
> > > > tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> > > > required as there are no kernel APIs to access modem control path for device
> > > > configuration. Data path transporting the network payload (IP), however, is
> > > > routed to the Linux network via the mhi-net driver. Currently driver supports
> > > > QMI channel. libqmi is userspace MHI client which communicates to a QMI
> > > > service using QMI channel. Please refer to
> > > > https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> > > > on libqmi.
> > > > 
> > > > Patch is tested using arm64 and x86 based platform.
> > > > 
> > > 
> > > This series looks good to me and I'd like to merge it into mhi-next. You
> > > shared your reviews on the previous revisions, so I'd like to get your
> > > opinion first.
> > 
> > If you get the networking people to give you an ack on this, it's fine
> > with me.
> > 
> 
> As discussed in previous iteration, this series is not belonging to networking
> subsystem. The functionality provided by this series allows us to configure the
> modem over MHI bus and the rest of the networking stuff happens over the
> networking subsystem as usual.

Great, then it should be easy to get their acceptance :)

> This holds the same with USB and serial modems which we are having over decades
> in mainline.

I don't see the connection here, sorry.

thanks,

greg k-h
