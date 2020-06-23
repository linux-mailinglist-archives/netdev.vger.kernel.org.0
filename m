Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C612065DF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393736AbgFWVed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387680AbgFWVeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:34:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7827C061573;
        Tue, 23 Jun 2020 14:34:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5149D129428A8;
        Tue, 23 Jun 2020 14:34:31 -0700 (PDT)
Date:   Tue, 23 Jun 2020 14:34:30 -0700 (PDT)
Message-Id: <20200623.143430.794983681368540702.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: phy: export phy_disable_interrupts()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623154104.3ba15b4d@xhacker.debian>
References: <20200623154031.736123a6@xhacker.debian>
        <20200623154104.3ba15b4d@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 14:34:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Tue, 23 Jun 2020 15:41:04 +0800

> +EXPORT_SYMBOL_GPL(phy_disable_interrupts);

phy.o and phy_device.o are always linked together, therefore you don't
need a module symbol export.

If you plan to use it later in a device, submit the symbol export
with the driver change that uses it.
