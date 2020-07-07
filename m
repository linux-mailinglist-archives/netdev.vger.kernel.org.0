Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA432217AF5
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgGGWYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgGGWYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:24:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00977C061755;
        Tue,  7 Jul 2020 15:24:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86C6B120F19F2;
        Tue,  7 Jul 2020 15:24:18 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:24:17 -0700 (PDT)
Message-Id: <20200707.152417.1518177240219672343.davem@davemloft.net>
To:     trix@redhat.com
Cc:     mlindner@marvell.com, stephen@networkplumber.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sky2: initialize return of gm_phy_read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703133359.22723-1-trix@redhat.com>
References: <20200703133359.22723-1-trix@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:24:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: trix@redhat.com
Date: Fri,  3 Jul 2020 06:33:59 -0700

> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this garbage return
> 
> drivers/net/ethernet/marvell/sky2.c:208:2: warning: Undefined or garbage value returned to caller [core.uninitialized.UndefReturn]
>         return v;
>         ^~~~~~~~
> 
> static inline u16 gm_phy_read( ...
> {
> 	u16 v;
> 	__gm_phy_read(hw, port, reg, &v);
> 	return v;
> }
> 
> __gm_phy_read can return without setting v.
> 
> So handle similar to skge.c's gm_phy_read, initialize v.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied, thank you.
