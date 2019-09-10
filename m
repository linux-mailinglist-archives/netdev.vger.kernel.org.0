Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D367AF069
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437074AbfIJRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:25:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394139AbfIJRZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:25:24 -0400
Received: from localhost (unknown [88.214.187.211])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7F24154FE282;
        Tue, 10 Sep 2019 10:25:21 -0700 (PDT)
Date:   Tue, 10 Sep 2019 19:25:16 +0200 (CEST)
Message-Id: <20190910.192516.1686418457520996592.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com,
        huangguangbin2@huawei.com
Subject: Re: [PATCH net-next 1/7] net: hns3: add ethtool_ops.set_channels
 support for HNS3 VF driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568105908-60983-2-git-send-email-tanhuazhong@huawei.com>
References: <1568105908-60983-1-git-send-email-tanhuazhong@huawei.com>
        <1568105908-60983-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 10:25:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Tue, 10 Sep 2019 16:58:22 +0800

> +	/* Set to user value, no larger than max_rss_size. */
> +	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
> +	    kinfo->req_rss_size <= max_rss_size) {
> +		dev_info(&hdev->pdev->dev, "rss changes from %u to %u\n",
> +			 kinfo->rss_size, kinfo->req_rss_size);
> +		kinfo->rss_size = kinfo->req_rss_size;

Please do not emit kernel log messages for normal operations.
