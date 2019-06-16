Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B5476F5
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfFPVXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:23:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPVXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:23:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B0C8151C035E;
        Sun, 16 Jun 2019 14:23:24 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:23:23 -0700 (PDT)
Message-Id: <20190616.142323.1978847856658542085.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] ax25: fix inconsistent lock state in
 ax25_destroy_timer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615234052.155231-1-edumazet@google.com>
References: <20190615234052.155231-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:23:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 15 Jun 2019 16:40:52 -0700

> Before thread in process context uses bh_lock_sock()
> we must disable bh.
> 
> sysbot reported :
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
