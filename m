Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB18344A6E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhCVQF4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Mar 2021 12:05:56 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:32869 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhCVQFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:05:16 -0400
Received: from marcel-macbook.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id D844DCECB0;
        Mon, 22 Mar 2021 17:12:52 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Bluetooth: initialize skb_queue_head at
 l2cap_chan_create()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210321225207.3635-1-penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Mon, 22 Mar 2021 17:05:14 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BF8AE591-517E-493C-B1F4-9B4629D869C9@holtmann.org>
References: <20210321225207.3635-1-penguin-kernel@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tetsuo,

> syzbot is hitting "INFO: trying to register non-static key." message [1],
> for "struct l2cap_chan"->tx_q.lock spinlock is not yet initialized when
> l2cap_chan_del() is called due to e.g. timeout.
> 
> Since "struct l2cap_chan"->lock mutex is initialized at l2cap_chan_create()
> immediately after "struct l2cap_chan" is allocated using kzalloc(), let's
> as well initialize "struct l2cap_chan"->{tx_q,srej_q}.lock spinlocks there.
> 
> [1] https://syzkaller.appspot.com/bug?extid=fadfba6a911f6bf71842
> 
> Reported-and-tested-by: syzbot <syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> net/bluetooth/l2cap_core.c | 2 ++
> 1 file changed, 2 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

