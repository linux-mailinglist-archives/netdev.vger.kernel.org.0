Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01901DFC02
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbgEWX4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbgEWX4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:56:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0D4C061A0E;
        Sat, 23 May 2020 16:56:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E5D81287375F;
        Sat, 23 May 2020 16:56:33 -0700 (PDT)
Date:   Sat, 23 May 2020 16:56:32 -0700 (PDT)
Message-Id: <20200523.165632.2131763470920616688.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     corbet@lwn.net, matthias.bgg@gmail.com, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com, kuba@kernel.org,
        arnd@arndb.de, fparent@baylibre.com, hkallweit1@gmail.com,
        edwin.peer@broadcom.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        stephane.leprovost@mediatek.com, pedro.tsai@mediatek.com,
        andrew.perepech@mediatek.com, bgolaszewski@baylibre.com
Subject: Re: [PATCH v2 0/5] net: provide a devres variant of
 register_netdev()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200523132711.30617-1-brgl@bgdev.pl>
References: <20200523132711.30617-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:56:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Sat, 23 May 2020 15:27:06 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Using devres helpers allows to shrink the probing code, avoid memory leaks in
> error paths make sure the order in which resources are freed is the exact
> opposite of their allocation. This series proposes to add a devres variant
> of register_netdev() that will only work with net_device structures whose
> memory is also managed.
> 
> First we add the missing documentation entry for the only other networking
> devres helper: devm_alloc_etherdev().
> 
> Next we move devm_alloc_etherdev() into a separate source file.
> 
> We then use a proxy structure in devm_alloc_etherdev() to improve readability.
> 
> Last: we implement devm_register_netdev() and use it in mtk-eth-mac driver.
> 
> v1 -> v2:
> - rebase on top of net-next after driver rename, no functional changes

Series applied, thank you.
