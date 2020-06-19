Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DB2200071
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgFSDAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgFSDAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:00:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0142CC06174E;
        Thu, 18 Jun 2020 20:00:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A86F120ED49A;
        Thu, 18 Jun 2020 20:00:10 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:00:09 -0700 (PDT)
Message-Id: <20200618.200009.1375774785038059331.davem@davemloft.net>
To:     s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, thomas.petazzoni@bootlin.com,
        kernel@pengutronix.de, linux@armlinux.org.uk,
        rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH 1/2] net: ethernet: mvneta: Fix Serdes configuration
 for SoCs without comphy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616083140.8498-1-s.hauer@pengutronix.de>
References: <20200616083140.8498-1-s.hauer@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:00:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Tue, 16 Jun 2020 10:31:39 +0200

> The MVNETA_SERDES_CFG register is only available on older SoCs like the
> Armada XP. On newer SoCs like the Armada 38x the fields are moved to
> comphy. This patch moves the writes to this register next to the comphy
> initialization, so that depending on the SoC either comphy or
> MVNETA_SERDES_CFG is configured.
> With this we no longer write to the MVNETA_SERDES_CFG on SoCs where it
> doesn't exist.
> 
> Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied.
