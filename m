Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E571EAD2A
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbgFASnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731432AbgFASmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:42:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D396AC0085C1;
        Mon,  1 Jun 2020 11:35:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CAF8120ED480;
        Mon,  1 Jun 2020 11:35:37 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:35:36 -0700 (PDT)
Message-Id: <20200601.113536.134620919829517847.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        kuba@kernel.org, matthias.bgg@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        fparent@baylibre.com, stephane.leprovost@mediatek.com,
        pedro.tsai@mediatek.com, andrew.perepech@mediatek.com,
        bgolaszewski@baylibre.com
Subject: Re: [PATCH v3 0/2] regmap: provide simple bitops and use them in a
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528154503.26304-1-brgl@bgdev.pl>
References: <20200528154503.26304-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:35:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 May 2020 17:45:01 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> I noticed that oftentimes I use regmap_update_bits() for simple bit
> setting or clearing. In this case the fourth argument is superfluous as
> it's always 0 or equal to the mask argument.
> 
> This series proposes to add simple bit operations for setting, clearing
> and testing specific bits with regmap.
> 
> The second patch uses all three in a driver that got recently picked into
> the net-next tree.
> 
> The patches obviously target different trees so - if you're ok with
> the change itself - I propose you pick the first one into your regmap
> tree for v5.8 and then I'll resend the second patch to add the first
> user for these macros for v5.9.
> 
> v1 -> v2:
> - convert the new macros to static inline functions
> 
> v2 -> v3:
> - drop unneeded ternary operator

Series applied to net-next, thank you.
