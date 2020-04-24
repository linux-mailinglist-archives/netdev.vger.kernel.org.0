Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E211B778A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgDXNxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:53:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgDXNxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rZdgygQvFi2X1kZbQ2YTbm6Wj6de3LVBtJ7ah0H7g6I=; b=uOCfCf/bIOSpCtauNM3b3Xob32
        zTxFguPAI4A1JHCBePkID3cXlF+Gbe4k/DSR/oD24XNUpEgDwCo0P/HdA51Wgsju+CYPTVpTdna42
        hQSnEPnKvL0jllOZUpu0olUVkuDqHL+xRF1lFx2fDHmfM4uytdvpq8L3LzYsnrUUnuhs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRylC-004Z4w-5K; Fri, 24 Apr 2020 15:52:54 +0200
Date:   Fri, 24 Apr 2020 15:52:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver support
Message-ID: <20200424135254.GD1087366@lunn.ch>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
 <1587732391-3374-7-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587732391-3374-7-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Backplane mutex between all KR PHY threads */
> +static struct mutex backplane_lock;


> +/* Read AN Link Status */
> +static int is_an_link_up(struct phy_device *phydev)
> +{
> +	struct backplane_device *bpdev = phydev->priv;
> +	int ret, val = 0;
> +
> +	mutex_lock(&bpdev->bpphy_lock);

Last time i asked the question about how this mutex and the phy mutex
interact. I don't remember seeing an answer.

	  Andrew
