Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B858714F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405425AbfHIFRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:17:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbfHIFRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:17:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 951B31428D99E;
        Thu,  8 Aug 2019 22:17:08 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:17:08 -0700 (PDT)
Message-Id: <20190808.221708.1683611820360022260.davem@davemloft.net>
To:     huangfq.daxian@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tundra: tsi108: use spin_lock_irqsave instead of
 spin_lock_irq in IRQ context
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190807074300.23135-1-huangfq.daxian@gmail.com>
References: <20190807074300.23135-1-huangfq.daxian@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:17:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com>
Date: Wed,  7 Aug 2019 15:43:00 +0800

> @@ -372,8 +372,9 @@ static void tsi108_stat_carry(struct net_device *dev)
>  {
>  	struct tsi108_prv_data *data = netdev_priv(dev);
>  	u32 carry1, carry2;
> +	unsigned long flags;

Please preserve reverse christmas tree ordering of local variables.

Thank you.
