Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFD5194E47
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 02:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgC0BHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 21:07:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbgC0BHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 21:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=slYTqywddxrf0q3UZbv67p05DHILUfdrIqKZxFHxC1E=; b=3kOrAlvVmmPPwwZfajoPD2PdsW
        OFFOFEQMtbPAifE8/t3CqUlvoCAtih0bSDE5zz/ccmsMTN6WZTihEAGP43vYv7O3wOLoD7aIbJpP5
        fvSEs3iEaIEbaZfK84Pmq7WzeZLDfwTvVEuI8tvzJuY65HsS9SzKY7PkCwZFjDqG75ao=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHdSk-0005Ku-Cl; Fri, 27 Mar 2020 02:07:06 +0100
Date:   Fri, 27 Mar 2020 02:07:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Message-ID: <20200327010706.GN3819@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static u32 le_ioread32(void __iomem *reg)
> +{
> +	return ioread32(reg);
> +}
> +
> +static void le_iowrite32(u32 value, void __iomem *reg)
> +{
> +	iowrite32(value, reg);
> +}
> +
> +static u32 be_ioread32(void __iomem *reg)
> +{
> +	return ioread32be(reg);
> +}
> +
> +static void be_iowrite32(u32 value, void __iomem *reg)
> +{
> +	iowrite32be(value, reg);
> +}

This is very surprising to me. I've not got my head around the
structure of this code yet, but i'm surprised to see memory mapped
access functions in generic code.

       Andrew
