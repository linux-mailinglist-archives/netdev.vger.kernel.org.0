Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7183E9414
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhHKO6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:58:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232540AbhHKO6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sxjpe8U8+ZHfXcYWBfce/Brxk/9js2ihphx4OJMweFQ=; b=t9ER4x2tadeKCwr5LvGzGB1eyd
        oWciKQAKKiAWz9ZAXpZea+XXqPvX3Y0r1TnLek/6rp76ViDg8rTeftpLprtlXKMsVxdKLR9/CtnUj
        Rpe18YeOPadXB5ZhcTYYg+PH9LmOgKC9kzMw7JqGn7hJOKz36F+NHmhhle6jEbKv1SFg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDpfo-00H8L8-Nm; Wed, 11 Aug 2021 16:57:40 +0200
Date:   Wed, 11 Aug 2021 16:57:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v2 1/3] net: mdio: Add the reset function for IPQ MDIO
 driver
Message-ID: <YRPlZGXWJGoLRSSN@lunn.ch>
References: <20210810133116.29463-1-luoj@codeaurora.org>
 <20210810133116.29463-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810133116.29463-2-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	ret = clk_prepare_enable(priv->mdio_clk);
> +	if (ret)
> +		return ret;
> +
> +	return 0;

This can be simplified to just:

     return clk_prepare_enable(priv->mdio_clk);

     Andrew
