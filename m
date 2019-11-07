Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8B1F275E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKGFro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:47:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfKGFro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D57211513A138;
        Wed,  6 Nov 2019 21:47:43 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:47:43 -0800 (PST)
Message-Id: <20191106.214743.227020197538874041.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net] net: hns3: add compatible handling for command
 HCLGE_OPC_PF_RST_DONE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573090219-9785-1-git-send-email-tanhuazhong@huawei.com>
References: <1573090219-9785-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:47:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 7 Nov 2019 09:30:19 +0800

> Since old firmware does not support HCLGE_OPC_PF_RST_DONE, it will
> return -EOPNOTSUPP to the driver when received this command. So
> for this case, it should just print a warning and return success
> to the caller.
> 
> Fixes: 72e2fb07997c ("net: hns3: clear reset interrupt status in hclge_irq_handle()")
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Applied, thanks.
