Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF2335B3E6
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 13:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhDKLxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 07:53:04 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:57565 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhDKLxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 07:53:03 -0400
Received: from marcel-macbook.holtmann.net (p5b3d235a.dip0.t-ipconnect.de [91.61.35.90])
        by mail.holtmann.org (Postfix) with ESMTPSA id 47E12CECF3;
        Sun, 11 Apr 2021 14:00:29 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH -next] Bluetooth: use flexible-array member instead of
 zero-length array
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210410021935.11100-1-linqiheng@huawei.com>
Date:   Sun, 11 Apr 2021 13:52:44 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <25F45C8F-E979-401C-8DCD-6A0F618AE4E1@holtmann.org>
References: <20210410021935.11100-1-linqiheng@huawei.com>
To:     Qiheng Lin <linqiheng@huawei.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qiheng,

> Fix the following coccicheck warning:
> 
> net/bluetooth/msft.c:37:6-13: WARNING use flexible-array member instead
> net/bluetooth/msft.c:42:6-10: WARNING use flexible-array member instead
> net/bluetooth/msft.c:52:6-10: WARNING use flexible-array member instead
> 
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
> ---
> net/bluetooth/msft.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

