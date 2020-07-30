Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BED233C53
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgG3X4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgG3Xz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:55:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E1CC061574;
        Thu, 30 Jul 2020 16:55:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48F89126C2B12;
        Thu, 30 Jul 2020 16:39:13 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:55:57 -0700 (PDT)
Message-Id: <20200730.165557.1799719576391347161.davem@davemloft.net>
To:     luwei32@huawei.com
Cc:     kuba@kernel.org, wangyunjian@huawei.com, dan.carpenter@oracle.com,
        andrew@lunn.ch, alex.williams@ni.com, mdf@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: nixge: fix potential memory leak in nixge_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729035005.89161-1-luwei32@huawei.com>
References: <20200729035005.89161-1-luwei32@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:39:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>
Date: Wed, 29 Jul 2020 11:50:05 +0800

> If some processes in nixge_probe() fail, free_netdev(dev)
> needs to be called to aviod a memory leak.
> 
> Fixes: 87ab207981ec ("net: nixge: Separate ctrl and dma resources")
> Fixes: abcd3d6fc640 ("net: nixge: Fix error path for obtaining mac address")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Lu Wei <luwei32@huawei.com>

Applied, thank you.
