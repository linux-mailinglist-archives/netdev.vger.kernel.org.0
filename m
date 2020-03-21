Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7155118DE31
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 06:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgCUFmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 01:42:37 -0400
Received: from isilmar-4.linta.de ([136.243.71.142]:36190 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgCUFmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 01:42:36 -0400
Received: by isilmar-4.linta.de (Postfix, from userid 1000)
        id 442E2200B38; Sat, 21 Mar 2020 05:42:35 +0000 (UTC)
Date:   Sat, 21 Mar 2020 06:42:35 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>
Cc:     adam.zerella@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, hdanton@sina.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, xiyou.wangcong@gmail.com
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
Message-ID: <20200321054235.s35tcj23hcfnc6wx@isilmar-4.linta.de>
References: <000000000000b380de059f5ff6aa@google.com>
 <00000000000006777805a1561fa3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000006777805a1561fa3@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:49:03PM -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 836e9494f4485127a5b505ae57e4387bea8b53c4
> Author: Adam Zerella <adam.zerella@gmail.com>
> Date:   Sun Aug 25 05:35:10 2019 +0000
> 
>     pcmcia/i82092: Refactored dprintk macro for dev_dbg().
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175cffe3e00000
> start commit:   74522e7b net: sched: set the hw_stats_type in pedit loop
> git tree:       net-next
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14dcffe3e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10dcffe3e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b5acf5ac38a50651
> dashboard link: https://syzkaller.appspot.com/bug?extid=46f513c3033d592409d2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17bfff65e00000
> 
> Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> Fixes: 836e9494f448 ("pcmcia/i82092: Refactored dprintk macro for dev_dbg().")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

That bisect evidently can't be right.

Thanks,
	Dominik
