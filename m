Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56B128BDD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbfEWUul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731462AbfEWUul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 16:50:41 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0BAF217D9;
        Thu, 23 May 2019 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558644640;
        bh=v6PSwAorcPKsWe7jiuNmsouiSwC/iTj+RqZEfhl5wTU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SMBTwyvzSt1F5ozWUbD29AFuSoG5yodL9g9xTOgk7k4KHvabNSSSBZvOlcJvlCt0d
         cYISszwzLapIGXwrHlVJbIl9Fvy3QPG6bhkPqkiiPTne0Wr4tMv+JEzPLo5Q4g9QVz
         aoyz81UXWQSQ5YnefxbKRw75NgYq9Vr7WYCsYzpQ=
Received: by mail-qt1-f173.google.com with SMTP id h1so8483611qtp.1;
        Thu, 23 May 2019 13:50:39 -0700 (PDT)
X-Gm-Message-State: APjAAAUCzWeKN7DQ9eZ8ppS3MRvjSxVha8IeCQSWWQSYh0m2BbNwiAQl
        ZDh+lGXZhDllJy7yKTlEBT59i2j+aeUmRERjUg==
X-Google-Smtp-Source: APXvYqyk2vyztm4zwYJzGtYVs0A1UsF2AgpBVYwW7kI4E/hcqrA3rdHk74Zzd/2PUeAN58XxIUsRMSc9Om4BskeB+nQ=
X-Received: by 2002:a0c:929a:: with SMTP id b26mr79051384qvb.148.1558644639198;
 Thu, 23 May 2019 13:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com> <1558611952-13295-2-git-send-email-yash.shah@sifive.com>
In-Reply-To: <1558611952-13295-2-git-send-email-yash.shah@sifive.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 23 May 2019 15:50:27 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+p5PnTDgxuh9_Aw1RvTk4aTYjKxyMq7DPczLzQVv8_ew@mail.gmail.com>
Message-ID: <CAL_Jsq+p5PnTDgxuh9_Aw1RvTk4aTYjKxyMq7DPczLzQVv8_ew@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/macb: bindings doc: add sifive fu540-c000 binding
To:     Yash Shah <yash.shah@sifive.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 6:46 AM Yash Shah <yash.shah@sifive.com> wrote:
>
> Add the compatibility string documentation for SiFive FU540-C0000
> interface.
> On the FU540, this driver also needs to read and write registers in a
> management IP block that monitors or drives boundary signals for the
> GEMGXL IP block that are not directly mapped to GEMGXL registers.
> Therefore, add additional range to "reg" property for SiFive GEMGXL
> management IP registers.
>
> Signed-off-by: Yash Shah <yash.shah@sifive.com>
> ---
>  Documentation/devicetree/bindings/net/macb.txt | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> index 9c5e944..91a2a66 100644
> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -4,6 +4,7 @@ Required properties:
>  - compatible: Should be "cdns,[<chip>-]{macb|gem}"
>    Use "cdns,at91rm9200-emac" Atmel at91rm9200 SoC.
>    Use "cdns,at91sam9260-macb" for Atmel at91sam9 SoCs.
> +  Use "cdns,fu540-macb" for SiFive FU540-C000 SoC.

This pattern that Atmel started isn't really correct. The vendor
prefix here should be sifive. 'cdns' would be appropriate for a
fallback.

>    Use "cdns,sam9x60-macb" for Microchip sam9x60 SoC.
>    Use "cdns,np4-macb" for NP4 SoC devices.
>    Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
> @@ -17,6 +18,8 @@ Required properties:
>    Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
>    Or the generic form: "cdns,emac".
>  - reg: Address and length of the register set for the device
> +       For "cdns,fu540-macb", second range is required to specify the
> +       address and length of the registers for GEMGXL Management block.
>  - interrupts: Should contain macb interrupt
>  - phy-mode: See ethernet.txt file in the same directory.
>  - clock-names: Tuple listing input clock names.
> --
> 1.9.1
>
