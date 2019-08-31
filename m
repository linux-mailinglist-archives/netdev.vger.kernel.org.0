Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C0DA4626
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfHaUTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56040 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbfHaUTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB7C914B87798;
        Sat, 31 Aug 2019 13:19:24 -0700 (PDT)
Date:   Sat, 31 Aug 2019 13:19:24 -0700 (PDT)
Message-Id: <20190831.131924.1389013222410820012.davem@davemloft.net>
To:     george.mccollister@gmail.com
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com, andrew@lunn.ch,
        f.fainelli@gmail.com, Tristram.Ha@microchip.com, marex@denx.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: fill regmap_config name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829141441.70063-1-george.mccollister@gmail.com>
References: <20190829141441.70063-1-george.mccollister@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 13:19:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>
Date: Thu, 29 Aug 2019 09:14:41 -0500

> Use the register value width as the regmap_config name to prevent the
> following error when the second and third regmap_configs are
> initialized.
>  "debugfs: Directory '${bus-id}' with parent 'regmap' already present!"
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Applied.
