Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302B11EEDFC
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgFDWyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgFDWyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:54:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47F8C08C5C0;
        Thu,  4 Jun 2020 15:54:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DC5711F5F8D1;
        Thu,  4 Jun 2020 15:54:32 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:54:31 -0700 (PDT)
Message-Id: <20200604.155431.2238306756619358527.davem@davemloft.net>
To:     valentin@longchamp.me
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, stable@vger.kernel.org
Subject: Re: [PATCH] net: sched: export __netdev_watchdog_up()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603211527.11389-1-valentin@longchamp.me>
References: <20200603211527.11389-1-valentin@longchamp.me>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:54:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>
Date: Wed,  3 Jun 2020 23:15:27 +0200

> @@ -464,6 +464,7 @@ void __netdev_watchdog_up(struct net_device *dev)
>  			dev_hold(dev);
>  	}
>  }
> +EXPORT_SYMBOL(__netdev_watchdog_up);

Please use EXPORT_SYMBOL_GPL(), thank you.
