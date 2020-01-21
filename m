Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBF0143D4F
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgAUMyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:54:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUMyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:54:45 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B838F1502E6BF;
        Tue, 21 Jan 2020 04:54:43 -0800 (PST)
Date:   Tue, 21 Jan 2020 13:54:39 +0100 (CET)
Message-Id: <20200121.135439.1619270282552230019.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        pmalani@chromium.org, grundler@chromium.org
Subject: Re: [PATCH net 2/9] r8152: reset flow control patch when linking
 on for RTL8153B
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-340-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
        <1394712342-15778-340-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 04:54:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 21 Jan 2020 20:40:28 +0800

> When linking ON, the patch of flow control has to be reset. This
> makes sure the patch works normally.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 115559707683..64efd58279b3 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -2857,6 +2857,7 @@ static void r8153_set_rx_early_size(struct r8152 *tp)
>  
>  static int rtl8153_enable(struct r8152 *tp)
>  {
> +	u32 ocp_data;
>  	if (test_bit(RTL8152_UNPLUG, &tp->flags))
>  		return -ENODEV;
>  

Please put an empty line after the local variable declarations.

Thank you.
