Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C851C7E64
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgEGAQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgEGAQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:16:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70996C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 17:16:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C4C31277A251;
        Wed,  6 May 2020 17:16:04 -0700 (PDT)
Date:   Wed, 06 May 2020 17:16:03 -0700 (PDT)
Message-Id: <20200506.171603.763495783252132261.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, antoine.tenart@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, kuba@kernel.org
Subject: Re: [PATCH net 0/2] FDB fixes for Felix and Ocelot switches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200503222027.12991-1-olteanv@gmail.com>
References: <20200503222027.12991-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:16:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  4 May 2020 01:20:25 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series fixes the following problems:
> - Dynamically learnt addresses never expiring (neither for Ocelot nor
>   for Felix)
> - Half of the FDB not visible in 'bridge fdb show' (for Felix only)

Series applied, thanks.
