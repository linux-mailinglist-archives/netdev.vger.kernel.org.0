Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E612548CBCA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350059AbiALTW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:22:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34724 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345216AbiALTVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:21:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4vEp/OLxoy6oFVaBhAvAd1yzVtXblqJ5zI4UzKuUTv4=; b=VBsJk0PJnlcxYfzblZUcR1BQ1r
        jvllBWivqvMUHX3wrIQC9EeWo7QyUqomFkieogHxmcCAXGz90lydmPoZ5hqib2GbmW3VTORVXqRyO
        jCQQoB1rfn4VccQOGLQqIp9MuB4eyPRrKztvrb/b024N/5Y9loTCOW1rwFVkzMM2CqaM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7jBf-001E8h-HM; Wed, 12 Jan 2022 20:21:35 +0100
Date:   Wed, 12 Jan 2022 20:21:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, michal.simek@xilinx.com,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net
Subject: Re: [PATCH net v2 3/9] net: axienet: reset core on initialization
 prior to MDIO access
Message-ID: <Yd8qP+guqHYQJVaO@lunn.ch>
References: <20220112173700.873002-1-robert.hancock@calian.com>
 <20220112173700.873002-4-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112173700.873002-4-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:36:54AM -0600, Robert Hancock wrote:
> In some cases where the Xilinx Ethernet core was used in 1000Base-X or
> SGMII modes, which use the internal PCS/PMA PHY, and the MGT
> transceiver clock source for the PCS was not running at the time the
> FPGA logic was loaded, the core would come up in a state where the
> PCS could not be found on the MDIO bus. To fix this, the Ethernet core
> (including the PCS) should be reset after enabling the clocks, prior to
> attempting to access the PCS using of_mdio_find_device.
> 
> Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
