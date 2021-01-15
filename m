Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9A2F8987
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbhAOXn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:43:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbhAOXn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:43:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFAE423A5E;
        Fri, 15 Jan 2021 23:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610754168;
        bh=JPe02qrO1BmcvOvLAnhecImM0Vaay1dmhg0P/iZZuA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JlZUGX2JiIZqUNUUNwNZwASwe2fmBRxyiriY+wMKYytC/tkYZko0pzdWqUD4qGtod
         Utn4Cbz1seYChuYqzXt6KrFPkx/F7Lv+qVrQifasCtjJ8DdgijEXzHU9sFTVLzbnv8
         y2x08wqX4ifAtWSvAHluBsKMgGAk5VFdVhx2O7nH6+GKezMe8m+e5QoXYJQHIVI6Md
         ppj95hKagBOXe6u6vK/W+PLMi4zTgKMUxnlEkCQLWYL7DsvyH/9wSHhQWlPA30h+kF
         OIUrgvgdnXrg5JtyGeEUpbpe4BO5EXSt7jBEtm32JrcJuw5mPKs4oFDr1ltl4yBXe2
         c1/JbzexPbdFA==
Date:   Fri, 15 Jan 2021 15:42:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/3] Arrow SpeedChips XRS700x DSA Driver
Message-ID: <20210115154246.0ee57602@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114195734.55313-1-george.mccollister@gmail.com>
References: <20210114195734.55313-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 13:57:31 -0600 George McCollister wrote:
> This series adds a DSA driver for the Arrow SpeedChips XRS 7000 series
> of HSR/PRP gigabit switch chips.
> 
> The chips use Flexibilis IP.
> More information can be found here:
>  https://www.flexibilis.com/products/speedchips-xrs7000/
> 
> The switches have up to three RGMII ports and one MII port and are
> managed via mdio or i2c. They use a one byte trailing tag to identify
> the switch port when in managed mode so I've added a tag driver which
> implements this.
> 
> This series contains minimal DSA functionality which may be built upon
> in future patches. The ultimate goal is to add HSR and PRP
> (IEC 62439-3 Clause 5 & 4) offloading with integration into net/hsr.

I corrected a couple uint_t types to kernel types and applied.

Please consider adding an entry to MAINTAINERS for this driver.

Thank you!
