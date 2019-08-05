Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6446281ED2
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfHEOQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:16:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfHEOQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lwa7mvicBhJRvF1KbcGY+bQJ/JfnIP3P6YeZqhoAaDo=; b=iRi4N3bKZcYFwNPkSvYAhsm+oa
        /UCiOZrFehxa3vOUs8zujsICllTz9dxXaxU3QMCCxQojfdEoY73heYNby4T7uUIiPqSlhuVyWJcKZ
        br7FMNkWdiaS+tEuBDV2tOOrR+wvliZ/xEvFoCM4ddse8OD/o4KNuHoFTXywTkll9RVY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hudn2-0007MV-K9; Mon, 05 Aug 2019 16:16:44 +0200
Date:   Mon, 5 Aug 2019 16:16:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 01/16] net: phy: adin: add support for Analog Devices PHYs
Message-ID: <20190805141644.GH24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-2-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin_config_init(struct phy_device *phydev)
> +{
> +	int rc;
> +
> +	rc = genphy_config_init(phydev);
> +	if (rc < 0)
> +		return rc;
> +
> +	return 0;
> +}

Why not just

    return genphy_config_init(phydev);

    Andrew

