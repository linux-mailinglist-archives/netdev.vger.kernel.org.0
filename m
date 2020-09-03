Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5682F25CCD7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgICVxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgICVxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:53:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4561CC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 14:53:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 661CA1277C969;
        Thu,  3 Sep 2020 14:36:27 -0700 (PDT)
Date:   Thu, 03 Sep 2020 14:53:09 -0700 (PDT)
Message-Id: <20200903.145309.842316099665188694.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     alexandre.belloni@bootlin.com, antoine.tenart@bootlin.com,
        andre.przywara@arm.com, kuba@kernel.org, mcroce@redhat.com,
        netdev@vger.kernel.org, sven.auhagen@voleatech.de
Subject: Re: [PATCH net-next 0/6] Convert mvpp2 to split PCS support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901134746.GM1551@shell.armlinux.org.uk>
References: <20200901134746.GM1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 14:36:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 1 Sep 2020 14:47:46 +0100

> This series converts the mvpp2 driver to use the split PCS support
> that has been merged into phylink last time around. I've been running
> this for some time here and, apart from the recent bug fix sent to
> net-next, have not seen any issues on DT based systems. I have not
> tested ACPI setups, although I've tried to preserve the workaround.
 ...

Series applied, thank you.
