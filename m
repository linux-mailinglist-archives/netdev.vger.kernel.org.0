Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E8224229A
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 00:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgHKWne convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Aug 2020 18:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgHKWnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 18:43:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05647C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 15:43:33 -0700 (PDT)
Received: from localhost (50-47-103-195.evrt.wa.frontiernet.net [50.47.103.195])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DD6D128B58B6;
        Tue, 11 Aug 2020 15:26:46 -0700 (PDT)
Date:   Tue, 11 Aug 2020 15:43:31 -0700 (PDT)
Message-Id: <20200811.154331.1038492033389879139.davem@davemloft.net>
To:     marek.behun@nic.cz
Cc:     netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        andrew@lunn.ch, baruch@tkos.co.il, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net] net: phy: marvell10g: fix null pointer dereference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200810150158.25081-1-marek.behun@nic.cz>
References: <20200810150158.25081-1-marek.behun@nic.cz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 15:26:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>
Date: Mon, 10 Aug 2020 17:01:58 +0200

> Commit c3e302edca24 ("net: phy: marvell10g: fix temperature sensor on 2110")
> added a check for PHY ID via phydev->drv->phy_id in a function which is
> called by devres at a time when phydev->drv is already set to null by
> phy_remove function.
> 
> This null pointer dereference can be triggered via SFP subsystem with a
> SFP module containing this Marvell PHY. When the SFP interface is put
> down, the SFP subsystem removes the PHY.
> 
> Fixes: c3e302edca24 ("net: phy: marvell10g: fix temperature sensor on 2110")
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Applied and queued up for -stable, thank you.
