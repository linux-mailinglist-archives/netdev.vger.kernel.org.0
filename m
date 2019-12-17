Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71621239CF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLQWUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:20:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfLQWUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:20:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CADB61476F2C2;
        Tue, 17 Dec 2019 14:20:48 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:20:48 -0800 (PST)
Message-Id: <20191217.142048.1420015947023495901.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] net-sysfs: Call dev_hold always in rx_queue_add_kobject
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217084429.28001-1-jouni.hogander@unikie.com>
References: <20191217084429.28001-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 14:20:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Tue, 17 Dec 2019 10:44:29 +0200

> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Dev_hold has to be called always in rx_queue_add_kobject.
> Otherwise usage count drops below 0 in case of failure in
> kobject_init_and_add.
> 
> Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: David Miller <davem@davemloft.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>

Why are you posting this again, the change is already in my tree?
