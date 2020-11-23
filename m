Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782492C0519
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgKWL6P convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Nov 2020 06:58:15 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:46490 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbgKWL6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:58:14 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9EA1ACECD0;
        Mon, 23 Nov 2020 13:05:23 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH net] Bluetooth: Fix potential null pointer dereference in
 create_le_conn_complete
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201113113956.52187-1-wanghai38@huawei.com>
Date:   Mon, 23 Nov 2020 12:58:10 +0100
Cc:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Johan Hedberg <johan.hedberg@gmail.com>, jpawlowski@google.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2E78F25D-78D0-410A-8EAD-76BA4466975B@holtmann.org>
References: <20201113113956.52187-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

> The pointer 'conn' may be null. Before being used by
> hci_connect_le_scan_cleanup(), The pointer 'conn' must be
> checked whether it is null.
> 
> Fixes: 28a667c9c279 ("Bluetooth: advertisement handling in new connect procedure")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> net/bluetooth/hci_conn.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)

please send a version that applies cleanly against bluetooth-next tree.

Regards

Marcel

