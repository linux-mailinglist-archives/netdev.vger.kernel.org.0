Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073668A776
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfHLTp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:45:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60609 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLTp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 15:45:58 -0400
Received: from p200300ddd71876867e7a91fffec98e25.dip0.t-ipconnect.de ([2003:dd:d718:7686:7e7a:91ff:fec9:8e25])
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hxGGH-0004oy-4v; Mon, 12 Aug 2019 21:45:45 +0200
Date:   Mon, 12 Aug 2019 21:45:39 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     syzbot <syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com>
cc:     alexander.h.duyck@intel.com, amritha.nambiar@intel.com,
        andriy.shevchenko@linux.intel.com, avagin@gmail.com,
        davem@davemloft.net, dmitry.torokhov@gmail.com, dvyukov@google.com,
        eric.dumazet@gmail.com, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, idosch@mellanox.com, jiri@mellanox.com,
        kimbrownkd@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tyhicks@canonical.com, wanghai26@huawei.com, yuehaibing@huawei.com
Subject: Re: WARNING: ODEBUG bug in netdev_freemem (2)
In-Reply-To: <000000000000ea2c30058f901624@google.com>
Message-ID: <alpine.DEB.2.21.1908122143290.7324@nanos.tec.linutronix.de>
References: <000000000000ea2c30058f901624@google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019, syzbot wrote:

> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    13dfb3fa Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1671e69a600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=c4521ac872a4ccc3afec
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170542c2600000

I can't reproduce that here. Can you please apply the patch from:

  https://lore.kernel.org/lkml/alpine.DEB.2.21.1906241920540.32342@nanos.tec.linutronix.de

and try to reproduce with that applied? That should give us more
information about the actual delayed work.

Thanks,

	tglx
