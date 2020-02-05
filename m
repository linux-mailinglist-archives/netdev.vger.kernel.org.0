Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3475C152757
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 09:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgBEIGE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Feb 2020 03:06:04 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38576 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgBEIGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 03:06:04 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 690C3CECC4;
        Wed,  5 Feb 2020 09:15:24 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] Bluetooth: prefetch channel before killing sock
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200205023159.8764-1-hdanton@sina.com>
Date:   Wed, 5 Feb 2020 09:06:02 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com,
        Manish Mandlik <mmandlik@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A08603C3-A9D9-4991-9609-664AF01A77D2@holtmann.org>
References: <20200205023159.8764-1-hdanton@sina.com>
To:     Hillf Danton <hdanton@sina.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hillf,

> Prefetch channel before killing sock in order to fix UAF like
> 
> BUG: KASAN: use-after-free in l2cap_sock_release+0x24c/0x290 net/bluetooth/l2cap_sock.c:1212
> Read of size 8 at addr ffff8880944904a0 by task syz-fuzzer/9751
> 
> Reported-by: syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com
> Fixes: 6c08fc896b60 ("Bluetooth: Fix refcount use-after-free issue")
> Cc: Manish Mandlik <mmandlik@google.com>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> ---

patch has been applied to bluetooth-next tree.

Regards

Marcel

