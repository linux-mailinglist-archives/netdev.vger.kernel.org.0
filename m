Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A58241F59
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgHKRhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbgHKRhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:37:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B01C06174A;
        Tue, 11 Aug 2020 10:37:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3DE112880E99;
        Tue, 11 Aug 2020 10:20:20 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:37:05 -0700 (PDT)
Message-Id: <20200811.103705.704240459465657803.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     timur@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: qcom/emac: add missed clk_disable_unprepare
 in error path of emac_clks_phase1_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200810025705.28756-1-wanghai38@huawei.com>
References: <20200810025705.28756-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 10:20:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Mon, 10 Aug 2020 10:57:05 +0800

> Fix the missing clk_disable_unprepare() before return
> from emac_clks_phase1_init() in the error handling case.
> 
> Fixes: b9b17debc69d ("net: emac: emac gigabit ethernet controller driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> Acked-by: Timur Tabi <timur@kernel.org>

Applied, thank you.
