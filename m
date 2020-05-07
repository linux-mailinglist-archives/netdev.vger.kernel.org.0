Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A921C9C0A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgEGUSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgEGUSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:18:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55083C05BD43;
        Thu,  7 May 2020 13:18:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D54361195050E;
        Thu,  7 May 2020 13:18:10 -0700 (PDT)
Date:   Thu, 07 May 2020 13:18:10 -0700 (PDT)
Message-Id: <20200507.131810.1223197596910994375.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        huangdaode@hisilicon.com, liguozhu@huawei.com, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hisilicon: Make CONFIG_HNS invisible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507114511.24835-1-geert+renesas@glider.be>
References: <20200507114511.24835-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:18:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu,  7 May 2020 13:45:11 +0200

> The HNS config symbol enables the framework support for the Hisilicon
> Network Subsystem.  It is already selected by all of its users, so there
> is no reason to make it visible.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied, thanks.
