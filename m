Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5401E50C1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgE0V4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgE0V4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:56:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE1DC05BD1E;
        Wed, 27 May 2020 14:56:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9482128CE440;
        Wed, 27 May 2020 14:56:22 -0700 (PDT)
Date:   Wed, 27 May 2020 14:56:22 -0700 (PDT)
Message-Id: <20200527.145622.575385364026122212.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH V2 net-next 0/4] net: hns3: misc updates for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590541157-6803-1-git-send-email-tanhuazhong@huawei.com>
References: <1590541157-6803-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 14:56:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 27 May 2020 08:59:13 +0800

> This patchset includes some misc updates for the HNS3 ethernet driver.
> 
> #1 adds a resetting check in hclgevf_init_nic_client_instance().
> #2 adds a preparatory work for RMDA VF's driver.
> #3 removes some unnecessary operations in app loopback.
> #4 adds an error log for debugging.
> 
> Change log:
> V1->V2: removes previous patch#1 which may needs further discussion.

Series applied, thanks.
