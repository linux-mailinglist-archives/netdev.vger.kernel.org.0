Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C4B397C37
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhFAWJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:09:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234897AbhFAWJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FtHxG6xUI+ZK/LdOWImVo2KBg5IQssGdB+TkgX8DaAc=; b=07F7bXGF6o2GkIt8YI5oQtaLJl
        GzHjxDA/eXv6w4vO5Gmy2VHFMqWYbq7va2EhmbRi5HG5YZ4p4xRpoOQ4IInl/fuUvlUz24w5NunKH
        SCdVry8Y5mhDETT957/nbzuM1JPVaVNrovPsOE6BqTvVH91gXS/pD/yGFI5ZQD9UEbDM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loCYA-007LxQ-F7; Wed, 02 Jun 2021 00:07:50 +0200
Date:   Wed, 2 Jun 2021 00:07:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, f.fainelli@gmail.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: phy: realtek: add dt property to
 disable CLKOUT clock
Message-ID: <YLavtkj5YO4WGlLd@lunn.ch>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
 <20210601090408.22025-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601090408.22025-3-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct rtl821x_priv {
> +	u32 quirks;

I'm not sure quirks is the correct word here. I would probably use
features, or flags.

	  Andrew
