Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF64463A75
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhK3Pqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:46:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59608 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhK3Pqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:46:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=651JAiyTF+grw7ae5awR71AbX5RR4LSI4WO9S7bUBWQ=; b=b2sVm2a6AnFizjuTVOCeQZytWL
        xIcQLHcBPvzEzXgV8OkgCxYJ8LwnforyuCkMaZTlPpXLaZrkygCVLrc9P2//iPyd715ZsJjq975l9
        YVchNhEMNAqmvL/Nk5m/BODIViYSuJj9LHyVJga4WbdM42IjZcBAMbT1D3HN3UVjeQck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ms5I1-00F7Dn-Nm; Tue, 30 Nov 2021 16:43:29 +0100
Date:   Tue, 30 Nov 2021 16:43:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 1/5] net: dsa: consolidate phylink creation
Message-ID: <YaZGoSeB3xCxaQzC@lunn.ch>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
 <E1ms2tP-00ECJ3-Uf@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ms2tP-00ECJ3-Uf@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 01:09:55PM +0000, Russell King (Oracle) wrote:
> The code in port.c and slave.c creating the phylink instance is very
> similar - let's consolidate this into a single function.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
