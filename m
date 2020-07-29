Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E498E2316EA
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgG2ArV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbgG2ArV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:47:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B5FC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:47:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61F0A128D7309;
        Tue, 28 Jul 2020 17:30:34 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:47:18 -0700 (PDT)
Message-Id: <20200728.174718.450581528353482552.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     richardcochran@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        zou_wei@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/9] ptp: Add generic header parsing function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727090601.6500-1-kurt@linutronix.de>
References: <20200727090601.6500-1-kurt@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:30:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Mon, 27 Jul 2020 11:05:52 +0200

> in order to reduce code duplication in the ptp code of DSA, Ethernet and Phy
> drivers, move the header parsing function to ptp_classify. This way all drivers
> can share the same implementation. Implemented as discussed [1] [2] [3].
> 
> This is version two and contains more driver conversions.
> 
> Richard, can you test with your hardware? I'll do the same e.g. on the bbb.
> 
> Version 1 can be found here:
> 
>  * https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/

It looks like some mlxsw et al. issues wrt. which header is expected at
skb->data when certain helper functions are invoked need to be resolved
still.
