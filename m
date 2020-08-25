Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6052519D1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgHYNh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:37:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgHYNhz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:37:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAZ94-00Bm8b-Fs; Tue, 25 Aug 2020 15:37:50 +0200
Date:   Tue, 25 Aug 2020 15:37:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Gorsulowski <daniel.gorsulowski@esd.eu>, dmurphy@ti.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH] net: dp83869: Fix RGMII internal delay configuration
Message-ID: <20200825133750.GQ2588906@lunn.ch>
References: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 02:07:21PM +0200, Daniel Gorsulowski wrote:
> The RGMII control register at 0x32 indicates the states for the bits
> RGMII_TX_CLK_DELAY and RGMII_RX_CLK_DELAY as follows:
> 
>   RGMII Transmit/Receive Clock Delay
>     0x0 = RGMII transmit clock is shifted with respect to transmit/receive data.
>     0x1 = RGMII transmit clock is aligned with respect to transmit/receive data.
> 
> This commit fixes the inversed behavior of these bits
> 
> Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")

I Daniel

I would like to see some sort of response from Dan Murphy about this.

  Andrew
