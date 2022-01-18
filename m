Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873AA4923F5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 11:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiARKo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 05:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiARKoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 05:44:24 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D089C061574;
        Tue, 18 Jan 2022 02:44:23 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z22so77500782edd.12;
        Tue, 18 Jan 2022 02:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CtzkMdSfCrnyPh2rB+DJtTILLwpvztUqax7V+OFUjMA=;
        b=K01WJVgQUzeZ6CKQbjF+nfrEi+ppClBCVh8nFFlmgCEDOj9R5QixMRO4/W1GhXT1Y+
         T025UDlZ+nepMZvwthUhn2ZOKcaER3u3V/Qt5Mt/kuzdWNTPq/67+oWp6lpj57JGe2fc
         qYZC9ay1ucoiPEfM8OpG5V2ecPys5Dj8meQuQFFw/65m5zPAWMEpHBrO5TqHKv3cgcox
         4Orr0DPD3n6CpBuJTafuhrECW893B/vYh7CS4GPafgB+Qz/gsInYxVw3ymlVPKt9E5t+
         ukpl48IJ0snAQdsJZ+Lfvu8W6sT8rO40tJQeAr2rrZGG/8xPnyrEP8m7jKweaI+n3Q5G
         hFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CtzkMdSfCrnyPh2rB+DJtTILLwpvztUqax7V+OFUjMA=;
        b=FXP67FqX5/m6G4gJ5bwvVsF11TUU6EBru1yNQ7aDWRj/mEpFnEJ8BAtrLu5HTZnJOP
         ZMfT9dolyGWyyozEcme32aa1E5m4wU1uCR3f/jVHpSgMoklyh6UTeHZmAhJbAMNco2OR
         2tfUYy+SVKoWk/kRmVjXMSYlNGRc6gti5TDfkEPBaAbwZJa8VgVN3zXMr57OcTdwJ1M7
         wDWFpjOkzLQ5NvIfp+2NdxOF+wKei2tGIkVKSlCf6AI6E8W/DGGB9UpOG4QsrmOu00j1
         gaZQi1wgCYpdP7WucVGiG1LgDjIWyjtk4hz3AcLJG5L7ZRuRRrggrQ1//QCYn+ab432y
         4NxQ==
X-Gm-Message-State: AOAM531ATB8wZJ0h/rEsf1nMnFBI15siJ9da7UpSbSs+4mjRZXXgRX+N
        EWQ+70crr0NrvyAmVvAteS4AAvNkcH5XXgQQppA=
X-Google-Smtp-Source: ABdhPJxgeM7o9nefOzSERVjljBgpf3R+t3ROjDf67G1rnP6X6BwJ1AEpf47/feUY2V3H93HBfSBtqRxRgX9m5Dq+68w=
X-Received: by 2002:a05:6402:35d3:: with SMTP id z19mr10055100edc.29.1642502662119;
 Tue, 18 Jan 2022 02:44:22 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st>
In-Reply-To: <20220117142919.207370-1-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 18 Jan 2022 12:43:45 +0200
Message-ID: <CAHp75VfRiFokdTQ9cnEEH596mM7cb4FXQk4eXVt37cG4FcFMyA@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] misc brcmfmac fixes (M1/T2 series spin-off)
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
>
> Hi everyone,
>
> This series contains just the fixes / misc improvements from the
> previously submitted series:
>
> brcmfmac: Support Apple T2 and M1 platforms
>
> Patches 8-9 aren't strictly bugfixes but rather just general
> improvements; they can be safely skipped, although patch 8 will be a
> dependency of the subsequent series to avoid a compile warning.

Have I given you a tag? If so, I do not see it applied in the patches...

> Hector Martin (9):
>   brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
>   brcmfmac: firmware: Allocate space for default boardrev in nvram
>   brcmfmac: firmware: Do not crash on a NULL board_type
>   brcmfmac: pcie: Declare missing firmware files in pcie.c
>   brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
>   brcmfmac: pcie: Fix crashes due to early IRQs
>   brcmfmac: of: Use devm_kstrdup for board_type & check for errors
>   brcmfmac: fwil: Constify iovar name arguments
>   brcmfmac: pcie: Read the console on init and shutdown
>
>  .../broadcom/brcm80211/brcmfmac/firmware.c    |  5 ++
>  .../broadcom/brcm80211/brcmfmac/fwil.c        | 34 ++++----
>  .../broadcom/brcm80211/brcmfmac/fwil.h        | 28 +++----
>  .../wireless/broadcom/brcm80211/brcmfmac/of.c |  8 +-
>  .../broadcom/brcm80211/brcmfmac/pcie.c        | 77 ++++++++-----------
>  .../broadcom/brcm80211/brcmfmac/sdio.c        |  1 -
>  6 files changed, 72 insertions(+), 81 deletions(-)
>
> --
> 2.33.0
>


--
With Best Regards,
Andy Shevchenko
