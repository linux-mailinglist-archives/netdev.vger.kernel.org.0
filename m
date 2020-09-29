Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329DF27D9DF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgI2VWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729227AbgI2VWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:22:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC3CC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:22:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9399311E48E24;
        Tue, 29 Sep 2020 14:05:49 -0700 (PDT)
Date:   Tue, 29 Sep 2020 14:22:36 -0700 (PDT)
Message-Id: <20200929.142236.1524944235588705685.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] lib8390: Replace panic() call with
 BUILD_BUG_ON
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929171326.6492-1-W_Armin@gmx.de>
References: <20200929171326.6492-1-W_Armin@gmx.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 14:05:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Tue, 29 Sep 2020 19:13:26 +0200

> Replace panic() call in lib8390.c with BUILD_BUG_ON()
> since checking the size of struct e8390_pkt_hdr should
> happen at compile-time.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
> v2 changes:
> - remove __packed from struct e8390_pkt_hdr

Applied, thank you.
