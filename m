Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40911C5FDA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgEESPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgEESPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:15:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922E6C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 11:15:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D8DC127EDEB5;
        Tue,  5 May 2020 11:15:14 -0700 (PDT)
Date:   Tue, 05 May 2020 11:15:13 -0700 (PDT)
Message-Id: <20200505.111513.846973842490478548.davem@davemloft.net>
To:     wangyunjian@huawei.com
Cc:     netdev@vger.kernel.org, jerry.lilijun@huawei.com,
        xudingke@huawei.com
Subject: Re: [PATCH net-next] net: allwinner: Fix use correct return type
 for ndo_start_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588646960-89296-1-git-send-email-wangyunjian@huawei.com>
References: <1588646960-89296-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:15:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangyunjian <wangyunjian@huawei.com>
Date: Tue, 5 May 2020 10:49:20 +0800

> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
> the ndo function to use the correct type. And emac_start_xmit() can
> leak one skb if 'channel' == 3.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Applied, thank you.
