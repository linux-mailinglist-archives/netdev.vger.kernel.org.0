Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F667391B5F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhEZPOa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 May 2021 11:14:30 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35182 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbhEZPO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:14:26 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id B4038CED1D;
        Wed, 26 May 2021 17:20:47 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH 05/12] Bluetooth: use inclusive language in L2CAP
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210525182900.5.I8353f22ae68a7e5ed9aaa44a692dec6d11bcb43a@changeid>
Date:   Wed, 26 May 2021 17:12:51 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <234F83C9-7D24-41A5-A6B4-7B9F515323C0@holtmann.org>
References: <20210525102941.3958649-1-apusaka@google.com>
 <20210525182900.5.I8353f22ae68a7e5ed9aaa44a692dec6d11bcb43a@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Use "central" and "peripheral".
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> 
> include/net/bluetooth/l2cap.h | 2 +-
> net/bluetooth/l2cap_sock.c    | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
> index 3c4f550e5a8b..1f5ed6b163af 100644
> --- a/include/net/bluetooth/l2cap.h
> +++ b/include/net/bluetooth/l2cap.h
> @@ -89,7 +89,7 @@ struct l2cap_conninfo {
> };
> 
> #define L2CAP_LM	0x03
> -#define L2CAP_LM_MASTER		0x0001
> +#define L2CAP_LM_CENTRAL	0x0001
> #define L2CAP_LM_AUTH		0x0002
> #define L2CAP_LM_ENCRYPT	0x0004
> #define L2CAP_LM_TRUSTED	0x0008

same as with the RFCOMM change, this is something I am not prepared to do right now since it touches API.

Regards

Marcel

