Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB47035751A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 21:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355695AbhDGTon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 15:44:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355674AbhDGTom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 15:44:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUE66-00FMvO-Ph; Wed, 07 Apr 2021 21:44:18 +0200
Date:   Wed, 7 Apr 2021 21:44:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH RFC net 1/2] net: dsa: lantiq_gswip: Don't use PHY auto
 polling
Message-ID: <YG4Lku8sgwokW0NH@lunn.ch>
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-2-martin.blumenstingl@googlemail.com>
 <YGz8FRBsj68xIbX/@lunn.ch>
 <CAFBinCD-jEUbyuuV=SLER8O1+PwhmiqHXFMaEX=h5mca=SDLgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCD-jEUbyuuV=SLER8O1+PwhmiqHXFMaEX=h5mca=SDLgg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For my own curiosity: is there a "recommended" way where to configure
> link up/down, speed, duplex and flow control? currently I have the
> logic in both, .phylink_mac_config and .phylink_mac_link_up.

You probably want to read the documentation in

include/linux/phylink.h

	Andrew
