Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A330D25B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhBCEK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229511AbhBCEKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 23:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E44E64E24;
        Wed,  3 Feb 2021 04:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612325410;
        bh=CgdJbQTrFCDwJM3Jryez1J/78+dy9W2vLlpmLQkxPDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t1tmvtZ8aaBM2IF9857xU1FKwCRPAiQV3IZrANGiEHIjoJzaN6dkoevY6/lseZvRa
         wgQa+HQrpLoMfzR0FVeGNaD32C7ecLr8k3S4mksejZ6iQZNkBMNFqRQ0NwZT70jgcJ
         WFP22O8sHuJOywhUBVWmfMSsSk791iz6SGzkeEdEV8R4YWNzNF3PhZ8PIHgXJqZX6F
         LcQj1hGUUDWd6mFHcHJkVzZkq8LRlxKAbYHBz9nIDdTmlvQ9cLPj8R0lQD+oIch4Rg
         WMQj52l4oGIsaaEoJOsfw1M9mjDXqcnAo1Pz7uCbng8b66Az53ZCyPtu9GoZVCUUH2
         2v7wjOy5paI2A==
Date:   Tue, 2 Feb 2021 20:10:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202042208.GB840@work>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
        <20210113152625.GB30246@work>
        <YBGDng3VhE1Yw6zt@kroah.com>
        <20210201105549.GB108653@thinkpad>
        <YBfi573Bdfxy0GBt@kroah.com>
        <20210201121322.GC108653@thinkpad>
        <20210202042208.GB840@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 09:52:08 +0530 Manivannan Sadhasivam wrote:
> > > I don't see the connection here, sorry.
> > 
> > For instance USB_NET_CDC_MBIM driver creates the /dev/cdc-wdmX chardev node for
> > configuring the modems which supports MBIM protocol over USB. Like that, this
> > driver creates /dev/mhiX_MBIM chardev node for configuring the modem over MHI
> > bus instead of USB. The question arised why we are creating a chardev node for
> > each supported configuration (channels in the case of MHI) and why can't we use
> > the existing /dev/cdc-wdmZ interfaces? The anwser is there is no standard
> > subsystem for WWAN and all the drivers represent a chardev which gets used by
> > the userspace tools such a Network manager for establishing connection.
> > 
> > And /dev/cdc-wdmX is restricted to the USB CDC devices.
> > 
> > Hope this clarifies!
> 
> Jakub, Dave, Adding you both to get your reviews on this series. I've
> provided an explanation above and in the previous iteration [1].

Let's be clear what the review would be for. Yet another QMI chardev 
or the "UCI" direct generic user space to firmware pipe?
