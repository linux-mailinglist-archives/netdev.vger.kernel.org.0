Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FFF2247D7
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgGRBlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRBlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:41:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15565C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 18:41:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8987111E45914;
        Fri, 17 Jul 2020 18:41:46 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:41:45 -0700 (PDT)
Message-Id: <20200717.184145.1710848863414831357.davem@davemloft.net>
To:     liujian56@huawei.com
Cc:     madalin.bucur@nxp.com, kuba@kernel.org, laurentiu.tudor@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] dpaa_eth: Fix one possible memleak in
 dpaa_eth_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717090528.19683-1-liujian56@huawei.com>
References: <20200717090528.19683-1-liujian56@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:41:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>
Date: Fri, 17 Jul 2020 17:05:28 +0800

> When dma_coerce_mask_and_coherent() fails, the alloced netdev need to be freed.
> 
> Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

This is a bug fix introduced in v5.5, therefore it should be targetting
'net' instead of 'net-next'.
