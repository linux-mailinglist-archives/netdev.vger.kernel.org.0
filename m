Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEAA27A405
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgI0UZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgI0UZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:25:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF7C0613CE;
        Sun, 27 Sep 2020 13:25:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 124A213BAF334;
        Sun, 27 Sep 2020 13:08:53 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:25:39 -0700 (PDT)
Message-Id: <20200927.132539.1155509040825181941.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net-next 00/10] net: hns3: updates for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:08:53 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sun, 27 Sep 2020 15:12:38 +0800

> To facilitate code maintenance and compatibility, #1 and #2 add
> device version to replace pci revision, #3 to #9 adds support for
> querying device capabilities and specifications, then the driver
> can use these query results to implement corresponding features
> (some features will be implemented later).
> 
> And #10 is a minor cleanup since too many parameters for
> hclge_shaper_para_calc().

Series applied, thank you.
