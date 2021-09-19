Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA840410C92
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhISRK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:10:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhISRKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 13:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8Y+OpDNn+ugZGReZXtFXn4IRPD8QQNtJuVSEb6ILLLg=; b=a2sZKB6rLhXDLHdgfrf498JosX
        Ul5WnYXxZzr759Msv/5ZZcS6CjYeaphI4ZUwHB4uu+Olg9CfyVCLwqMFZuKd6S9fTJ8NAukPBt1J5
        K3nP1jmO/GOSIvD0yZFtmxbm33kWUjXLkinpk3rEmcd9t6Qg42vFIYZ+v+vgoNvCyBnE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mS0JB-007MiU-L6; Sun, 19 Sep 2021 19:08:53 +0200
Date:   Sun, 19 Sep 2021 19:08:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 3/3] net: phy: at803x: fix spacing and
 improve name for 83xx phy
Message-ID: <YUdupavAO7CPEme6@lunn.ch>
References: <20210919162817.26924-1-ansuelsmth@gmail.com>
 <20210919162817.26924-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919162817.26924-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 06:28:17PM +0200, Ansuel Smith wrote:
> Fix spacing and improve name for 83xx phy following other phy in the
> same driver.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
