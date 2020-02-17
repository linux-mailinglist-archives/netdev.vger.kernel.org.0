Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06710160AA7
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 07:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgBQGmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 01:42:17 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:38678 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbgBQGmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 01:42:16 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j3a6d-0006zB-SH; Mon, 17 Feb 2020 07:42:11 +0100
Date:   Mon, 17 Feb 2020 07:42:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in nf_tables_table_destroy
Message-ID: <20200217064211.GA19559@breakpoint.cc>
References: <00000000000014b040059c654481@google.com>
 <0000000000003f07f8059ebf6465@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003f07f8059ebf6465@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com> wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit eb014de4fd418de1a277913cba244e47274fe392
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Tue Jan 21 15:48:03 2020 +0000
> 
>     netfilter: nf_tables: autoload modules from the abort path
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e9cc7ee00000
> start commit:   5a9ef194 net: systemport: Fixed queue mapping in internal ..
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
> dashboard link: https://syzkaller.appspot.com/bug?extid=2a3b1b28cad90c608e20
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15338966e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1667d8d6e00000
> 
> If the result looks correct, please mark the bug fixed by replying with:

It does.

#syz fix: netfilter: nf_tables: autoload modules from the abort path
