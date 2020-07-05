Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A918521496B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgGEA7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEA7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:59:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57663C061794;
        Sat,  4 Jul 2020 17:59:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76F47157A9DA1;
        Sat,  4 Jul 2020 17:59:19 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:59:18 -0700 (PDT)
Message-Id: <20200704.175918.135881238117884776.davem@davemloft.net>
To:     codrin.ciubotariu@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, linux@armlinux.org.uk, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: split
 adjust_link() in phylink_mac_link_{up|down}()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702151724.1483891-1-codrin.ciubotariu@microchip.com>
References: <20200702151724.1483891-1-codrin.ciubotariu@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:59:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Date: Thu, 2 Jul 2020 18:17:23 +0300

> The DSA subsystem moved to phylink and adjust_link() became deprecated in
> the process. This patch removes adjust_link from the KSZ DSA switches and
> adds phylink_mac_link_up() and phylink_mac_link_down().
> 
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
