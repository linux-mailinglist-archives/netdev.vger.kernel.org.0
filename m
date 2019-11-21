Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31790105A96
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKUTsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:48:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUTsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:48:43 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E423915043D54;
        Thu, 21 Nov 2019 11:48:42 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:48:42 -0800 (PST)
Message-Id: <20191121.114842.691994230482213922.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     allison@lohutok.net, alexios.zavras@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] nfc: port100: handle command failure cleanly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121103710.28204-1-oneukum@suse.com>
References: <20191121103710.28204-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 11:48:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 21 Nov 2019 11:37:10 +0100

> If starting the transfer of a command suceeds but the transfer for the reply
> fails, it is not enough to initiate killing the transfer for the
> command may still be running. You need to wait for the killing to finish
> before you can reuse URB and buffer.
> 
> Reported-and-tested-by: syzbot+711468aa5c3a1eabf863@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Applied.
