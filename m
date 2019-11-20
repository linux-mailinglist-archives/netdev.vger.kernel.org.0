Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A694B1044CA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKTUKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:10:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbfKTUKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:10:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1045214C1A0CE;
        Wed, 20 Nov 2019 12:10:14 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:10:13 -0800 (PST)
Message-Id: <20191120.121013.1898975725512803153.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: [PATCH] net-sysfs: Fix reference count leak in
 rx|netdev_queue_add_kobject
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120070816.12893-1-jouni.hogander@unikie.com>
References: <20191120070816.12893-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:10:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Wed, 20 Nov 2019 09:08:16 +0200

> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> kobject_init_and_add takes reference even when it fails. This has
> to be given up by the caller in error handling. Otherwise memory
> allocated by kobject_init_and_add is never freed. Originally found
> by Syzkaller:
> 
> BUG: memory leak
 ...
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>

Applied, thank you.
