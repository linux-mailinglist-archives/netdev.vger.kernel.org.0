Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26B826E94D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIQXOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQXOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:14:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB7CC06174A;
        Thu, 17 Sep 2020 16:14:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C05C13659CA5;
        Thu, 17 Sep 2020 15:57:56 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:14:42 -0700 (PDT)
Message-Id: <20200917.161442.927252621269123026.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org, saeed@kernel.org
Subject: Re: [PATCH V2 net-next 0/6] net: hns3: updates for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
References: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 15:57:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 16 Sep 2020 17:33:44 +0800

> There are some optimizations related to IO path.
> 
> Change since V1:
> - fixes a unsuitable handling in hns3_lb_clear_tx_ring() of #6 which
>   pointed out by Saeed Mahameed.
> 
> previous version:
> V1: https://patchwork.ozlabs.org/project/netdev/cover/1600085217-26245-1-git-send-email-tanhuazhong@huawei.com/

Series applied, thank you.
