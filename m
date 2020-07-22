Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D515C228DA8
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 03:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbgGVBcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 21:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGVBcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 21:32:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EF2C061794;
        Tue, 21 Jul 2020 18:32:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F67511DB315F;
        Tue, 21 Jul 2020 18:15:23 -0700 (PDT)
Date:   Tue, 21 Jul 2020 18:32:07 -0700 (PDT)
Message-Id: <20200721.183207.2040938284749662736.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     hayashi.kunihiko@socionext.com, kuba@kernel.org,
        p.zabel@pengutronix.de, yamada.masahiro@socionext.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ave: Fix error returns in ave_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717025049.43027-1-wanghai38@huawei.com>
References: <20200717025049.43027-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 18:15:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Fri, 17 Jul 2020 10:50:49 +0800

> When regmap_update_bits failed in ave_init(), calls of the functions
> reset_control_assert() and clk_disable_unprepare() were missed.
> Add goto out_reset_assert to do this.
> 
> Fixes: 57878f2f4697 ("net: ethernet: ave: add support for phy-mode setting of system controller")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied.
