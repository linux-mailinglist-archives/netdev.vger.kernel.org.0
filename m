Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22431FC029
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgFPUmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgFPUmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:42:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE6BC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 13:42:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7224F128D495F;
        Tue, 16 Jun 2020 13:42:11 -0700 (PDT)
Date:   Tue, 16 Jun 2020 13:42:10 -0700 (PDT)
Message-Id: <20200616.134210.827974432867806903.davem@davemloft.net>
To:     sven.auhagen@voleatech.de
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        gregory.clement@bootlin.com, maxime.chevallier@bootlin.com,
        thomas.petazzoni@bootlin.com, miquel.raynal@bootlin.com,
        mw@semihalf.com, lorenzo@kernel.org, technoboy85@gmail.com
Subject: Re: [PATCH 1/1 v2] mvpp2: remove module bugfix
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616043529.gs2vcdryka7t4hjo@SvensMacBookAir.sven.lan>
References: <20200616043529.gs2vcdryka7t4hjo@SvensMacBookAir.sven.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 13:42:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>
Date: Tue, 16 Jun 2020 06:35:29 +0200

> The remove function does not destroy all
> BM Pools when per cpu pool is active.
> 
> When reloading the mvpp2 as a module the BM Pools
> are still active in hardware and due to the bug
> have twice the size now old + new.
> 
> This eventually leads to a kernel crash.
> 
> v2:
> * add Fixes tag
> 
> Fixes: 7d04b0b13b11 ("mvpp2: percpu buffers")
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Applied and queued up for -stable, thanks.
