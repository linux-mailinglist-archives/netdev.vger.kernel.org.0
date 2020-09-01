Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F3A259E60
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbgIAStF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIAStF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:49:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DF6C061244;
        Tue,  1 Sep 2020 11:49:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1573513630BDF;
        Tue,  1 Sep 2020 11:32:18 -0700 (PDT)
Date:   Tue, 01 Sep 2020 11:49:04 -0700 (PDT)
Message-Id: <20200901.114904.1478557687217786852.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sungem: Remove unneeded cast from memory
 allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901141028.25264-1-yuehaibing@huawei.com>
References: <20200901141028.25264-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 11:32:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 1 Sep 2020 22:10:28 +0800

> Remove dma_alloc_coherent return value cast.
> This is detected by coccinelle.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
