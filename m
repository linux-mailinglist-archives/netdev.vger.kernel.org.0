Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840431C7CD0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgEFVuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728888AbgEFVuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:50:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E79C061A0F;
        Wed,  6 May 2020 14:50:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6B831273C3A6;
        Wed,  6 May 2020 14:50:16 -0700 (PDT)
Date:   Wed, 06 May 2020 14:50:15 -0700 (PDT)
Message-Id: <20200506.145015.1852712055909777150.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     sd@queasysnail.net, mstarovoitov@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: macsec: fix rtnl locking issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506135830.587297-1-antoine.tenart@bootlin.com>
References: <20200506135830.587297-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:50:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Wed,  6 May 2020 15:58:30 +0200

> netdev_update_features() must be called with the rtnl lock taken. Not
> doing so triggers a warning, as ASSERT_RTNL() is used in
> __netdev_update_features(), the first function called by
> netdev_update_features(). Fix this.
> 
> Fixes: c850240b6c41 ("net: macsec: report real_dev features when HW offloading is enabled")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied, thank you.
