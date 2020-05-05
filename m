Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266B01C5FDB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbgEESQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730334AbgEESQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:16:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCEBC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 11:16:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87391127ED12F;
        Tue,  5 May 2020 11:16:18 -0700 (PDT)
Date:   Tue, 05 May 2020 11:16:17 -0700 (PDT)
Message-Id: <20200505.111617.246133350266575891.davem@davemloft.net>
To:     wangyunjian@huawei.com
Cc:     netdev@vger.kernel.org, jerry.lilijun@huawei.com,
        xudingke@huawei.com
Subject: Re: [PATCH net-next] net: altera: Fix use correct return type for
 ndo_start_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588648005-84716-1-git-send-email-wangyunjian@huawei.com>
References: <1588648005-84716-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:16:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangyunjian <wangyunjian@huawei.com>
Date: Tue, 5 May 2020 11:06:45 +0800

> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
> the ndo function to use the correct type.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Applied, thanks.
