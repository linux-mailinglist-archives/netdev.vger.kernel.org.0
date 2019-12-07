Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D50115AF7
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 05:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfLGEjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 23:39:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGEjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 23:39:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B6831537B3B1;
        Fri,  6 Dec 2019 20:39:32 -0800 (PST)
Date:   Fri, 06 Dec 2019 20:39:32 -0800 (PST)
Message-Id: <20191206.203932.877539573857084483.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] net-sysfs: Call dev_hold always in
 netdev_queue_add_kobject
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205135707.13221-1-jouni.hogander@unikie.com>
References: <20191205135707.13221-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 20:39:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Thu,  5 Dec 2019 15:57:07 +0200

> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Dev_hold has to be called always in netdev_queue_add_kobject.
> Otherwise usage count drops below 0 in case of failure in
> kobject_init_and_add.
> 
> Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
> Reported-by: Hulk Robot <hulkci@huawei.com>

Applied and queued up for -stable, thanks.
