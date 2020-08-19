Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B53324A227
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgHSOzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgHSOzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 10:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 188DD20866;
        Wed, 19 Aug 2020 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597848946;
        bh=+WKm8NNzd96hHOH0UFCe4caLZQg6IpCKHB3OGt/dtdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sM4yr5X/7hChUcIHov5swoMw32na3RtSBLQhCoTwY2nS+NEpAYj3OFnGe5uizYMws
         mXzrmateOfN4RvKn/tSwSZvMJg2UrZi2FGLsLlPLuRTts4FGxMkjoVGGw35OUScrEj
         2I+gInifHRm8MQe9Y4yayvJYNVeRnUOgadUbAZAc=
Date:   Wed, 19 Aug 2020 16:56:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, Kangjie Lu <kjlu@umn.edu>
Subject: Re: [PATCH] staging: wilc1000: Fix memory leak in wilc_bus_probe
Message-ID: <20200819145607.GA3678365@kroah.com>
References: <b3b1e811-a19e-8639-eb5f-e2ce714f41b9@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3b1e811-a19e-8639-eb5f-e2ce714f41b9@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 04:47:59PM +0200, Markus Elfring wrote:
> > When devm_clk_get() returns -EPROBE_DEFER, spi_priv
> > should be freed just like when wilc_cfg80211_init() fails.
> 
> How do you think about to choose an imperative wording for
> a corresponding change description?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=18445bf405cb331117bc98427b1ba6f12418ad17#n151
> 
> Regards,
> Markus

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
