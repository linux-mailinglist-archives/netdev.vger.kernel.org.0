Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98CA1980CA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgC3QRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:17:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgC3QRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 12:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iehK+cC/etp8rAh+c85AsPkLjb0hWFiZnh55kAIHJNY=; b=d1zsM0NMsG11ecCmMuFhvNM7Rv
        3qikrhbKNA/NWL0vwONzHdpUSni0e6uNzkVgjkr25ZAVRg3y1jfapWqrbv11lUGlOFypgA48qZ89M
        8ugvRjvQ0dq5Y4v5JjmJCJt2t+0nNl5WsxpnC9Fekg7/w6iG98y/ySEy4zg3cKejqIuM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIx6a-0005zs-L5; Mon, 30 Mar 2020 18:17:40 +0200
Date:   Mon, 30 Mar 2020 18:17:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Message-ID: <20200330161740.GC23477@lunn.ch>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 07:01:36PM +0300, Codrin Ciubotariu wrote:
> Some ethernet controllers, such as cadence's macb, have an embedded MDIO.
> For this reason, the ethernet PHY nodes are not under an MDIO bus, but
> directly under the ethernet node.

Hi Codrin

That is deprecated. It causes all sorts of problems putting PHY nodes
in the MAC without a container.

Please fix macb to look for an mdio node, and place your fixed link
inside it.

       Andrew
