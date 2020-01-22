Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8109D145B99
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVSaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:30:13 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46325 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgAVSaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:30:12 -0500
Received: by mail-yb1-f195.google.com with SMTP id p129so264995ybc.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BU7KI4qm8tdTV6q5jnH25URF3g5S8/OylhVKqNjyu4Y=;
        b=AOHDBJC88hSmgu+ywPUvIBeBuHfLhBMiZj0/R1mxYBVq+RPrHgXPZzzkBppDwdriuY
         cLHbV2Rz+h4QeGNujcsR6271gWg6/5QkRUBYwAtg1V+1opy/iYpvYVslqGApusY2ObxW
         IACf2hdrX8cIcysJbs+Eewi/Qv6GNxIOSlafxVdd0NC7hszrnGNB4UPEpKFLVlRUSYlb
         kqj/JWr088SNewxsRLWkgXS1nSy8kTIenPdRVFyyV126SenVljbID1lM6McqSDHtcB7h
         4G2Hl6EBwv3jbMDQC5B4ToMK5VrHRA007C6u/d8w06xHL772mUUidG5+DTA/cuzxL5yK
         GFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BU7KI4qm8tdTV6q5jnH25URF3g5S8/OylhVKqNjyu4Y=;
        b=ioCv2B6C5QlOD96KQZYt2QT7I/cTpPr2c0GIM6WHUfsa/cJf2EmM8sNYOg4f5e/OSp
         F+N9mGfGgJke/NgdxWkGXNrH6NWO1kGeww8W+Itena5Y+xPDylbbnHd7pAoW4Q70gH5/
         QX41i/PVUAIjy47VvoT/EpO6sJoJ/8QhSq1IP4mc/ZXYyS94M/rGNuL6778aVLRvTj+/
         /0S9JC+vmuyf2yNd61U16j2Eb3+tajRj/U+Q2VPVtco8v/MMpH3j2g275z8vPz8EMsIT
         /506ayXxvnpmLhOXEC9pStnDFrs+2OQg9vjxV0oemlQUbF50FH/oSSx8ZV/w0lSDLtfL
         a5dQ==
X-Gm-Message-State: APjAAAVuG/8P2Gwhw1a1/XINMj20KKk09l/U5FMrR0A7Oi8+shFHmYxX
        I/uOZpSwNvRGsG/WL8Yly8S2Zu6P
X-Google-Smtp-Source: APXvYqy47e117njlg/hCvcO/H5dFOv3SAiVBznmPyMbJgcn3gCr0jm8NmAAjwik2XpJdX89AxkJUcQ==
X-Received: by 2002:a25:d343:: with SMTP id e64mr8906635ybf.257.1579717810152;
        Wed, 22 Jan 2020 10:30:10 -0800 (PST)
Received: from mail-yw1-f41.google.com (mail-yw1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id o126sm18779383ywb.24.2020.01.22.10.30.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 10:30:08 -0800 (PST)
Received: by mail-yw1-f41.google.com with SMTP id 192so252663ywy.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:30:08 -0800 (PST)
X-Received: by 2002:a0d:f481:: with SMTP id d123mr7799752ywf.411.1579717808122;
 Wed, 22 Jan 2020 10:30:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1579624762.git.martin.varghese@nokia.com> <d08b50ebd2f088b099fdaaaac2f9115d6e4dda5c.1579624762.git.martin.varghese@nokia.com>
In-Reply-To: <d08b50ebd2f088b099fdaaaac2f9115d6e4dda5c.1579624762.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 22 Jan 2020 13:29:32 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfK0OxM8X2_n5GJOrYOpaxX6EFm4KW5j+Lzf5QqFp3hSg@mail.gmail.com>
Message-ID: <CA+FuTSfK0OxM8X2_n5GJOrYOpaxX6EFm4KW5j+Lzf5QqFp3hSg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: UDP tunnel encapsulation module for
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 12:51 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The Bareudp tunnel module provides a generic L3 encapsulation
> tunnelling module for tunnelling different protocols like MPLS,
> IP,NSH etc inside a UDP tunnel.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

This addresses the main points I raised. A few small points below,
nothing serious. It could use more eye balls, but beyond those Acked
from me.

> ---
> Changes in v2:
>      - Fixed documentation errors.
>      - Converted documentation to rst format.
>      - Moved ip tunnel rt lookup code to a common location.
>      - Removed seperate v4 and v6 socket.
>      - Added call to skb_ensure_writable before updating ethernet header.
>      - Simplified bareudp_destroy_tunnels as deleting devices under a
>        namespace is taken care be the default pernet exit code.
>      - Fixed bareudp_change_mtu.
>
> Changes in v3:
>      - Re-sending the patch again.
>
> Changes in v4:
>      - Converted bareudp device to l3 device.

I didn't quite get this statement, but it encompasses the change to
ARPHRD_NONE and introduction of gro_cells, I guess?

>      - Removed redundant fields in bareudp device.

> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index d07d985..ea3d604 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -33,6 +33,7 @@ Contents:
>     tls
>     tls-offload
>     nfc
> +   bareudp

if respinning: this list is mostly alphabetically ordened, perhaps
insert before batman-adv

> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index dee7958..9726447 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -258,6 +258,19 @@ config GENEVE
>           To compile this driver as a module, choose M here: the module
>           will be called geneve.
>
> +config BAREUDP
> +       tristate "Bare UDP Encapsulation"
> +       depends on INET && NET_UDP_TUNNEL
> +       depends on IPV6 || !IPV6
> +       select NET_IP_TUNNEL
> +       select GRO_CELLS

Depends on NET_UDP_TUNNEL plus selects NET_IP_TUNNEL seems odd.

NET_UDP_TUNNEL itself selects NET_IP_TUNNEL, so perhaps just select
NET_UDP_TUNNEL.

I had to make that change to be able to get it in a .config after make
defconfig.


> +static int bareudp_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +       dev->mtu = new_mtu;
> +       return 0;
> +}

If your ndo_change_mtu does nothing special, it can just rely on the
assignment in __dev_set_mtu

> +/* Initialize the device structure. */
> +static void bareudp_setup(struct net_device *dev)
> +{
> +       dev->netdev_ops = &bareudp_netdev_ops;
> +       dev->needs_free_netdev = true;
> +       SET_NETDEV_DEVTYPE(dev, &bareudp_type);
> +       dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM;
> +       dev->features    |= NETIF_F_RXCSUM;
> +       dev->features    |= NETIF_F_GSO_SOFTWARE;
> +       dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
> +       dev->hw_features |= NETIF_F_GSO_SOFTWARE;
> +       dev->hard_header_len = 0;
> +       dev->addr_len = 0;
> +       dev->mtu = 1500;

ETH_DATA_LEN?
