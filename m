Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4BE164F4
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 15:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEGNti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 09:49:38 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34904 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfEGNth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 09:49:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id p26so945765edr.2;
        Tue, 07 May 2019 06:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=euemdhHUFLuSuId1RNfwYjKhHGbhd9gRXwryEuN0UN8=;
        b=Gya7RSBvbDj7ToTPgKhS6yAIXnCX8xm9zep18SKqSe5SUR1WW0paYN3kFGCHu+Kkc6
         ed5/OlwGHIenGWvC2wror9do3NnU4n6hMDqJ9hhQIFXCqqpBuNOJlH/Sxv80yb+L2bd9
         lb1lX8u+qVasahpBpBZSi05ly0k0RJSJERSs4c3mmP3wACKt9/72T111HdqTKG2i8LvS
         z0JVla1ixYxsPpQa7pX20R3l2eEFD/SPABChWG1k0BeuRneH66i1LEwiEHexmnXsy3Ru
         WY2GS7QigIoHDmXHaQsPCmIhPo3FeM470q7zLGlrAzLaY9G86yp31edMj5hIw2rex6Z3
         O4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=euemdhHUFLuSuId1RNfwYjKhHGbhd9gRXwryEuN0UN8=;
        b=eCF5CXmGoIBZ7SKGtuNtpbiC9eVqFOPI+tRbQw/LYUTc9+15Uk8p9D10UyosSmju5y
         LXZaQ2lTnQI6FzsSXJAVG8GokOfwcXYhTttnr7duKs/OJ7T0w6kKKWM5YoQfBnRNc0Pj
         bv0Dw7yqdnS+OzK8Imbvb3eeGRiS9StpSKYvyh0q11wYl2jpiDZB56jAyGYZ4t/40vA5
         foE60fiKo/OOVl2NIzaYtXqPM4UmA1wJNEDuXV8tHoEcMRqC80tdx024ZrzYl9jRSqCj
         Y094lPHvlEM7iOeopnCGuwHBL2mULkvwyztF9TrDAhJL77Z95g9RnflpTi0nQbZ6T0BP
         uCNg==
X-Gm-Message-State: APjAAAWIvmQy94ggctd5FeKgT6lEKzE/ginqv0ZJIVI/rmWcB8EGa1oa
        CPlXGnVAkPAwrYhRJ9sysgugGsmjc9XMI3bgIKo=
X-Google-Smtp-Source: APXvYqxrwYWlgdaQeBMp+ljjwiAlV4eVdD+SE5MefsMILZDPoawLtjMFwoNlCkitGwRaPuvwwS7jSO1gQPV7ry1NmLQ=
X-Received: by 2002:a17:906:6410:: with SMTP id d16mr24602660ejm.75.1557236975656;
 Tue, 07 May 2019 06:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <1557177887-30446-1-git-send-email-ynezz@true.cz> <1557177887-30446-3-git-send-email-ynezz@true.cz>
In-Reply-To: <1557177887-30446-3-git-send-email-ynezz@true.cz>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 7 May 2019 16:49:24 +0300
Message-ID: <CA+h21hqZnr1C5W6qMQMictdSROZvmggjXoYhX+=biEoT4Fs0jQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/4] net: dsa: support of_get_mac_address new
 ERR_PTR error
To:     =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 May 2019 at 00:26, Petr =C5=A0tetiar <ynezz@true.cz> wrote:
>
> There was NVMEM support added to of_get_mac_address, so it could now
> return ERR_PTR encoded error values, so we need to adjust all current
> users of of_get_mac_address to this new fact.
>
> While at it, remove superfluous is_valid_ether_addr as the MAC address
> returned from of_get_mac_address is always valid and checked by
> is_valid_ether_addr anyway.
>
> Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> Signed-off-by: Petr =C5=A0tetiar <ynezz@true.cz>
> ---
>  net/dsa/slave.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 316bce9..fe7b6a6 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1418,7 +1418,7 @@ int dsa_slave_create(struct dsa_port *port)
>                                 NETIF_F_HW_VLAN_CTAG_FILTER;
>         slave_dev->hw_features |=3D NETIF_F_HW_TC;
>         slave_dev->ethtool_ops =3D &dsa_slave_ethtool_ops;
> -       if (port->mac && is_valid_ether_addr(port->mac))
> +       if (!IS_ERR_OR_NULL(port->mac))
>                 ether_addr_copy(slave_dev->dev_addr, port->mac);
>         else
>                 eth_hw_addr_inherit(slave_dev, master);
> --
> 1.9.1
>

Tested-by: Vladimir Oltean <olteanv@gmail.com>
