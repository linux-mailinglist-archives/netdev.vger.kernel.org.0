Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1B326259B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgIIDEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIDEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:04:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D7AC061573;
        Tue,  8 Sep 2020 20:04:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0AB211E3E4C2;
        Tue,  8 Sep 2020 19:48:02 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:04:48 -0700 (PDT)
Message-Id: <20200908.200448.786052648973453640.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     aelior@marvell.com, skalluru@marvell.com, kuba@kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bnx2x: Fix some kernel-doc warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908140158.23540-1-wanghai38@huawei.com>
References: <20200908140158.23540-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:48:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Tue, 8 Sep 2020 22:01:58 +0800

> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:4238: warning: Excess function parameter 'netdev' description in 'bnx2x_setup_tc'
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:4238: warning: Excess function parameter 'tc' description in 'bnx2x_setup_tc'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied.
