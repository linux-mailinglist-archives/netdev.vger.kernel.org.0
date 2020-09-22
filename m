Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC737273790
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgIVAje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbgIVAjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:39:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B5EC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:39:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36B1B128514DD;
        Mon, 21 Sep 2020 17:22:46 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:39:32 -0700 (PDT)
Message-Id: <20200921.173932.434070285456316707.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, pabeni@redhat.com,
        cpaasch@apple.com, mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net] inet_diag: validate INET_DIAG_REQ_PROTOCOL
 attribute
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921142720.2328827-1-edumazet@google.com>
References: <20200921142720.2328827-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:22:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 21 Sep 2020 07:27:20 -0700

> User space could send an invalid INET_DIAG_REQ_PROTOCOL attribute
> as caught by syzbot.
> 
> BUG: KMSAN: uninit-value in inet_diag_lock_handler net/ipv4/inet_diag.c:55 [inline]
> BUG: KMSAN: uninit-value in __inet_diag_dump+0x58c/0x720 net/ipv4/inet_diag.c:1147
> CPU: 0 PID: 8505 Comm: syz-executor174 Not tainted 5.9.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 ...
> Fixes: 3f935c75eb52 ("inet_diag: support for wider protocol numbers")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
