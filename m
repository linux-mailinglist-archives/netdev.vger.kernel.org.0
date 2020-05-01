Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839C71C0CED
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgEAD6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgEAD6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:58:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7824AC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:58:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AEA01277C5D9;
        Thu, 30 Apr 2020 20:58:20 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:58:19 -0700 (PDT)
Message-Id: <20200430.205819.2025380921047456400.davem@davemloft.net>
To:     zhengbin13@huawei.com
Cc:     aviad.krawczyk@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH -next] hinic: make symbol 'dump_mox_reg' static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429015824.36496-1-zhengbin13@huawei.com>
References: <20200429015824.36496-1-zhengbin13@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:58:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>
Date: Wed, 29 Apr 2020 09:58:24 +0800

> Fix sparse warnings:
> 
> drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:601:6: warning: symbol 'dump_mox_reg' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Applied to net-next.
