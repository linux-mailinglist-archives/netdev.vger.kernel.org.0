Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8E21F5F69
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 03:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgFKBJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 21:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgFKBJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 21:09:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51B3C08C5C1;
        Wed, 10 Jun 2020 18:09:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F365C11F5F667;
        Wed, 10 Jun 2020 18:09:22 -0700 (PDT)
Date:   Wed, 10 Jun 2020 18:08:26 -0700 (PDT)
Message-Id: <20200610.180826.499189657042137494.davem@davemloft.net>
To:     wang.yi59@zte.com.cn
Cc:     kuba@kernel.org, mst@redhat.com, hkallweit1@gmail.com,
        snelson@pensando.io, andriy.shevchenko@linux.intel.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, liao.pingfang@zte.com.cn
Subject: Re: [PATCH v2] net: atm: Remove the error message according to the
 atomic context
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1591835930-25941-1-git-send-email-wang.yi59@zte.com.cn>
References: <1591835930-25941-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 18:09:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Wang <wang.yi59@zte.com.cn>
Date: Thu, 11 Jun 2020 08:38:50 +0800

> @@ -1537,7 +1537,6 @@ static struct lec_arp_table *make_entry(struct lec_priv *priv,
>  
>  	to_return = kzalloc(sizeof(struct lec_arp_table), GFP_ATOMIC);
>  	if (!to_return) {
> -		pr_info("LEC: Arp entry kmalloc failed\n");
>  		return NULL;
>  	}

This now becomes a single-statement basic block and thus the curly
braces should be removed.
