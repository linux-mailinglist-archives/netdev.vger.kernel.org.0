Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E6D6DA009
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 20:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240259AbjDFSk1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Apr 2023 14:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240269AbjDFSkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 14:40:21 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B319E9004;
        Thu,  6 Apr 2023 11:40:19 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id n21so3635257ejz.4;
        Thu, 06 Apr 2023 11:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680806418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/vRP03cMBwPFFIUCdAcydaIAi3iMXexWFOT2Es7xP4=;
        b=bhbfocKb8mLoFnQdo74RoKfdGZ3ROqWgotKj9SfRaO9P6y61Irej53CDQRX0hNPri7
         MKSwki1240ReGL6GPN+d+sShlopUgP0g+fYbASj/FypVXfobh4r5wXN41/jezZapWtyN
         qeUnu7/Rg8RdRovt5szvTQwIN16ROmPR19MWmrRXTWnAOW9rfp/45jwl4VxcA2lwmXzJ
         /o30oHCRazzVhfjNEJ1ji+IcWY53EGf1g5llRX0ldWMTSCsXDVSeHWgPkWnLJL+JqHxP
         Y9JLpVgA3Qr5uyqB1S8xoR7J2KAnjytq+sc/e5h7CEqghsbnoegG0JP4J8XmLzwxots5
         w+CA==
X-Gm-Message-State: AAQBX9fTWGgnLukcYTI9FQ2CsAqwqbX+xV8OdvYHtU2d1nXkBYaA9qL5
        2Mwcu4Y9FkgXTzxASzpBjoIo+d/Qre9gUX22J+A=
X-Google-Smtp-Source: AKy350bccWL6lt0+zXbInPBQWvnVq/LZTLhcL/dc5uLFWGZYlhaLZYqBvMQBJhuHAdHL0grMZu37PeKYaqj61CBd4QU=
X-Received: by 2002:a17:907:8c18:b0:93e:c1ab:ae67 with SMTP id
 ta24-20020a1709078c1800b0093ec1abae67mr3885095ejc.2.1680806417910; Thu, 06
 Apr 2023 11:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
In-Reply-To: <20230329-acpi-header-cleanup-v2-0-c902e581923b@kernel.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 6 Apr 2023 20:40:05 +0200
Message-ID: <CAJZ5v0j+DP=PB8thzFPMPQgTATGdo9ZA70Q6heUy=OLo3aU96g@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Remove acpi.h implicit include of of.h
To:     Rob Herring <robh@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 10:27 PM Rob Herring <robh@kernel.org> wrote:
>
> In the process of cleaning up DT includes, I found that some drivers
> using DT functions could build without any explicit DT include. I traced
> the include to be coming from acpi.h via irqdomain.h.
>
> I was pleasantly surprised that there were not 100s or even 10s of
> warnings when breaking the include chain. So here's the resulting
> series.
>
> I'd suggest Rafael take the whole series. Alternatively,the fixes can be
> applied in 6.4 and then the last patch either after rc1 or the
> following cycle.
>
> Compile tested on x86 and powerpc allmodconfig and arm64 allmodconfig
> minus CONFIG_ACPI.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Changes in v2:
> - More explicit include fixes reported by Stephen
> - Link to v1: https://lore.kernel.org/r/20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org
>
> ---
> Rob Herring (10):
>       iio: adc: ad7292: Add explicit include for of.h
>       staging: iio: resolver: ad2s1210: Add explicit include for of.h
>       net: rfkill-gpio: Add explicit include for of.h
>       serial: 8250_tegra: Add explicit include for of.h
>       ata: pata_macio: Add explicit include of irqdomain.h
>       pata: ixp4xx: Add explicit include for of.h
>       virtio-mmio: Add explicit include for of.h
>       tpm: atmel: Add explicit include for of.h
>       fpga: lattice-sysconfig-spi: Add explicit include for of.h
>       ACPI: Replace irqdomain.h include with struct declarations
>
>  drivers/ata/pata_ixp4xx_cf.c            | 1 +
>  drivers/ata/pata_macio.c                | 1 +
>  drivers/char/tpm/tpm_atmel.h            | 2 +-
>  drivers/fpga/lattice-sysconfig-spi.c    | 1 +
>  drivers/iio/adc/ad7292.c                | 1 +
>  drivers/staging/iio/resolver/ad2s1210.c | 1 +
>  drivers/tty/serial/8250/8250_tegra.c    | 1 +
>  drivers/virtio/virtio_mmio.c            | 1 +
>  include/linux/acpi.h                    | 6 ++++--
>  net/rfkill/rfkill-gpio.c                | 1 +
>  10 files changed, 13 insertions(+), 3 deletions(-)
> ---
> base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
> change-id: 20230329-acpi-header-cleanup-665331828436

All applied as 6.4 material, thanks!
