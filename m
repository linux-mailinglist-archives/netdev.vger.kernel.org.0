Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B28228BF8
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbgGUWfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUWfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:35:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DDFC061794;
        Tue, 21 Jul 2020 15:35:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B39D11E45902;
        Tue, 21 Jul 2020 15:18:56 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:35:40 -0700 (PDT)
Message-Id: <20200721.153540.1987383939849734513.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mdio-mux-gpio: use devm_gpiod_get_array()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721150134.5ba52595@xhacker.debian>
References: <20200721150134.5ba52595@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:18:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Tue, 21 Jul 2020 15:01:57 +0800

> Use devm_gpiod_get_array() to simplify the error handling and exit
> code path.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Applied.
