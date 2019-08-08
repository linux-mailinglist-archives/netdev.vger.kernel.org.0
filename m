Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3C586609
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbfHHPiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:38:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbfHHPiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 11:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NvS98iY3iaj0Fjfm6EpkBN0TmIL3ZRvSaEi1oBDrdn0=; b=txsV4wE8fSaTq16Y0rXcfoN6IK
        eGmvg1CSIMcZaQms9tmR0ZRPdMyslrQc0hps40AeiuHA9Bd4ymlWjbQTEJ+q7jnnO4xPXqx3zOGsW
        CsmYGJbEumjgGP9g8j6atHBlZ22zhkaT9prIyz6Jd+ZwFYzrlu6XNrxXoTCF+4qbaxEk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvkUe-0003v3-89; Thu, 08 Aug 2019 17:38:20 +0200
Date:   Thu, 8 Aug 2019 17:38:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2 06/15] net: phy: adin: configure RGMII/RMII/MII modes
 on config
Message-ID: <20190808153820.GF27917@lunn.ch>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
 <20190808123026.17382-7-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808123026.17382-7-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 03:30:17PM +0300, Alexandru Ardelean wrote:
> The ADIN1300 chip supports RGMII, RMII & MII modes. Default (if
> unconfigured) is RGMII.
> This change adds support for configuring these modes via the device
> registers.
> 
> For RGMII with internal delays (modes RGMII_ID,RGMII_TXID, RGMII_RXID),
> the default delay is 2 ns. This can be configurable and will be done in
> a subsequent change.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
