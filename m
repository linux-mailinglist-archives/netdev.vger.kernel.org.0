Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA97FE650
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfKOUTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:19:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOUTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:19:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3B9914E0B9A2;
        Fri, 15 Nov 2019 12:19:39 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:19:39 -0800 (PST)
Message-Id: <20191115.121939.1590711559229159022.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     tglx@linutronix.de, allison@lohutok.net, swinslow@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ax88172a: fix information leak on short answers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114101601.31734-1-oneukum@suse.com>
References: <20191114101601.31734-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:19:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 14 Nov 2019 11:16:01 +0100

> If a malicious device gives a short MAC it can elicit up to
> 5 bytes of leaked memory out of the driver. We need to check for
> ETH_ALEN instead.
> 
> Reported-by: syzbot+a8d4acdad35e6bbca308@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Applied and queued up for -stable.
