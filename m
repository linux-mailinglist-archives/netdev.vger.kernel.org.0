Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C6DD5366
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 02:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfJMAUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 20:20:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJMAUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 20:20:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F0381518AA40;
        Sat, 12 Oct 2019 17:20:50 -0700 (PDT)
Date:   Sat, 12 Oct 2019 17:20:47 -0700 (PDT)
Message-Id: <20191012.172047.1002092281347029283.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH 1/2] net: dsa: microchip: Do not reinit mutexes on
 KSZ87xx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010182508.22833-1-marex@denx.de>
References: <20191010182508.22833-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 12 Oct 2019 17:20:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Thu, 10 Oct 2019 20:25:07 +0200

> The KSZ87xx driver calls mutex_init() on mutexes already inited in
> ksz_common.c ksz_switch_register(). Do not do it twice, drop the
> reinitialization.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
