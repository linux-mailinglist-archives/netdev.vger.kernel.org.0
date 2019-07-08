Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F88461A4A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 07:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfGHFSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 01:18:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfGHFSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 01:18:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C8AD152F8549;
        Sun,  7 Jul 2019 22:18:05 -0700 (PDT)
Date:   Sun, 07 Jul 2019 22:18:05 -0700 (PDT)
Message-Id: <20190707.221805.2104668553072088371.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        dingtianhong@huawei.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, leeyou.li@huawei.com,
        xiekunxun@huawei.com, jianping.liu@huawei.com,
        nixiaoming@huawei.com
Subject: Re: [PATCH] net: hisilicon: Add an tx_desc to adapt HI13X1_GMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562307003-103516-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1562307003-103516-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 22:18:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Fri, 5 Jul 2019 14:10:03 +0800

> HI13X1 changed the offsets and bitmaps for tx_desc
> registers in the same peripheral device on different
> models of the hip04_eth.
> 
> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

Applied.
