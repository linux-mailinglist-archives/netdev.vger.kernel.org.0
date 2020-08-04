Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E90523C213
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHDXLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgHDXLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:11:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A012C06174A;
        Tue,  4 Aug 2020 16:11:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A3E612896E69;
        Tue,  4 Aug 2020 15:54:23 -0700 (PDT)
Date:   Tue, 04 Aug 2020 16:11:08 -0700 (PDT)
Message-Id: <20200804.161108.958554880119569573.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com, kuba@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dpaa2-eth: Fix passing zero to 'PTR_ERR' warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804132643.42104-1-yuehaibing@huawei.com>
References: <20200804132643.42104-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:54:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 4 Aug 2020 21:26:43 +0800

> Fix smatch warning:
> 
> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2419
>  alloc_channel() warn: passing zero to 'ERR_PTR'
> 
> setup_dpcon() should return ERR_PTR(err) instead of zero in error
> handling case.
> 
> Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied and queued up for -stable, thank you.
