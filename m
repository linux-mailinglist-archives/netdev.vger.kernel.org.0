Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E1083AE7
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfHFVPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:15:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfHFVPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:15:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6206812B02594;
        Tue,  6 Aug 2019 14:15:07 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:15:06 -0700 (PDT)
Message-Id: <20190806.141506.1823070920831784903.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        leeyou.li@huawei.com, xiaowei774@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH v1 0/3] net: hisilicon: Fix a few problems with
 hip04_eth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:15:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Sat, 3 Aug 2019 20:31:38 +0800

> During the use of the hip04_eth driver,
> several problems were found,
> which solved the hip04_tx_reclaim reentry problem,
> fixed the problem that hip04_mac_start_xmit never
> returns NETDEV_TX_BUSY
> and the dma_map_single failed on the arm64 platform.

Series applied.
