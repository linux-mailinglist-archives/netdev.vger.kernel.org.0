Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D6430A756
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhBAMON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhBAMOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:14:08 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAF6C061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:13:27 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w18so11435943pfu.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 04:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PQKa0QbKtMZtWsNJ8J3oY3JodpMQf8nMPv8lfKSosC4=;
        b=J47QIGJX20a07kPVr7Jg8VvUq0WIyppcjnP2ZYodc8HJYVgLkzSXzScnPznMicPfOF
         OzhTG+Xy2QZHZFlLJFY4I9CH7CdvNF/A93wbScWxz6FB25bx5eHB25gwx5w+tPMZskpk
         vy8UaCidgCrwRqNwAViM+BJOvT61sTaCBPZ1BH6nhj2n7SkfrWuQLzZgVEfwM8deXQyF
         wh6nO56FTLtU84uxjZbojFCN7T7NPrBVDPbTerDzqgb7KPqDHYZlHE0T1OBV7eVkILSA
         7ftjV8JAo+Y57GjeJn56ss3MuDITY8xwbINnJzDd/AhKWWFtDVJ1mgxm/Ybbmr+qKpiV
         Tiiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PQKa0QbKtMZtWsNJ8J3oY3JodpMQf8nMPv8lfKSosC4=;
        b=rGx+J7T5Vf14jWALFzfv6aM05JQRVgMn1QghTjfGy3o849PULrtf17WsuidRLDL/pd
         Bez1I3DLNDSQE5TxNM7itw+WyKjgb7o9+URsoM0HCIzdCQmnjvzKC/hTdRhHIpX1RDjd
         Yib+AfTt/h5IVLFfC+U6hf1m0TBIErGLAeleue46sJlNA0uUD6AbQ95pVQctia1OJGJ+
         CVPFnwOPglAP8jg76ISiBoG5CZNO/2OpuJMnYinOP5fdy4F2tBx4qoebguqRsMplxkPJ
         r+ir0c/x3KQSfrLxvIUo0FzxopXjiksCPwMrDyjVX7yOx/ljrb2zqdBgq5+ivOeg7Itx
         TAow==
X-Gm-Message-State: AOAM5321raen5DnFgmZXEMg9I0SG96rXlWuojFq+Jj0Y7X3qZZ2wsNfs
        u70Ulh9NHw5FN+Ai32ZAqsAo
X-Google-Smtp-Source: ABdhPJxvXtXtPNdQJBehzz4G4bByyyDTAZPIGymO4yZngY1PB57ITVWg6TzyGTycWLB0XmWgwwHCuQ==
X-Received: by 2002:a62:7541:0:b029:1b9:c47e:7c14 with SMTP id q62-20020a6275410000b02901b9c47e7c14mr16865949pfc.30.1612181606880;
        Mon, 01 Feb 2021 04:13:26 -0800 (PST)
Received: from thinkpad ([103.77.37.179])
        by smtp.gmail.com with ESMTPSA id c204sm17329883pfc.152.2021.02.01.04.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 04:13:26 -0800 (PST)
Date:   Mon, 1 Feb 2021 17:43:22 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210201121322.GC108653@thinkpad>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work>
 <YBGDng3VhE1Yw6zt@kroah.com>
 <20210201105549.GB108653@thinkpad>
 <YBfi573Bdfxy0GBt@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBfi573Bdfxy0GBt@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 12:15:51PM +0100, Greg KH wrote:
> On Mon, Feb 01, 2021 at 04:25:49PM +0530, Manivannan Sadhasivam wrote:
> > Hi Greg,
> > 
> > On Wed, Jan 27, 2021 at 04:15:42PM +0100, Greg KH wrote:
> > > On Wed, Jan 13, 2021 at 08:56:25PM +0530, Manivannan Sadhasivam wrote:
> > > > Hi Greg,
> > > > 
> > > > On Wed, Jan 06, 2021 at 10:44:13AM -0800, Hemant Kumar wrote:
> > > > > This patch series adds support for UCI driver. UCI driver enables userspace
> > > > > clients to communicate to external MHI devices like modem. UCI driver probe
> > > > > creates standard character device file nodes for userspace clients to
> > > > > perform open, read, write, poll and release file operations. These file
> > > > > operations call MHI core layer APIs to perform data transfer using MHI bus
> > > > > to communicate with MHI device. 
> > > > > 
> > > > > This interface allows exposing modem control channel(s) such as QMI, MBIM,
> > > > > or AT commands to userspace which can be used to configure the modem using
> > > > > tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> > > > > required as there are no kernel APIs to access modem control path for device
> > > > > configuration. Data path transporting the network payload (IP), however, is
> > > > > routed to the Linux network via the mhi-net driver. Currently driver supports
> > > > > QMI channel. libqmi is userspace MHI client which communicates to a QMI
> > > > > service using QMI channel. Please refer to
> > > > > https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> > > > > on libqmi.
> > > > > 
> > > > > Patch is tested using arm64 and x86 based platform.
> > > > > 
> > > > 
> > > > This series looks good to me and I'd like to merge it into mhi-next. You
> > > > shared your reviews on the previous revisions, so I'd like to get your
> > > > opinion first.
> > > 
> > > If you get the networking people to give you an ack on this, it's fine
> > > with me.
> > > 
> > 
> > As discussed in previous iteration, this series is not belonging to networking
> > subsystem. The functionality provided by this series allows us to configure the
> > modem over MHI bus and the rest of the networking stuff happens over the
> > networking subsystem as usual.
> 
> Great, then it should be easy to get their acceptance :)
> 
> > This holds the same with USB and serial modems which we are having over decades
> > in mainline.
> 
> I don't see the connection here, sorry.
> 

For instance USB_NET_CDC_MBIM driver creates the /dev/cdc-wdmX chardev node for
configuring the modems which supports MBIM protocol over USB. Like that, this
driver creates /dev/mhiX_MBIM chardev node for configuring the modem over MHI
bus instead of USB. The question arised why we are creating a chardev node for
each supported configuration (channels in the case of MHI) and why can't we use
the existing /dev/cdc-wdmZ interfaces? The anwser is there is no standard
subsystem for WWAN and all the drivers represent a chardev which gets used by
the userspace tools such a Network manager for establishing connection.

And /dev/cdc-wdmX is restricted to the USB CDC devices.

Hope this clarifies!

Thanks,
Mani

> thanks,
> 
> greg k-h
