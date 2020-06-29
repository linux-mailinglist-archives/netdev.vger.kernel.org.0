Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C36720CC32
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 05:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgF2DlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 23:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgF2DlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 23:41:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59042C03E979;
        Sun, 28 Jun 2020 20:41:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56B97129A6052;
        Sun, 28 Jun 2020 20:41:17 -0700 (PDT)
Date:   Sun, 28 Jun 2020 20:41:13 -0700 (PDT)
Message-Id: <20200628.204113.838024173548329216.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
Subject: Re: [PATCH net-next v4 0/5] hinic: add some ethtool ops support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200628123624.600-1-luobin9@huawei.com>
References: <20200628123624.600-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 20:41:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Sun, 28 Jun 2020 20:36:19 +0800

> patch #1: support to set and get pause params with
>           "ethtool -A/a" cmd
> patch #2: support to set and get irq coalesce params with
>           "ethtool -C/c" cmd
> patch #3: support to do self test with "ethtool -t" cmd
> patch #4: support to identify physical device with "ethtool -p" cmd
> patch #5: support to get eeprom information with "ethtool -m" cmd

Series applied, thank you.
