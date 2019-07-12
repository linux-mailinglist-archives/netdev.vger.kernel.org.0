Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77B567697
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfGLWhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:37:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfGLWhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:37:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF21F14E01C15;
        Fri, 12 Jul 2019 15:37:30 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:37:30 -0700 (PDT)
Message-Id: <20190712.153730.2158185171235731158.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, leeyou.li@huawei.com,
        nixiaoming@huawei.com
Subject: Re: [PATCH] net: hisilicon: Use devm_platform_ioremap_resource
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562937384-121710-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1562937384-121710-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:37:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Fri, 12 Jul 2019 21:16:24 +0800

> Use devm_platform_ioremap_resource instead of
> devm_ioremap_resource. Make the code simpler.
> 
> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

Applied.
