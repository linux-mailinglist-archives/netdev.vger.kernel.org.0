Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF6D26B052
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgIOWIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:08:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37054 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgIOUVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:21:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIHRx-00EodC-D4; Tue, 15 Sep 2020 22:21:13 +0200
Date:   Tue, 15 Sep 2020 22:21:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ethtool: Add 100base-FX link mode entries
Message-ID: <20200915202113.GE3526428@lunn.ch>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915181708.25842-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 01:17:06PM -0500, Dan Murphy wrote:
> Add entries for the 100base-FX full and half duplex supported modes.
> 
> $ ethtool eth0
>         Supported ports: [ TP    MII     FIBRE ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 100baseFX/Half 100baseFX/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: No
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 100baseFX/Half 100baseFX/Full

I thought this PHY could not switch between TP and Fibre. It has a
strap which decides? So i would expect the supported modes to be
either BaseT or BaseFX. Not both. Same for Advertised?

       Andrew
