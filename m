Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082D62AA796
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgKGTRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGTRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 14:17:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DCD920723;
        Sat,  7 Nov 2020 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604776638;
        bh=jtShwRiJRIdfLPFLIlWUHGSUJ2qGrhTvw/AWZ3oxKWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WxoB6KaRqI9gf63qpB0NfoicETTHT69S5l111kZ3/Sga4U7segEiM11attcNIwEmR
         YUTh5oEA8ZNgN3GlP45wA/boIQyYxNwQS1j6W6wGfmZVNNYZoXs1fwqQZMcZHCvLUf
         kH9M8HtO3gH3cPourTlnDNydc1ZMK8ZaxCxCVPrM=
Date:   Sat, 7 Nov 2020 11:17:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <michal.simek@xilinx.com>, <mchehab+samsung@kernel.org>,
        <gregkh@linuxfoundation.org>, <nicolas.ferre@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>
Subject: Re: [PATCH net-next 0/2] net: axienet: Dynamically enable MDIO
 interface
Message-ID: <20201107111717.59b399e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604402770-78045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1604402770-78045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 16:56:08 +0530 Radhey Shyam Pandey wrote:
> This patchset dynamically enable MDIO interface. The background for this
> change is coming from Cadence GEM controller(macb) in which MDC is active 
> only during MDIO read or write operations while the PHY registers are
> read or written. It is implemented as an IP feature. 
> 
> For axiethernet as dynamic MDC enable/disable is not supported in hw
> we are implementing it in sw. This change doesn't affect any existing
> functionality.

Applied, thank you!
