Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83756133E97
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgAHJxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:53:18 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47188 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgAHJxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 04:53:18 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ip81Z-0002NP-B2; Wed, 08 Jan 2020 10:53:13 +0100
Date:   Wed, 8 Jan 2020 10:53:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+b8e32edde51fdcc8c2c4@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: general protection fault in hash_net4_uadt
Message-ID: <20200108095313.GW795@breakpoint.cc>
References: <000000000000dd1cb0059b9d50b7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dd1cb0059b9d50b7@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+b8e32edde51fdcc8c2c4@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    c101fffc Merge tag 'mlx5-fixes-2020-01-06' of git://git.ke..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1452e656e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
> dashboard link: https://syzkaller.appspot.com/bug?extid=b8e32edde51fdcc8c2c4
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ef2459e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113b9459e00000
> 
> The bug was bisected to:

#syz dup: general protection fault in hash_ipportnet4_uadt
