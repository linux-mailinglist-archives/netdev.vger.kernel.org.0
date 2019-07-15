Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BC069A98
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbfGOSKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:10:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfGOSKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 14:10:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1692914EB4AF1;
        Mon, 15 Jul 2019 11:10:49 -0700 (PDT)
Date:   Mon, 15 Jul 2019 11:10:48 -0700 (PDT)
Message-Id: <20190715.111048.106149919999844475.davem@davemloft.net>
To:     tranmanphong@gmail.com
Cc:     syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com,
        isdn@linux-pingi.de, gregkh@linuxfoundation.org,
        andreyknvl@google.com, bigeasy@linutronix.de,
        gustavo@embeddedor.com, pakki001@umn.edu,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH] ISDN: hfcsusb: checking idx of ep configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190715150814.20022-1-tranmanphong@gmail.com>
References: <000000000000f2b23d05868310f9@google.com>
        <20190715150814.20022-1-tranmanphong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jul 2019 11:10:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>
Date: Mon, 15 Jul 2019 22:08:14 +0700

> The syzbot test with random endpoint address which made the idx is
> overflow in the table of endpoint configuations.
> 
> this adds the checking for fixing the error report from
> syzbot
> 
> KASAN: stack-out-of-bounds Read in hfcsusb_probe [1]
> The patch tested by syzbot [2]
> 
> Reported-by: syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com
> 
> [1]:
> https://syzkaller.appspot.com/bug?id=30a04378dac680c5d521304a00a86156bb913522
> [2]:
> https://groups.google.com/d/msg/syzkaller-bugs/_6HBdge8F3E/OJn7wVNpBAAJ
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

Applied.
