Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0C3EC9B2
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 16:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhHOOuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 10:50:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238690AbhHOOuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 10:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oH1SUDrOpLhn5aRvfGPjUXTSZSO8SekjmaljkZP9P00=; b=Kp5vAFz1aXh5ITDD8UP6imVL2F
        BYsgVoYB2195tKpsGBQw+NAdMlsLpA/sKH1psBzsIEZdMf3272FHrCXfgDQihkudeU1EDKfffsia9
        YGk64BQ7u5FaQ4rYF1p80mJwzZUU9cWoT1duSL76DdcF3UmHlOgCNFQ+d6Qw+o93yX58=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFHSF-000FPk-0C; Sun, 15 Aug 2021 16:49:39 +0200
Date:   Sun, 15 Aug 2021 16:49:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v3 2/3] MDIO: Kconfig: Specify more IPQ chipset supported
Message-ID: <YRkpgmfVfJ6jMl0K@lunn.ch>
References: <20210812100642.1800-1-luoj@codeaurora.org>
 <20210812100642.1800-3-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812100642.1800-3-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 06:06:41PM +0800, Luo Jie wrote:
> The IPQ MDIO driver currently supports the chipset IPQ40xx, IPQ807x,
> IPQ60xx and IPQ50xx.
> 
> Add the compatible 'qcom,ipq5018-mdio' because of ethernet LDO dedicated
> to the IPQ5018 platform.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
