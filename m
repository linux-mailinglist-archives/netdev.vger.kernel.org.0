Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E11ED84FF
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390374AbfJPAmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:42:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390304AbfJPAmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:42:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96B351264CB8F;
        Tue, 15 Oct 2019 17:42:09 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:42:09 -0700 (PDT)
Message-Id: <20191015.174209.218969750454729705.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        sean.nyekjaer@prevas.dk, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH net V4 1/2] net: phy: micrel: Discern KSZ8051 and
 KSZ8795 PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191013212404.31708-1-marex@denx.de>
References: <20191013212404.31708-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 17:42:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 13 Oct 2019 23:24:03 +0200

> Signed-off-by: Marek Vasut <marex@denx.de>
> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")

I'm sorry to be strict, but as Heiner said the Fixes: tag needs to be
the first tag.

I'm pushing this back to you so that you can learn how to submit patches
properly in the future, nothing more.

Thank you.
