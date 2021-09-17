Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C2740FA75
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243803AbhIQOmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245637AbhIQOmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 10:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2062cCGvF8+jF8e3c5ODMD+rtu44bTlOTpxGwdtZHSI=; b=2mvtwv2Rm4cAvMS0gUzIOzug0P
        iB/VkGT/Xnstgq4o2IQp9ShDSdCl73Jb/ZLsFZA8ikN6DpByRwAS/Hqc1YUqKoSP66pTqhywooNeg
        pmlx0gdTCKHEAItzxVPE1MMMrV6xRm+E/afrrrJc/NZrTDpibO5nLRBOtOSuBb5YXXLg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRF2l-0075AB-5O; Fri, 17 Sep 2021 16:40:47 +0200
Date:   Fri, 17 Sep 2021 16:40:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] net: macb: enable mii on rgmii for sama7g5
Message-ID: <YUSo7wIyfzOuwdzJ@lunn.ch>
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
 <20210917132615.16183-5-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917132615.16183-5-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 04:26:15PM +0300, Claudiu Beznea wrote:
> Both MAC IPs available on SAMA7G5 support MII on RGMII feature.
> Enable these by adding proper capability to proper macb_config
> objects.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Thanks for adding this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

