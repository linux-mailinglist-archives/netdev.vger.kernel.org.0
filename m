Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C49278F22
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387982AbfG2PZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:25:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387925AbfG2PZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:25:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AEE212652B26;
        Mon, 29 Jul 2019 08:25:24 -0700 (PDT)
Date:   Mon, 29 Jul 2019 08:25:21 -0700 (PDT)
Message-Id: <20190729.082521.779227260174091484.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     tanhuazhong@huawei.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, linuxarm@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 net-next 00/10] net: hns3: some code optimizations &
 bugfixes & features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1aa604e4afe85fa9cfd2e47fbb5386c2c1041310.camel@mellanox.com>
References: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
        <1aa604e4afe85fa9cfd2e47fbb5386c2c1041310.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 08:25:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 29 Jul 2019 05:48:28 +0000

> On Mon, 2019-07-29 at 10:53 +0800, Huazhong Tan wrote:
>> This patch-set includes code optimizations, bugfixes and features for
>> the HNS3 ethernet controller driver.
 ...
> 
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Series applied.
