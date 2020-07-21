Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E092274A5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgGUBiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:38:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F39C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:38:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F0DA111FFCC50;
        Mon, 20 Jul 2020 18:21:22 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:38:07 -0700 (PDT)
Message-Id: <20200720.183807.1161867954603054467.davem@davemloft.net>
To:     huangguobin4@huawei.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: ag71xx: add missed clk_disable_unprepare in error
 path of probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720014614.11951-1-huangguobin4@huawei.com>
References: <20200720014614.11951-1-huangguobin4@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:21:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huang Guobin <huangguobin4@huawei.com>
Date: Sun, 19 Jul 2020 21:46:14 -0400

> The ag71xx_mdio_probe() forgets to call clk_disable_unprepare() when
> of_reset_control_get_exclusive() failed. Add the missed call to fix it.
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>

Applied, thanks.
