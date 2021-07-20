Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDB63CFBD0
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbhGTNex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:34:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238972AbhGTNcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4biQuLfT6cnASWh6rMBd2TtfwYCQm+InOx5XTjFLjVs=; b=ntnXNs5a+JIpnclBkSvb0w5SZT
        y3x2o8dl9yrtaqO4dwptZWTXVLQP8f+slaOKFectdgfWgpHLlWg9LbjXRKVicsxbAisQbf0lOCfIY
        Z/D3fH9eZy6n8m8x5ymalZKzmKOTSBzRIVeIqevf+gQf4TNnDhMU72k1pIjNRvnS4nBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5qUW-00E3x7-50; Tue, 20 Jul 2021 16:13:00 +0200
Date:   Tue, 20 Jul 2021 16:13:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <YPbZ7OPYJs4JNiK5@lunn.ch>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
 <20210720141134.GT22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720141134.GT22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Shall we get this patch merged anyway and then clean it up - as such
> a change will need to cover multiple drivers anyway?

Yes, do it as a cleanup later.

     Andrew
