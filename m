Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FCC3A8135
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhFONqk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 09:46:40 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56593 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhFONqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:46:03 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id D9D5DCECF4;
        Tue, 15 Jun 2021 15:51:55 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] Bluetooth: Fix a spelling mistake
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210615112443.13956-1-13145886936@163.com>
Date:   Tue, 15 Jun 2021 15:43:54 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        gushengxian <gushengxian@yulong.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <12122F14-688A-41B0-ABA7-90CC893005E8@holtmann.org>
References: <20210615112443.13956-1-13145886936@163.com>
To:     13145886936@163.com
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Fix a spelling mistake.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
> net/bluetooth/hci_conn.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> index 2b5059a56cda..e91ac6945ec3 100644
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -760,7 +760,7 @@ void hci_le_conn_failed(struct hci_conn *conn, u8 status)
> 	/* If the status indicates successful cancellation of
> 	 * the attempt (i.e. Unknown Connection Id) there's no point of
> 	 * notifying failure since we'll go back to keep trying to
> -	 * connect. The only exception is explicit connect requests
> +	 * connect. The only exception is explicit connection requests
> 	 * where a timeout + cancel does indicate an actual failure.

I am not even convinced this is a spelling mistake since according to the specification they are connect requests. Anyhow, I no considering patches without proper real name attached to it and send from a total vague email address.

Regards

Marcel

