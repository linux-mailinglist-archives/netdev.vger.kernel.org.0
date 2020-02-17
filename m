Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538271608C2
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBQDZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:25:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgBQDZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:25:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBCD3155CAC90;
        Sun, 16 Feb 2020 19:25:17 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:25:17 -0800 (PST)
Message-Id: <20200216.192517.1439206340999549107.davem@davemloft.net>
To:     arjunroy.kdev@gmail.com
Cc:     netdev@vger.kernel.org, arjunroy@google.com, soheil@google.com,
        edumazet@google.com
Subject: Re: [PATCH net-next 1/2] tcp-zerocopy: Return inq along with tcp
 receive zerocopy.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214233050.19429-1-arjunroy.kdev@gmail.com>
References: <20200214233050.19429-1-arjunroy.kdev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:25:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy.kdev@gmail.com>
Date: Fri, 14 Feb 2020 15:30:49 -0800

> From: Arjun Roy <arjunroy@google.com>
> 
> This patchset is intended to reduce the number of extra system calls
> imposed by TCP receive zerocopy. For ping-pong RPC style workloads,
> this patchset has demonstrated a system call reduction of about 30%
> when coupled with userspace changes.
> 
> For applications using edge-triggered epoll, returning inq along with
> the result of tcp receive zerocopy could remove the need to call
> recvmsg()=-EAGAIN after a successful zerocopy. Generally speaking,
> since normally we would need to perform a recvmsg() call for every
> successful small RPC read via TCP receive zerocopy, returning inq can
> reduce the number of system calls performed by approximately half.
> 
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

Applied.
