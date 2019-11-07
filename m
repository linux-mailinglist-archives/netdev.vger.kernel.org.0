Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A186F3C59
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfKGXzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:55:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50246 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGXzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:55:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 408741537E8F6;
        Thu,  7 Nov 2019 15:55:38 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:55:37 -0800 (PST)
Message-Id: <20191107.155537.1932749594952088637.davem@davemloft.net>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: phy: at803x: add missing dependency on
 CONFIG_REGULATOR
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573131824-21664-1-git-send-email-madalin.bucur@nxp.com>
References: <1573131824-21664-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:55:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Thu,  7 Nov 2019 15:03:44 +0200

> Compilation fails on PPC targets as CONFIG_REGULATOR is not set and
> drivers/regulator/devres.c is not compiled in while functions exported
> there are used by drivers/net/phy/at803x.c. Here's the error log:
> 
>   LD      .tmp_vmlinux1
> drivers/net/phy/at803x.o: In function `at803x_rgmii_reg_set_voltage_sel':
> drivers/net/phy/at803x.c:294: undefined reference to `.rdev_get_drvdata'
> drivers/net/phy/at803x.o: In function `at803x_rgmii_reg_get_voltage_sel':
> drivers/net/phy/at803x.c:306: undefined reference to `.rdev_get_drvdata'
> drivers/net/phy/at803x.o: In function `at8031_register_regulators':
> drivers/net/phy/at803x.c:359: undefined reference to `.devm_regulator_register'
> drivers/net/phy/at803x.c:365: undefined reference to `.devm_regulator_register'
> drivers/net/phy/at803x.o:(.data.rel+0x0): undefined reference to `regulator_list_voltage_table'
> linux/Makefile:1074: recipe for target 'vmlinux' failed
> make[1]: *** [vmlinux] Error 1
> 
> Fixes: 2f664823a470 ("net: phy: at803x: add device tree binding")
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>

Applied, thanks.
