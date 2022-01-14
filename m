Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2589D48F1A4
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 21:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbiANUqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 15:46:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232369AbiANUqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 15:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QHtJdtffg6q8rQEKPtS1nDwVltrKenMKuKhNiKPAmXA=; b=eCfKvl68on5wTxnylEa40Ht/IQ
        Su2vxBs4K5IlP7HXoYk7tffKCQTq2WifexqNmic30Mp8OfdqRguBzA1tO2J0j6869rPV8TXzfFDSQ
        rxbNHbr876PXW7iBWGv+WYGFI08Qem7F7uFl+XphEFCZ3y1uggC76hFgC5S/x6tKsBmc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n8TSy-001Rl9-NU; Fri, 14 Jan 2022 21:46:32 +0100
Date:   Fri, 14 Jan 2022 21:46:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Port mirroring, v2 (RFC)
Message-ID: <YeHhKDUNy8rU+xcG@lunn.ch>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 11:03:26AM -0600, Alex Elder wrote:
> Yikes!  I don't know why that turned out double-spaced.  I hope
> this one turns out better.
> 
> 					-Alex
> 
> This is a second RFC for a design to implement new functionality
> in the Qualcomm IPA driver.  Since last time I've looked into some
> options based on feedback.  This time I'll provide some more detail
> about the hardware, and what the feature is doing.  And I'll end
> with two possible implementations, and some questions.
> 
> My objective is to get a general sense that what I plan to do
> is reasonable, so the patches that implement it will be acceptable.
> 
> 
> The feature provides the AP access to information about the packets
> that the IPA hardware processes as it carries them between its
> "ports".  It is intended as a debug/informational interface only.
> Before going further I'll briefly explain what the IPA hardware
> does.
> 
> The upstream driver currently uses the hardware only as the path
> that provides access to a 5G/LTE cellular network via a modem
> embedded in a Qualcomm SoC.
> 
>        \|/
>         |
>   ------+-----   ------
>   | 5G Modem |   | AP |
>   ------------   ------
>              \\    || <-- IPA channels, or "ports"
>             -----------
>             |   IPA   |
>             -----------

Hi Alex

I think i need to take a step back here. With my background, an AP is
an 802.11 Access Point.
But here you mean Application Processor?
What does IPA standard for ?
MHI ?

I can probably figure these all out from context, but half the problem
here is making sure we are talking the same language when we are
considering using concepts from another part of the network stack.

	    Andrew
