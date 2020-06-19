Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7344200073
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgFSDAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbgFSDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:00:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D69DC06174E;
        Thu, 18 Jun 2020 20:00:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1F7F120ED49C;
        Thu, 18 Jun 2020 20:00:16 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:00:16 -0700 (PDT)
Message-Id: <20200618.200016.309123510624309005.davem@davemloft.net>
To:     s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, thomas.petazzoni@bootlin.com,
        kernel@pengutronix.de, linux@armlinux.org.uk
Subject: Re: [PATCH 2/2] net: ethernet: mvneta: Add 2500BaseX support for
 SoCs without comphy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616083140.8498-2-s.hauer@pengutronix.de>
References: <20200616083140.8498-1-s.hauer@pengutronix.de>
        <20200616083140.8498-2-s.hauer@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:00:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Tue, 16 Jun 2020 10:31:40 +0200

> The older SoCs like Armada XP support a 2500BaseX mode in the datasheets
> referred to as DR-SGMII (Double rated SGMII) or HS-SGMII (High Speed
> SGMII). This is an upclocked 1000BaseX mode, thus
> PHY_INTERFACE_MODE_2500BASEX is the appropriate mode define for it.
> adding support for it merely means writing the correct magic value into
> the MVNETA_SERDES_CFG register.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied.
