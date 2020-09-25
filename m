Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D35A277E7A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgIYDTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgIYDTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:19:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D0BC0613CE;
        Thu, 24 Sep 2020 20:19:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 070DB135F8F2B;
        Thu, 24 Sep 2020 20:02:55 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:19:42 -0700 (PDT)
Message-Id: <20200924.201942.1679145349636019640.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net-next 0/6] net: hns3: updates for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
References: <1600993578-41008-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 20:02:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Fri, 25 Sep 2020 08:26:12 +0800

> There are some updates for the HNS3 ethernet driver.
> #1 & #2 are two cleanups.
> #3 adds new hardware error for the client.
> #4 adds debugfs support the pf's interrupt resource.
> #5 adds new pci device id for 200G device.
> #6 renames the unsuitable macro of vf's pci device id.

Series applied, thank you.
