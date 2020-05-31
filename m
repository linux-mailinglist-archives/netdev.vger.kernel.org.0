Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2341E95BD
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgEaE5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaE5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:57:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFB7C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:57:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EEED2129033E0;
        Sat, 30 May 2020 21:57:47 -0700 (PDT)
Date:   Sat, 30 May 2020 21:57:47 -0700 (PDT)
Message-Id: <20200530.215747.1590223834792811961.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jchapman@katalix.com, gnault@redhat.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] l2tp: add sk_family checks to l2tp_validate_socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529183225.150288-1-edumazet@google.com>
References: <20200529183225.150288-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:57:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 29 May 2020 11:32:25 -0700

> syzbot was able to trigger a crash after using an ISDN socket
> and fool l2tp.
> 
> Fix this by making sure the UDP socket is of the proper family.
 ...
> Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
> Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: James Chapman <jchapman@katalix.com>
> Cc: Guillaume Nault <gnault@redhat.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
