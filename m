Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E54391B33
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhEZPJa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 May 2021 11:09:30 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37910 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbhEZPJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:09:28 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1A4C1CED1B;
        Wed, 26 May 2021 17:15:51 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH 06/12] Bluetooth: use inclusive language in RFCOMM
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210525182900.6.Id35872ce1572f18e0792e6f4d70721132e97a480@changeid>
Date:   Wed, 26 May 2021 17:07:55 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <42C641C9-2EAC-4A47-9FF7-8A079DF278E0@holtmann.org>
References: <20210525102941.3958649-1-apusaka@google.com>
 <20210525182900.6.Id35872ce1572f18e0792e6f4d70721132e97a480@changeid>
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
> include/net/bluetooth/rfcomm.h | 2 +-
> net/bluetooth/rfcomm/sock.c    | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
> index 99d26879b02a..6472ec0053b9 100644
> --- a/include/net/bluetooth/rfcomm.h
> +++ b/include/net/bluetooth/rfcomm.h
> @@ -290,7 +290,7 @@ struct rfcomm_conninfo {
> };
> 
> #define RFCOMM_LM	0x03
> -#define RFCOMM_LM_MASTER	0x0001
> +#define RFCOMM_LM_CENTRAL	0x0001
> #define RFCOMM_LM_AUTH		0x0002
> #define RFCOMM_LM_ENCRYPT	0x0004
> #define RFCOMM_LM_TRUSTED	0x0008

I am not planning to accept this change any time soon since this is also in the libbluetooth API.

Regards

Marcel

