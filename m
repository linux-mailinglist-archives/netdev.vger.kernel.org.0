Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6C81982DC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgC3R6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:58:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC3R6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:58:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F3FB15C42F38;
        Mon, 30 Mar 2020 10:58:11 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:58:10 -0700 (PDT)
Message-Id: <20200330.105810.1336682738792998927.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net 0/4] net: hns3: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
References: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:58:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sat, 28 Mar 2020 15:09:54 +0800

> This patchset includes some bugfixes for the HNS3 ethernet driver.
> 
> [patch 1] removes flag WQ_MEM_RECLAIM flag when allocating WE,
> since it will cause a warning when the reset task flushes a IB's WQ.
> 
> [patch 2] adds a new DESC_TYPE_FRAGLIST_SKB type to handle the
> linear data of the fraglist SKB, since it is different with the frag
> data.
> 
> [patch 3] adds different handings for RSS configuration when load
> or reset.
> 
> [patch 4] fixes a link ksetting issue.

Series applied, thanks.
