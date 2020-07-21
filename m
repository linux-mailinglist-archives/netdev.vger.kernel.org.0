Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F32E22742A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgGUAyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgGUAyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:54:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC491C0619D6
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 17:54:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D45C11E8EC36;
        Mon, 20 Jul 2020 17:38:08 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:54:52 -0700 (PDT)
Message-Id: <20200720.175452.2244840347891900.davem@davemloft.net>
To:     liujian56@huawei.com
Cc:     madalin.bucur@nxp.com, kuba@kernel.org, laurentiu.tudor@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] dpaa_eth: Fix one possible memleak in
 dpaa_eth_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720142829.40067-1-liujian56@huawei.com>
References: <20200720142829.40067-1-liujian56@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:38:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>
Date: Mon, 20 Jul 2020 22:28:29 +0800

> When dma_coerce_mask_and_coherent() fails, the alloced netdev need to be freed.
> 
> Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Applied and queued up for -stable, thanks.
