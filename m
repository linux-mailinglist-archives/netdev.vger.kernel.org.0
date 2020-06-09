Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF71F47DA
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389443AbgFIUO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732949AbgFIUOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:14:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1FAC05BD1E;
        Tue,  9 Jun 2020 13:14:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B21771277F12C;
        Tue,  9 Jun 2020 13:14:24 -0700 (PDT)
Date:   Tue, 09 Jun 2020 13:14:23 -0700 (PDT)
Message-Id: <20200609.131423.797063277862873757.davem@davemloft.net>
To:     valentin@longchamp.me
Cc:     netdev@vger.kernel.org, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] net: sched: export __netdev_watchdog_up()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609201154.22022-1-valentin@longchamp.me>
References: <20200609201154.22022-1-valentin@longchamp.me>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 13:14:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>
Date: Tue,  9 Jun 2020 22:11:54 +0200

> Since the quiesce/activate rework, __netdev_watchdog_up() is directly
> called in the ucc_geth driver.
> 
> Unfortunately, this function is not available for modules and thus
> ucc_geth cannot be built as a module anymore. Fix it by exporting
> __netdev_watchdog_up().
> 
> Since the commit introducing the regression was backported to stable
> branches, this one should ideally be as well.
> 
> Fixes: 79dde73cf9bc ("net/ethernet/freescale: rework quiesce/activate for ucc_geth")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Valentin Longchamp <valentin@longchamp.me>

Applied and queued up for -stable, please don't CC: stable for networking changes
in the future, thank you.
