Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521562FB8D5
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404983AbhASNtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390535AbhASK3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 05:29:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F1523121;
        Tue, 19 Jan 2021 10:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611052142;
        bh=Ch0VID3vq3ol7fCKvkjvnTA23BZDgxFtyVacBh1ijoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bPviyuF1S8vfAjTsrPMTw676xxgoZ6zXl/qkk/LJ4CCqSK3ZUL9DcZu5UpsPzGHap
         9CfWao8fTUz33JJWZ3T51ipMwv60/014Ve/Fbv03g6MKz3KPbhSN8Ap9v9mU3hkrxy
         npYFicoHl2We96INYHqtV8XPMqCPV5k9X1S6ZmRs=
Date:   Tue, 19 Jan 2021 11:28:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        hemantk@codeaurora.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <YAa0awzyYzDVMSOj@kroah.com>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work>
 <20210119094250.GA20682@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119094250.GA20682@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 03:12:50PM +0530, Manivannan Sadhasivam wrote:
> Hi Greg,
> 
> On Wed, Jan 13, 2021 at 08:56:25PM +0530, Manivannan Sadhasivam wrote:
> > Hi Greg,
> > 
> > On Wed, Jan 06, 2021 at 10:44:13AM -0800, Hemant Kumar wrote:
> > > This patch series adds support for UCI driver. UCI driver enables userspace
> > > clients to communicate to external MHI devices like modem. UCI driver probe
> > > creates standard character device file nodes for userspace clients to
> > > perform open, read, write, poll and release file operations. These file
> > > operations call MHI core layer APIs to perform data transfer using MHI bus
> > > to communicate with MHI device. 
> > > 
> > > This interface allows exposing modem control channel(s) such as QMI, MBIM,
> > > or AT commands to userspace which can be used to configure the modem using
> > > tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> > > required as there are no kernel APIs to access modem control path for device
> > > configuration. Data path transporting the network payload (IP), however, is
> > > routed to the Linux network via the mhi-net driver. Currently driver supports
> > > QMI channel. libqmi is userspace MHI client which communicates to a QMI
> > > service using QMI channel. Please refer to
> > > https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> > > on libqmi.
> > > 
> > > Patch is tested using arm64 and x86 based platform.
> > > 
> > 
> > This series looks good to me and I'd like to merge it into mhi-next. You
> > shared your reviews on the previous revisions, so I'd like to get your
> > opinion first.
> > 
> 
> Ping!

Sorry, it's in my to-review queue, buried with other stuff at the
moment, but it's not lost...

greg k-h
