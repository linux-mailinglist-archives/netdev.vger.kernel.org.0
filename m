Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F98305F55
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhA0PSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:18:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343750AbhA0PQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 10:16:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2FAF20771;
        Wed, 27 Jan 2021 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611760545;
        bh=uHg46WoYh6K03pifl+ksxfM7lt63yUa+yHkpBA+UJA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZeQkhrIZARW12nA93+bmT+6Dja/zBlV3oPuFpXp04y1QSVHRVwYWlY0cZNy6JNANL
         lRN2QQO9zr19PYmDwk5OCF/1pjstTWqyLF2QbdWhV3uzWGYSbpC++uxby4cW64ZD4T
         TeaxVb6HB4fLWLsx5OlHzG36ML3XMwveUOdEeHuo=
Date:   Wed, 27 Jan 2021 16:15:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <YBGDng3VhE1Yw6zt@kroah.com>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113152625.GB30246@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 08:56:25PM +0530, Manivannan Sadhasivam wrote:
> Hi Greg,
> 
> On Wed, Jan 06, 2021 at 10:44:13AM -0800, Hemant Kumar wrote:
> > This patch series adds support for UCI driver. UCI driver enables userspace
> > clients to communicate to external MHI devices like modem. UCI driver probe
> > creates standard character device file nodes for userspace clients to
> > perform open, read, write, poll and release file operations. These file
> > operations call MHI core layer APIs to perform data transfer using MHI bus
> > to communicate with MHI device. 
> > 
> > This interface allows exposing modem control channel(s) such as QMI, MBIM,
> > or AT commands to userspace which can be used to configure the modem using
> > tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> > required as there are no kernel APIs to access modem control path for device
> > configuration. Data path transporting the network payload (IP), however, is
> > routed to the Linux network via the mhi-net driver. Currently driver supports
> > QMI channel. libqmi is userspace MHI client which communicates to a QMI
> > service using QMI channel. Please refer to
> > https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> > on libqmi.
> > 
> > Patch is tested using arm64 and x86 based platform.
> > 
> 
> This series looks good to me and I'd like to merge it into mhi-next. You
> shared your reviews on the previous revisions, so I'd like to get your
> opinion first.

If you get the networking people to give you an ack on this, it's fine
with me.

thanks,

greg k-h
