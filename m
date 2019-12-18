Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0945123FDE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLRG5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:57:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRG5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:57:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C67CD1503760F;
        Tue, 17 Dec 2019 22:57:41 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:57:41 -0800 (PST)
Message-Id: <20191217.225741.945639333059506658.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] net-sysfs: Call dev_hold always in rx_queue_add_kobject
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217114634.9428-1-jouni.hogander@unikie.com>
References: <20191217114634.9428-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:57:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Tue, 17 Dec 2019 13:46:34 +0200

> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Dev_hold has to be called always in rx_queue_add_kobject.
> Otherwise usage count drops below 0 in case of failure in
> kobject_init_and_add.
> 
> Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
> Reported-by: syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: David Miller <davem@davemloft.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>

Applied and queued up for -stable.
