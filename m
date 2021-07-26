Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309EF3D6A57
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 01:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhGZXAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233380AbhGZXAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 19:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F28D160F57;
        Mon, 26 Jul 2021 23:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627342866;
        bh=O2DOkFguLOzbkRMBlRMe9+ZIyVUzgb8Ks6KfZYIDdXg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GtKT+xw8BCZEhovnqvYLN7t98UKbutd+hWDl4jnQRzHFGx5abYomgWhEEcDeVNRhX
         9FMcaZkNP+9FAcyu/mQLQC7xze7ImLs4vSOdj6GCnd4O3naSRzHb0cUJgOm+bj8fXt
         XMFzKUM8VVYPLIxuk6gt5j9cdEHWwrDhyAxKNgVX9NrBO1wrG0uvvcxnB2HJHdq3er
         acPw33Gmhfq2EaMz5vhfbjPFImFUAIB9vbQPhFWdq39oSAAn04vauthKZ2aKR6zvzG
         E9+sG2WKbyT6WSdkmgXRFWlgIVFDOWxicXgbSoIvANkGMg85VgtjTbmyXdwuJwov4L
         /waoDtuzwKrpQ==
Received: by mail-qv1-f51.google.com with SMTP id o61so3469763qvo.1;
        Mon, 26 Jul 2021 16:41:05 -0700 (PDT)
X-Gm-Message-State: AOAM53393D/pQKhbU9RJxwGwavVZZ/5l1f+FrZ0rCVeZyRKusbsf/cSU
        9eu1/eXoqUpWQEtWft2YtXnSuEwXbilA0ki/qQ==
X-Google-Smtp-Source: ABdhPJxsp8IiFMS+P31AWhMdCwOFSuNCqllrr++DsdbsmvlQucLpm72k+y0E/mJh5Zl0B6EsOelOkX6dFmk0XQ7IEXk=
X-Received: by 2002:ad4:4ba7:: with SMTP id i7mr6364657qvw.57.1627342865177;
 Mon, 26 Jul 2021 16:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com> <20210726194603.14671-6-gerhard@engleder-embedded.com>
In-Reply-To: <20210726194603.14671-6-gerhard@engleder-embedded.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 26 Jul 2021 17:40:54 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
Message-ID: <CAL_JsqJC19OsTCa6T98m8bOJ3Z4jUbaVO13MwZFK78XPSpoWBg@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN endpoint
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 1:46 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> Combination of Xilinx ZCU104 with Avnet AES-FMC-NETW1-G and TSN endpoint
> Ethernet MAC implemented in FPGA.
>
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  arch/arm64/boot/dts/xilinx/Makefile         |  1 +
>  arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts | 50 +++++++++++++++++++++
>  2 files changed, 51 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts
>
> diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/xilinx/Makefile
> index 11fb4fd3ebd4..d0f94ba8ebac 100644
> --- a/arch/arm64/boot/dts/xilinx/Makefile
> +++ b/arch/arm64/boot/dts/xilinx/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  dtb-$(CONFIG_ARCH_ZYNQMP) += avnet-ultra96-rev1.dtb
> +dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-tsnep.dtb
>  dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zc1232-revA.dtb
>  dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zc1254-revA.dtb
>  dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zc1275-revA.dtb
> diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts b/arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts
> new file mode 100644
> index 000000000000..19e78b483f44
> --- /dev/null
> +++ b/arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-2-Clause)
> +/*
> + * TSN endpoint on Xilinx ZCU104 with Avnet AES-FMC-NETW1-G
> + *
> + * Copyright (C) 2021 Gerhard Engleder <engleder.gerhard@gmail.com>
> + */
> +
> +/dts-v1/;
> +
> +#include "zynqmp-zcu104-revC.dts"
> +
> +/ {
> +       model = "TSN endpoint";
> +       compatible = "engleder,zynqmp-tsnep", "xlnx,zynqmp-zcu104-revC",
> +                    "xlnx,zynqmp-zcu104", "xlnx,zynqmp";

I don't think this will pass schema validation.

In general, do we need a new top-level compatible for every possible
FPGA image? Shouldn't this be an overlay?

Rob
