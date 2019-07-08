Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB5562832
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 20:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388180AbfGHSSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 14:18:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728765AbfGHSSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 14:18:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71BFF1535A5C5;
        Mon,  8 Jul 2019 11:18:36 -0700 (PDT)
Date:   Mon, 08 Jul 2019 11:18:33 -0700 (PDT)
Message-Id: <20190708.111833.1002341757593028886.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        dingtianhong@huawei.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, leeyou.li@huawei.com,
        xiekunxun@huawei.com, jianping.liu@huawei.com,
        nixiaoming@huawei.com
Subject: Re: [PATCH] net: hisilicon: Add an tx_desc to adapt HI13X1_GMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190707.221805.2104668553072088371.davem@davemloft.net>
References: <1562307003-103516-1-git-send-email-xiaojiangfeng@huawei.com>
        <20190707.221805.2104668553072088371.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 11:18:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 07 Jul 2019 22:18:05 -0700 (PDT)

> From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
> Date: Fri, 5 Jul 2019 14:10:03 +0800
> 
>> HI13X1 changed the offsets and bitmaps for tx_desc
>> registers in the same peripheral device on different
>> models of the hip04_eth.
>> 
>> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
> 
> Applied.

Actually I didn't apply this because I can't see that HI13X1_GMAC
kconfig knob anywhere in the tree at all.
