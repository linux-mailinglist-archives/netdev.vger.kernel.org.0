Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4144E21496C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgGEA7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEA7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:59:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BFFC061794;
        Sat,  4 Jul 2020 17:59:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DE72157A9DA2;
        Sat,  4 Jul 2020 17:59:24 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:59:23 -0700 (PDT)
Message-Id: <20200704.175923.616686576311483622.davem@davemloft.net>
To:     codrin.ciubotariu@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, linux@armlinux.org.uk, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next v2 2/2] net: dsa: microchip: remove unused
 private members
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702151724.1483891-2-codrin.ciubotariu@microchip.com>
References: <20200702151724.1483891-1-codrin.ciubotariu@microchip.com>
        <20200702151724.1483891-2-codrin.ciubotariu@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:59:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Date: Thu, 2 Jul 2020 18:17:24 +0300

> Private structure members live_ports, on_ports, rx_ports, tx_ports are
> initialized but not used anywhere. Let's remove them.
> 
> Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

Applied.
