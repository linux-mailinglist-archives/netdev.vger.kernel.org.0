Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AAF11497E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 23:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfLEWpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 17:45:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48754 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfLEWpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 17:45:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30C21150AF907;
        Thu,  5 Dec 2019 14:45:41 -0800 (PST)
Date:   Thu, 05 Dec 2019 14:45:40 -0800 (PST)
Message-Id: <20191205.144540.791142390544922677.davem@davemloft.net>
To:     ebiggers@kernel.org
Cc:     arnd@arndb.de, viro@zeniv.linux.org.uk, paulus@samba.org,
        bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+eb853b51b10f1befa0b7@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ppp: fix out-of-bounds access in bpf_prog_create()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205055419.13435-1-ebiggers@kernel.org>
References: <20191205052220.GC1158@sol.localdomain>
        <20191205055419.13435-1-ebiggers@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 14:45:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>
Date: Wed,  4 Dec 2019 21:54:19 -0800

> From: Eric Biggers <ebiggers@google.com>
> 
> sock_fprog_kern::len is in units of struct sock_filter, not bytes.
> 
> Fixes: 3e859adf3643 ("compat_ioctl: unify copy-in of ppp filters")
> Reported-by: syzbot+eb853b51b10f1befa0b7@syzkaller.appspotmail.com
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thank you.
