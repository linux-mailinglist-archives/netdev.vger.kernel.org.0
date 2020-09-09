Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C848A26383B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgIIVMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIIVMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:12:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88113C061573;
        Wed,  9 Sep 2020 14:12:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD8AE12987FA8;
        Wed,  9 Sep 2020 13:55:56 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:12:40 -0700 (PDT)
Message-Id: <20200909.141240.592595734266972499.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     kuba@kernel.org, sgoutham@marvell.com, bprakash@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: cavium: Fix a bunch of kerneldoc
 parameter issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909132109.71466-1-wanghai38@huawei.com>
References: <20200909132109.71466-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 13:55:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Wed, 9 Sep 2020 21:21:09 +0800

> Rename ptp to ptp_info.
> 
> Fix W=1 compile warnings (invalid kerneldoc):
> 
> drivers/net/ethernet/cavium/common/cavium_ptp.c:94: warning: Excess function parameter 'ptp' description in 'cavium_ptp_adjfine'
> drivers/net/ethernet/cavium/common/cavium_ptp.c:141: warning: Excess function parameter 'ptp' description in 'cavium_ptp_adjtime'
> drivers/net/ethernet/cavium/common/cavium_ptp.c:163: warning: Excess function parameter 'ptp' description in 'cavium_ptp_gettime'
> drivers/net/ethernet/cavium/common/cavium_ptp.c:185: warning: Excess function parameter 'ptp' description in 'cavium_ptp_settime'
> drivers/net/ethernet/cavium/common/cavium_ptp.c:208: warning: Excess function parameter 'ptp' description in 'cavium_ptp_enable'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied, thanks.
