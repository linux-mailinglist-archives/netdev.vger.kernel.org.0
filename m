Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D8D299A06
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394935AbgJZW4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394842AbgJZW4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 18:56:18 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1F9F20709;
        Mon, 26 Oct 2020 22:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603752978;
        bh=ed2zP2Q4+R9HFumLdNYzSm30Gi9PR7ZxcInXxwiPO1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0zTw8AenVmXHoi5LHbLxI59SMaoOmkxUjJR2m1kY4kELosVMI/Tp05cxUHjpzPuvc
         GtHgqEeooGBJYqTxBIWY+ePtm51PZd7VD27gS+NxfZJHuFxGqWMocPHS2hu89+cqSe
         41mi6pdAh/qHja5uG2amXpAbIpOmO3J4Lhk9dINs=
Date:   Mon, 26 Oct 2020 15:56:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v9 3/4] docs: Add documentation for userspace client
 interface
Message-ID: <20201026155617.350c45ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e92a5a5b-ac62-a6d8-b6b4-b65587e64255@codeaurora.org>
References: <1603495075-11462-1-git-send-email-hemantk@codeaurora.org>
        <1603495075-11462-4-git-send-email-hemantk@codeaurora.org>
        <20201025144627.65b2324e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e92a5a5b-ac62-a6d8-b6b4-b65587e64255@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 07:38:46 -0600 Jeffrey Hugo wrote:
> On 10/25/2020 3:46 PM, Jakub Kicinski wrote:
> > On Fri, 23 Oct 2020 16:17:54 -0700 Hemant Kumar wrote:  
> >> +UCI driver enables userspace clients to communicate to external MHI devices
> >> +like modem and WLAN. UCI driver probe creates standard character device file
> >> +nodes for userspace clients to perform open, read, write, poll and release file
> >> +operations.  
> > 
> > What's the user space that talks to this?
> 
> Multiple.
> 
> Each channel has a different purpose.  There it is expected that a 
> different userspace application would be using it.
> 
> Hemant implemented the loopback channel, which is a simple channel that 
> just sends you back anything you send it.  Typically this is consumed by 
> a test application.
> 
> Diag is a typical channel to be consumed by userspace.  This is consumed 
> by various applications that talk to the remote device for diagnostic 
> information (logs and such).
> 
> Sahara is another common channel that is usually used for the multistage 
> firmware loading process.

Thanks for the info, are there any open source tests based on the 
loopback channel (perhaps even in tree?) 

Since that's the only channel enabled in this set its the only one 
we can comment on.
