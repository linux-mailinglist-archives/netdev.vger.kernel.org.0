Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904D716083F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgBQCjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:39:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:39:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67EAD15383A77;
        Sun, 16 Feb 2020 18:39:02 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:39:01 -0800 (PST)
Message-Id: <20200216.183901.2213122541309483812.davem@davemloft.net>
To:     jethro@fortanix.com
Cc:     kuba@kernel.org, jiri@mellanox.com, liuhangbin@gmail.com,
        natechancellor@gmail.com, tglx@linutronix.de,
        johannes.berg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fib_rules: Correctly set table field when table
 number exceeds 8 bits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ec5c8c2f-34c6-bd70-7f61-7ed14b358d9d@fortanix.com>
References: <ec5c8c2f-34c6-bd70-7f61-7ed14b358d9d@fortanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:39:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jethro Beekman <jethro@fortanix.com>
Date: Wed, 12 Feb 2020 16:43:41 +0100

> In 709772e6e06564ed94ba740de70185ac3d792773, RT_TABLE_COMPAT was added to
> allow legacy software to deal with routing table numbers >= 256, but the
> same change to FIB rule queries was overlooked.
> 
> Signed-off-by: Jethro Beekman <jethro@fortanix.com>

Applied and queued up for -stable.
