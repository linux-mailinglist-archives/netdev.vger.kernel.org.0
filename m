Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1C32676DC
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgILAlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILAlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:41:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2988C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:41:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B4A112354C92;
        Fri, 11 Sep 2020 17:24:19 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:41:05 -0700 (PDT)
Message-Id: <20200911.174105.1389097498853421345.davem@davemloft.net>
To:     song.bao.hua@hisilicon.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, linuxarm@huawei.com,
        salil.mehta@huawei.com, linyunsheng@huawei.com
Subject: Re: [PATCH net-next] net: hns: use IRQ_NOAUTOEN to avoid irq is
 enabled due to request_irq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911015510.31420-1-song.bao.hua@hisilicon.com>
References: <20200911015510.31420-1-song.bao.hua@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:24:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>
Date: Fri, 11 Sep 2020 13:55:10 +1200

> Rather than doing request_irq and then disabling the irq immediately, it
> should be safer to use IRQ_NOAUTOEN flag for the irq. It removes any gap
> between request_irq() and disable_irq().
> 
> Cc: Salil Mehta <salil.mehta@huawei.com>
> Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>

Applied.
