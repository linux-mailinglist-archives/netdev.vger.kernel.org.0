Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A2A271169
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 01:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgISXkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 19:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgISXkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 19:40:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A80C061755;
        Sat, 19 Sep 2020 16:40:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21F5A11FFD367;
        Sat, 19 Sep 2020 16:23:35 -0700 (PDT)
Date:   Sat, 19 Sep 2020 16:40:19 -0700 (PDT)
Message-Id: <20200919.164019.1690811970196105603.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     kuba@kernel.org, hch@infradead.org, mkubecek@suse.cz,
        andrew@lunn.ch, f.fainelli@gmail.com, gustavo@embeddedor.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ethtool: improve compat ioctl handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918120536.1464804-1-arnd@arndb.de>
References: <20200918120536.1464804-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 16:23:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 18 Sep 2020 14:05:18 +0200

> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
 ...
> +static inline bool ethtool_translate_compat(void)
> +{

Please don't use the inline keyword in foo.c files.

Thank you.
