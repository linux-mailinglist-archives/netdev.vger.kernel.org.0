Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488B530274F
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 16:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbhAYPvn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Jan 2021 10:51:43 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:41343 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730538AbhAYPvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:51:37 -0500
Received: from marcel-macbook.holtmann.net (p4ff9f11c.dip0.t-ipconnect.de [79.249.241.28])
        by mail.holtmann.org (Postfix) with ESMTPSA id CA9C6CECCB;
        Mon, 25 Jan 2021 16:21:57 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH] Bluetooth: drop HCI device reference before return
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210121073419.14219-1-bianpan2016@163.com>
Date:   Mon, 25 Jan 2021 16:14:32 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <67A0679C-ADCD-433F-9E94-E8A575DBEDCF@holtmann.org>
References: <20210121073419.14219-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pan,

> Call hci_dev_put() to decrement reference count of HCI device hdev if
> fails to duplicate memory.
> 
> Fixes: 0b26ab9dce74 ("Bluetooth: AMP: Handle Accept phylink command status evt")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
> net/bluetooth/a2mp.c | 1 +
> 1 file changed, 1 insertion(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

