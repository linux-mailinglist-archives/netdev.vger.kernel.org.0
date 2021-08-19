Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6BE3F1CB9
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhHSP27 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Aug 2021 11:28:59 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59573 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238643AbhHSP26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:28:58 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id AAB43CED18;
        Thu, 19 Aug 2021 17:28:20 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v2] Bluetooth: add timeout sanity check to hci_inquiry
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210819151521.17380-1-paskripkin@gmail.com>
Date:   Thu, 19 Aug 2021 17:28:20 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <DAF9831E-3871-48AC-A4ED-856546E4B126@holtmann.org>
References: <0038C6D9-DEAF-4CB2-874C-00F6CEFCF26C@holtmann.org>
 <20210819151521.17380-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> Syzbot hit "task hung" bug in hci_req_sync(). The problem was in
> unreasonable huge inquiry timeout passed from userspace.
> Fix it by adding sanity check for timeout value to hci_inquiry().
> 
> Since hci_inquiry() is the only user of hci_req_sync() with user
> controlled timeout value, it makes sense to check timeout value in
> hci_inquiry() and don't touch hci_req_sync().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-and-tested-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Changes in v2:
> 	Removed define + added comment suggested by Marcel
> 
> ---
> net/bluetooth/hci_core.c | 6 ++++++
> 1 file changed, 6 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

