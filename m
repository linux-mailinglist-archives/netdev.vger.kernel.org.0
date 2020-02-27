Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873F0170F9A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgB0EVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:21:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgB0EVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:21:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1900415B47865;
        Wed, 26 Feb 2020 20:21:44 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:21:43 -0800 (PST)
Message-Id: <20200226.202143.318859004492363807.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com,
        daniel@iogearbox.net
Subject: Re: [PATCH net] ipv6: restrict IPV6_ADDRFORM operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225195229.183443-1-edumazet@google.com>
References: <20200225195229.183443-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:21:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 25 Feb 2020 11:52:29 -0800

> IPV6_ADDRFORM is able to transform IPv6 socket to IPv4 one.
> While this operation sounds illogical, we have to support it.
> 
> One of the things it does for TCP socket is to switch sk->sk_prot
> to tcp_prot.
> 
> We now have other layers playing with sk->sk_prot, so we should make
> sure to not interfere with them.
> 
> This patch makes sure sk_prot is the default pointer for TCP IPv6 socket.
  ...
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks Eric.
