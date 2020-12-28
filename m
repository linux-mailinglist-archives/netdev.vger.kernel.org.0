Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EBB2E6B34
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgL1W7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgL1W7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 17:59:41 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E944C061796
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 14:59:01 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E07FA4CE686C5;
        Mon, 28 Dec 2020 14:59:00 -0800 (PST)
Date:   Mon, 28 Dec 2020 14:59:00 -0800 (PST)
Message-Id: <20201228.145900.1452796453931346885.davem@davemloft.net>
To:     wangyunjian@huawei.com
Cc:     netdev@vger.kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, liuyonglong@huawei.com,
        jerry.lilijun@huawei.com, xudingke@huawei.com
Subject: Re: [PATCH net v2] net: hns: fix return value check in
 __lb_other_process()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1608970205-24512-1-git-send-email-wangyunjian@huawei.com>
References: <1608970205-24512-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 14:59:01 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangyunjian <wangyunjian@huawei.com>
Date: Sat, 26 Dec 2020 16:10:05 +0800

> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The function skb_copy() could return NULL, the return value
> need to be checked.
> 
> Fixes: b5996f11ea54 ("net: add Hisilicon Network Subsystem basic ethernet support")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Applied and queued up for -stable, thanks.
