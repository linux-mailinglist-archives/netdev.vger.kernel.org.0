Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE24233CB0
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgGaAp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbgGaAp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:45:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6941BC061574;
        Thu, 30 Jul 2020 17:45:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2DBD126C49CA;
        Thu, 30 Jul 2020 17:29:11 -0700 (PDT)
Date:   Thu, 30 Jul 2020 17:45:56 -0700 (PDT)
Message-Id: <20200730.174556.1194233575911645055.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        kuba@kernel.org, mirq-linux@rere.qmqm.pl,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: gemini: Fix missing clk_disable_unprepare()
 in error path of gemini_ethernet_port_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730073000.59797-1-wanghai38@huawei.com>
References: <20200730073000.59797-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 17:29:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Thu, 30 Jul 2020 15:30:00 +0800

> Fix the missing clk_disable_unprepare() before return
> from gemini_ethernet_port_probe() in the error handling case.
> 
> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied.
