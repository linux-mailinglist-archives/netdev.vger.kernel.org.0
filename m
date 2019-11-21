Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4815D104A9B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 07:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfKUGQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 01:16:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUGQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 01:16:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1184E14CDCE51;
        Wed, 20 Nov 2019 22:16:11 -0800 (PST)
Date:   Wed, 20 Nov 2019 22:16:10 -0800 (PST)
Message-Id: <20191120.221610.417773273108238644.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jouni.hogander@unikie.com
Subject: Re: [PATCH net] net-sysfs: fix netdev_queue_add_kobject() breakage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121031907.159416-1-edumazet@google.com>
References: <20191121031907.159416-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 22:16:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 20 Nov 2019 19:19:07 -0800

> kobject_put() should only be called in error path.
> 
> Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jouni Hogander <jouni.hogander@unikie.com>

Sorry, I should push back harder in the future.

Applied, thanks Eric.

