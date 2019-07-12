Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE5E6769A
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfGLWiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:38:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34374 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfGLWiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:38:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57B2714E03862;
        Fri, 12 Jul 2019 15:38:23 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:38:22 -0700 (PDT)
Message-Id: <20190712.153822.3133898993550292.davem@davemloft.net>
To:     chunkeey@gmail.com
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, lkp@intel.com
Subject: Re: [PATCH] net: dsa: qca8k: replace legacy gpio include
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190712153336.5018-1-chunkeey@gmail.com>
References: <20190712153336.5018-1-chunkeey@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:38:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>
Date: Fri, 12 Jul 2019 17:33:36 +0200

> This patch replaces the legacy bulk gpio.h include
> with the proper gpio/consumer.h variant. This was
> caught by the kbuild test robot that was running
> into an error because of this.
> 
> For more information why linux/gpio.h is bad can be found in:
> commit 56a46b6144e7 ("gpio: Clarify that <linux/gpio.h> is legacy")
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Link: https://www.spinics.net/lists/netdev/msg584447.html
> Fixes: a653f2f538f9 ("net: dsa: qca8k: introduce reset via gpio feature")
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

Applied.
