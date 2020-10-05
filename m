Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060BA283634
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 15:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJENF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJENF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 09:05:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60C6C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 06:05:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DE6511E3E4CA;
        Mon,  5 Oct 2020 05:49:06 -0700 (PDT)
Date:   Mon, 05 Oct 2020 06:05:52 -0700 (PDT)
Message-Id: <20201005.060552.685538059223511166.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, f.fainelli@gmail.com,
        martin.blumenstingl@googlemail.com, hauke@hauke-m.de,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, noodles@earth.li,
        linus.walleij@linaro.org, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com
Subject: Re: [PATCH net-next] net: dsa: propagate switchdev vlan_filtering
 prepare phase to drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
References: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 05 Oct 2020 05:49:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sat,  3 Oct 2020 01:06:46 +0300

> A driver may refuse to enable VLAN filtering for any reason beyond what
> the DSA framework cares about, such as:
> - having tc-flower rules that rely on the switch being VLAN-aware
> - the particular switch does not support VLAN, even if the driver does
>   (the DSA framework just checks for the presence of the .port_vlan_add
>   and .port_vlan_del pointers)
> - simply not supporting this configuration to be toggled at runtime
> 
> Currently, when a driver rejects a configuration it cannot support, it
> does this from the commit phase, which triggers various warnings in
> switchdev.
> 
> So propagate the prepare phase to drivers, to give them the ability to
> refuse invalid configurations cleanly and avoid the warnings.
> 
> Since we need to modify all function prototypes and check for the
> prepare phase from within the drivers, take that opportunity and move
> the existing driver restrictions within the prepare phase where that is
> possible and easy.
 ...
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
