Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE2425403
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbhJGN2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbhJGN2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:28:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB97C061570;
        Thu,  7 Oct 2021 06:26:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mYTPV-00086S-Cb; Thu, 07 Oct 2021 15:26:09 +0200
Date:   Thu, 7 Oct 2021 15:26:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com>
Cc:     kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in nf_tables_dump_sets
Message-ID: <20211007132609.GD25730@breakpoint.cc>
References: <0000000000000845ce05c9222d57@google.com>
 <0000000000000b920e05cdc31f01@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000b920e05cdc31f01@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com> wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit a499b03bf36b0c2e3b958a381d828678ab0ffc5e
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon Sep 13 12:42:33 2021 +0000
> 
>     netfilter: nf_tables: unlink table before deleting it
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13018e98b00000
> start commit:   f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
> dashboard link: https://syzkaller.appspot.com/bug?extid=8cc940a9689599e10587
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fbb98e300000
> 
> If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: nf_tables: unlink table before deleting it

