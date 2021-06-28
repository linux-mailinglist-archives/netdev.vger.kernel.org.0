Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191173B6528
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 17:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhF1PWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 11:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhF1PRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 11:17:15 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 026026144F;
        Mon, 28 Jun 2021 15:14:47 +0000 (UTC)
Date:   Mon, 28 Jun 2021 11:14:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Tanner Love <tannerlove@google.com>
Subject: Re: [PATCH net-next v3 1/2] once: implement DO_ONCE_LITE for
 non-fast-path "do once" functionality
Message-ID: <20210628111446.357b2418@oasis.local.home>
In-Reply-To: <20210628135007.1358909-2-tannerlove.kernel@gmail.com>
References: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
        <20210628135007.1358909-2-tannerlove.kernel@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Jun 2021 09:50:06 -0400
Tanner Love <tannerlove.kernel@gmail.com> wrote:

> Certain uses of "do once" functionality reside outside of fast path,
> and so do not require jump label patching via static keys, making
> existing DO_ONCE undesirable in such cases.
> 
> Replace uses of __section(".data.once") with DO_ONCE_LITE(_IF)?

I hate the name "_LITE" but can't come up with something better.

Maybe: DO_ONCE_SLOW() ??

Anyway, besides my bike-shedding comment above...

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

