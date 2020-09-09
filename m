Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E031D262560
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIICwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIICwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:52:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89266C061573;
        Tue,  8 Sep 2020 19:52:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88BFD11E3E4C2;
        Tue,  8 Sep 2020 19:35:14 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:52:00 -0700 (PDT)
Message-Id: <20200908.195200.348674254136090256.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     tanhuazhong@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH net-next 0/7] net: hns3: misc updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908120538.4ba70787@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
        <20200908120538.4ba70787@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:35:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 8 Sep 2020 12:05:38 -0700

> On Tue, 8 Sep 2020 10:59:47 +0800 Huazhong Tan wrote:
>> There are some misc updates for the HNS3 ethernet driver.
>> 
>> #1 narrows two local variable range in hclgevf_reset_prepare_wait().
>> #2 adds reset failure check in periodic service task.
>> #3~#7 adds some cleanups.
> 
> Looks trivial:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
