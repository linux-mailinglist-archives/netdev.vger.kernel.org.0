Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D79AF9A54
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKLUMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:12:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKLUMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:12:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1376154D250F;
        Tue, 12 Nov 2019 12:12:08 -0800 (PST)
Date:   Mon, 11 Nov 2019 15:14:35 -0800 (PST)
Message-Id: <20191111.151435.931035548376130641.davem@davemloft.net>
To:     clabbe@baylibre.com
Cc:     alexandre.torgue@st.com, joabreu@synopsys.com, mripard@kernel.org,
        peppe.cavallaro@st.com, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: dwmac-sun8i: Use the correct function
 in exit path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573385448-30282-1-git-send-email-clabbe@baylibre.com>
References: <1573385448-30282-1-git-send-email-clabbe@baylibre.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:12:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>
Date: Sun, 10 Nov 2019 11:30:48 +0000

> When PHY is not powered, the probe function fail and some resource are
> still unallocated.
> Furthermore some BUG happens:
> dwmac-sun8i 5020000.ethernet: EMAC reset timeout
> ------------[ cut here ]------------
> kernel BUG at /linux-next/net/core/dev.c:9844!
> 
> So let's use the right function (stmmac_pltfr_remove) in the error path.
> 
> Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
> Cc: <stable@vger.kernel.org> # v4.15+
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Applied.
