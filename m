Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454993B8B0F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 02:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbhGAADN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:03:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51072 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhGAADM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 20:03:12 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lyk80-0004mk-P0; Thu, 01 Jul 2021 08:00:24 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lyk7j-0007TU-Df; Thu, 01 Jul 2021 08:00:07 +0800
Date:   Thu, 1 Jul 2021 08:00:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com>
Cc:     ardb@kernel.org, bp@alien8.de, dave.hansen@intel.com,
        davem@davemloft.net, hpa@zytor.com, jpa@git.mail.kapsi.fi,
        kan.liang@linux.intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] BUG: scheduling while atomic: syz-executor/ADDR
Message-ID: <20210701000007.GA28683@gondor.apana.org.au>
References: <000000000000459ea305c6000318@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000459ea305c6000318@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 11:37:20AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ff8744b5 Merge branch '100GbE' of git://git.kernel.org/pub..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=163cc5dc300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7cf9abab1592f017
> dashboard link: https://syzkaller.appspot.com/bug?extid=20191dc583eff8602d2d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a81190300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1417f5bfd00000
> 
> The issue was bisected to:
> 
> commit 2481104fe98d5b016fdd95d649b1235f21e491ba
> Author: Ard Biesheuvel <ardb@kernel.org>
> Date:   Thu Dec 31 16:41:55 2020 +0000
> 
>     crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper

Hi Ard:

This looks like the same issue we discussed yesterday.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=164ee60c300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=154ee60c300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=114ee60c300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
> Fixes: 2481104fe98d ("crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper")

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
