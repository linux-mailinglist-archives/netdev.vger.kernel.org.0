Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D15207ED4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404823AbgFXVsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404563AbgFXVsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:48:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B4EC061573;
        Wed, 24 Jun 2020 14:48:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C09F12737AF7;
        Wed, 24 Jun 2020 14:48:11 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:48:10 -0700 (PDT)
Message-Id: <20200624.144810.1787595389624931255.davem@davemloft.net>
To:     s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, thomas.petazzoni@bootlin.com,
        kernel@pengutronix.de, linux@armlinux.org.uk
Subject: Re: [PATCH 1/2] net: ethernet: mvneta: Do not error out in non
 serdes modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624070045.8878-1-s.hauer@pengutronix.de>
References: <20200624070045.8878-1-s.hauer@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:48:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Wed, 24 Jun 2020 09:00:44 +0200

> In mvneta_config_interface() the RGMII modes are catched by the default
> case which is an error return. The RGMII modes are valid modes for the
> driver, so instead of returning an error add a break statement to return
> successfully.
> 
> This avoids this warning for non comphy SoCs which use RGMII, like
> SolidRun Clearfog:
> 
> WARNING: CPU: 0 PID: 268 at drivers/net/ethernet/marvell/mvneta.c:3512 mvneta_start_dev+0x220/0x23c
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied.
