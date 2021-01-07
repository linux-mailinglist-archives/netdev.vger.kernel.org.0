Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39B42ED74C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbhAGTMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:12:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAGTMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:12:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C6623432;
        Thu,  7 Jan 2021 19:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610046710;
        bh=uDzZTnqOoXkH2ikd0ySS6VgfbG7/Ib6y+i3yHuvIVxw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZLXJvMnHKdCiKM8XZZ2RFNwKZZftYn8hhG5BnfDm0kd8s9f1L4K0ytiOM1h7syc1B
         OQTYjhmggO/W9nRD1uaHm4l2PMdt8/iS7t860XkW/iLz1Lb6j3Gx2gFwkbsTb9Zkfh
         XJr3EjWHSt9G0n/mhQVXb0PUWumn3e/TxMY8IHDTTFiYVQthsqsDQDGjAYwFtwB12H
         Q2JpdKOhQhZ6km6COdjFmPkOs9sda83EuO2pEDke6iqphObs16a24Zd/ygcSBrD9la
         iDAuIes3MbWQSwDDisoWjUp9LLaM4vbKNgAxiP899X97qIpZTXFIQ0mprUEqFoToB9
         NHhshrDoF55WQ==
Date:   Thu, 7 Jan 2021 11:11:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2021-01-07
Message-ID: <20210107111149.0c79570e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107103451.183477-1-mkl@pengutronix.de>
References: <20210107103451.183477-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 11:34:45 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 6 patches for net/master.
> 
> The first patch is by me for the m_can driver and removes an erroneous
> m_can_clk_stop() from the driver's unregister function.
> 
> The second patch targets the tcan4x5x driver, is by me, and fixes the bit
> timing constant parameters.
> 
> The next two patches are by me, target the mcp251xfd driver, and fix a race
> condition in the optimized TEF path (which was added in net-next for v5.11).
> The similar code in the RX path is changed to look the same, although it
> doesn't suffer from the race condition.
> 
> A patch by Lad Prabhakar updates the description and help text for the rcar CAN
> driver to reflect all supported SoCs.
> 
> In the last patch Sriram Dash transfers the maintainership of the m_can driver
> to Pankaj Sharma.


Pulled, thanks!
