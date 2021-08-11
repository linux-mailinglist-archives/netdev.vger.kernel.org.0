Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294333E9418
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhHKO6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:58:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhHKO6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lci/WWF8eUvl5qPt71eRoa7VFAdmRwJ31uczXvNQ++4=; b=l3zT3luf2zwz0GSaTM53TJ0wMl
        VQVQXnJn2cPr9Y5y/8d3ouxSTmmAIDMGXEK9+2HnTH0hMFmoB33pU4OpCXV2Nbdmh36p0MDm0ByeS
        W6NQslt6cV++EBaz4cFXS5vaxoOV6wrHawvlQ1QQAe34vK1M5CBxETVMTfxWNbkZ3jow=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDpgJ-00H8MF-7Y; Wed, 11 Aug 2021 16:58:11 +0200
Date:   Wed, 11 Aug 2021 16:58:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v2 2/3] MDIO: Kconfig: Specify more IPQ chipset supported
Message-ID: <YRPlgyrJy8auH2gf@lunn.ch>
References: <20210810133116.29463-1-luoj@codeaurora.org>
 <20210810133116.29463-3-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810133116.29463-3-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 09:31:15PM +0800, Luo Jie wrote:
> The IPQ MDIO driver currently supports the chipset IPQ40xx, IPQ807x,
> IPQ60xx and IPQ50xx.
> 
> Add the compatible 'qcom,ipq5018-mdio' because of ethernet LDO dedicated
> to the IPQ5018 platform.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
