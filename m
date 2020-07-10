Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B204A21BBE1
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGJRIx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 13:08:53 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42254 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJRIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:08:53 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id B137CCED26;
        Fri, 10 Jul 2020 19:18:48 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Linux-kernel-mentees] [PATCH v3] net/bluetooth: Fix
 slab-out-of-bounds read in hci_extended_inquiry_result_evt()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200710160915.228980-1-yepeilin.cs@gmail.com>
Date:   Fri, 10 Jul 2020 19:08:51 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <43E6945B-1FFE-4283-9F1B-E84AFDCB528F@holtmann.org>
References: <20200709130224.214204-1-yepeilin.cs@gmail.com>
 <20200710160915.228980-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peilin,

> Check upon `num_rsp` is insufficient. A malformed event packet with a
> large `num_rsp` number makes hci_extended_inquiry_result_evt() go out
> of bounds. Fix it.
> 
> This patch fixes the following syzbot bug:
> 
>    https://syzkaller.appspot.com/bug?id=4bf11aa05c4ca51ce0df86e500fce486552dc8d2
> 
> Reported-by: syzbot+d8489a79b781849b9c46@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Change in v3:
>    - Minimum `skb->len` requirement was 1 byte inaccurate since `info`
>      starts from `skb->data + 1`. Fix it.
> 
> Changes in v2:
>    - Use `skb->len` instead of `skb->truesize` as the length limit.
>    - Leave `num_rsp` as of type `int`.
> 
> net/bluetooth/hci_event.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

