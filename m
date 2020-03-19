Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1A018BD18
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbgCSQwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:52:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgCSQwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wyg8B2JSZhJbmvD+Wpl+SzGMR2zOCUiB6TD15+bzWyA=; b=0qpm7qjT9RsMqPajNyVpETutnm
        enfdfoXldYvS2Idy/oHWwhsejpZFBlHzERuzhVF2786TLkvu3vTAHSBexfU0U++VPhf4MhEzbVQvQ
        zvT3nOabWVZY39NPuoMuNhfEF9SCWaMhbiKXhV8MXMnMXRDXaOpkWbfiu926NHD2utSM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEyPQ-0007yS-8c; Thu, 19 Mar 2020 17:52:40 +0100
Date:   Thu, 19 Mar 2020 17:52:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] net: phy: mscc: RGMII skew delay
 configuration
Message-ID: <20200319165240.GI27807@lunn.ch>
References: <20200319141958.383626-1-antoine.tenart@bootlin.com>
 <20200319141958.383626-3-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319141958.383626-3-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 03:19:58PM +0100, Antoine Tenart wrote:
> This patch adds support for configuring the RGMII skew delays in Rx and
> Tx. The Rx and Tx skews are set based on the interface mode. By default
> their configuration is set to the default value in hardware (0.2ns);
> this means the driver do not rely anymore on the bootloader
> configuration.
> 
> Then based on the interface mode being used, a 2ns delay is added:
> - RGMII_ID adds it for both Rx and Tx.
> - RGMII_RXID adds it for Rx.
> - RGMII_TXID adds it for Tx.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
