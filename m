Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E910818C654
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgCTEPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:15:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgCTEPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:15:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E59A1158FADA8;
        Thu, 19 Mar 2020 21:15:10 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:15:10 -0700 (PDT)
Message-Id: <20200319.211510.1452182638121494989.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] net: phy: mscc: add support for RGMII
 MAC mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319141958.383626-1-antoine.tenart@bootlin.com>
References: <20200319141958.383626-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:15:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Thu, 19 Mar 2020 15:19:56 +0100

> This series adds support for the RGMII MAC mode for the VSC8584 PHY
> family and for RGMII_ID modes (Tx and/or Rx).
> 
> I decided to drop the custom delay for now. I made some tests and it
> seemed to be working quite well. If we find out we really need to lower
> the delay, which I doubt, I'll send support for it.
 ...
> Since v2:
>   - Dropped support for custom dt bindings.
>   - Add the 2ns delay based on the interface mode.
> 
> Since v1:
>   - The RGMII skew delays are now set based on the PHY interface mode
>     being used (RGMII vs ID vs RXID vs TXID).
>   - When RGMII is used, the skew delays are set to their default value,
>     meaning we do not rely anymore on the bootloader's configuration.
>   - Improved the commit messages.
>   - s/phy_interface_mode_is_rgmii/phy_interface_is_rgmii/

Series applied, thanks.
