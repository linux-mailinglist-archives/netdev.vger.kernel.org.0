Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857381AD849
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgDQIIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:08:46 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:48637 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729176AbgDQIIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 04:08:46 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MZCrZ-1jkzgQ3QCv-00V5Py; Fri, 17 Apr 2020 10:08:44 +0200
Received: by mail-qt1-f175.google.com with SMTP id q17so1305269qtp.4;
        Fri, 17 Apr 2020 01:08:43 -0700 (PDT)
X-Gm-Message-State: AGi0PuZPHLJ0ETGwYzc0w53ajd7TmC5191V2wY8CPG5IpuuvuYpJ8AaC
        UG55exHovexaevi31J/2Lb14TO2ls08BHLu52xs=
X-Google-Smtp-Source: APiQypLUoNDOKFwGPWYoRRmEiZI8rctsda5AneTsk6fjIsb3FT/qvUaisaRkSlwxmoYxvPE3/5JVy2siN1PfRxaCOmc=
X-Received: by 2002:aed:20e3:: with SMTP id 90mr1721476qtb.142.1587110922393;
 Fri, 17 Apr 2020 01:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200417011146.83973-1-saeedm@mellanox.com> <20200417011146.83973-2-saeedm@mellanox.com>
In-Reply-To: <20200417011146.83973-2-saeedm@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 17 Apr 2020 10:08:26 +0200
X-Gmail-Original-Message-ID: <CAK8P3a22OtR5x01iNaSpJ3kM0MBd+dJshKOe6Cp42zukme2A+A@mail.gmail.com>
Message-ID: <CAK8P3a22OtR5x01iNaSpJ3kM0MBd+dJshKOe6Cp42zukme2A+A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] net/mlx5: Kconfig: Use "uses" instead of "imply"
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:YpC9Ij1eNtvdD1DAdicFQKLiz2VsLhebBV++mgPKvmfb4tS0VGY
 rqOGEt1xfgecycpBfzED2WvluWYBfoPZe2OWbPNbAIdsGZ6ZdgpeJgxu6kgTD9yAhrUuuqs
 SpPmz+1uUSrabZF774kp5vTc8o628ykSybBXIDEzHcfoCzzHmjJUJO0g7VLNktUi5QEXIeR
 Er9sr9zQHBpzLSoyVumKw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kx+/Em1awjU=:1KQ2OTbdqmagGY2K4XVLQt
 /QadPC/sm2CLOphF+BLE06ltL8tLnP2BzAX3SSHthqj4/5KC6r4fVcItmrTR1Yt01DPzVHZc7
 x+zBUwk/8HmgpFTIdo5I4ZQAyWp0HYDPqC61uhBowKtvV3tdDNKwFXGr1GDKUwXK4tGAQ30qG
 YNgWZR5+tVb6KfWehhns+hNluZlNLoHZsWwSNkYCpuQFF8+MznVOl62EpvrIDUqUTUTFG6szr
 6fJJYTIoV5syYHK7ayokV2lXYsuEMTavczqcEDxxpnNyepkITHQVqId7XlUX901tamxfxEMfr
 boCuQ70/628d62Db+QwqcnTGJ8gsb/uuVJxC8cFaTDy2LVlmUiZfVN4sb9oUFFbeSUSuct6W3
 I6O27NuTXwCgXUDCNgcVw6WLMhnA8OVHwlVe91a55vALJIBiK0cQWjOL6/nh7uJ7S38FgYHZF
 u+rijcvxbolb0xLWoX5CewJ+xCpYTroUn+hsc2Ip+tRCsNjvZDXDzlih+8fOWtknZ2kC2GZrX
 ltj/d9L6TKtfODjk22VnYpVoGSdUaTnmend5LicVHKlFl1NvQu+Tx4E8P+6XqV1k06m4Xi4pl
 evkLjl+JcEZHbAxfEU7YGqsr9piLrHcEGzqE9XfAaWz3cUzoQA0lCbEgdVoI12TNiFha+qknj
 mGYRi3M1f7x2E1xIZVwEF+ylscG6jzXTGMQTlytZ5OsIDgYAtGjHJPTiZKatIPxrdGUEQ3zQt
 UBP6NUHPJtbsOvJftTnrwEDAgLSJ9ROyjAYyarreQbl8VO0KOvgT4pVrYviPQVhuHhg7rI6n0
 oXV4wVnIGCj9+aeFy6n0bAyt+CYvywwhobGkswSTvgqhyyxUZU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 3:12 AM Saeed Mahameed <saeedm@mellanox.com> wrote:

> @@ -7,10 +7,10 @@ config MLX5_CORE
>         tristate "Mellanox 5th generation network adapters (ConnectX series) core driver"
>         depends on PCI
>         select NET_DEVLINK
> -       imply PTP_1588_CLOCK
> -       imply VXLAN
> -       imply MLXFW
> -       imply PCI_HYPERV_INTERFACE
> +       uses PTP_1588_CLOCK
> +       uses VXLAN
> +       uses MLXFW
> +       uses PCI_HYPERV_INTERFACE

I have confirmed in the meantime that changing the PCI_HYPERV_INTERFACE
dependency is indeed required, in addition to PTP_1588_CLOCK and VXLAN
that the randconfig tests found earlier:

x86_64-linux-ld: drivers/net/ethernet/mellanox/mlx5/core/main.o: in
function `mlx5_unload':
main.c:(.text+0x325): undefined reference to `mlx5_hv_vhca_cleanup'

I also checked that there is no link failure with MLX5_CORE=y and MLXFW=m,
but only because of an IS_REACHABLE() check in mlxfw/mlxfw.h.
I suppose that should be changed back to IS_ENABLED() now along with
the Kconfig check.

      Arnd
