Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F21859D2
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgCODuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:50:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35176 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgCODuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:50:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19BA215B75158;
        Sat, 14 Mar 2020 20:50:12 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:50:11 -0700 (PDT)
Message-Id: <20200314.205011.2302370036506407366.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, olteanv@gmail.com, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next] net: dsa: sja1105: move MAC configuration to
 .phylink_mac_link_up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jCMoZ-0005U0-Tv@rmk-PC.armlinux.org.uk>
References: <E1jCMoZ-0005U0-Tv@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:50:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 12 Mar 2020 12:19:51 +0000

> From: Vladimir Oltean <olteanv@gmail.com>
> 
> The switches supported so far by the driver only have non-SerDes ports,
> so they should be configured in the PHYLINK callback that provides the
> resolved PHY link parameters.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks.
