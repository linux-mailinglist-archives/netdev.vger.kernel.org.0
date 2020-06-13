Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1051F85A0
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgFMW3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFMW3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 18:29:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF69C03E96F;
        Sat, 13 Jun 2020 15:29:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DFC011F5F637;
        Sat, 13 Jun 2020 15:29:30 -0700 (PDT)
Date:   Sat, 13 Jun 2020 15:29:30 -0700 (PDT)
Message-Id: <20200613.152930.1679140276381230351.davem@davemloft.net>
To:     wang.yi59@zte.com.cn
Cc:     kuba@kernel.org, mst@redhat.com, hkallweit1@gmail.com,
        snelson@pensando.io, andriy.shevchenko@linux.intel.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, liao.pingfang@zte.com.cn
Subject: Re: [PATCH v3] net: atm: Remove the error message according to the
 atomic context
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592028206-19557-1-git-send-email-wang.yi59@zte.com.cn>
References: <1592028206-19557-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jun 2020 15:29:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Wang <wang.yi59@zte.com.cn>
Date: Sat, 13 Jun 2020 14:03:26 +0800

> From: Liao Pingfang <liao.pingfang@zte.com.cn>
> 
> Looking into the context (atomic!) and the error message should be dropped.
> 
> Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
> ---
> Changes in v3: remove {} as there is only one statement left.

Applied, thank you.
