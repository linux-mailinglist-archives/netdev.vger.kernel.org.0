Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E214840AA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiADLTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiADLTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:19:09 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AACCC061761;
        Tue,  4 Jan 2022 03:19:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q14so139322036edi.3;
        Tue, 04 Jan 2022 03:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lTvvZvpgX/vMIJJvqels0YTYJ/RzgUp78mB3uAv5t48=;
        b=guqAN97V1EFMOLp5JRip/DLcahRtsUID8oiL7la/5kcSYwWnJbX4NwC8VVkAAZpkLV
         RpdzSbAFaTH92n3f02GlLe57NS50744mmcpsU41IiLca3joB/G5Klz53cQUjYW+3MhSj
         k5OkMQxepoZh2XDsHIlR74xE3t7agQQPxC6nm8JLuLI32TTA+OaV2WapLeo38+olWTFO
         FV/dIFxYXZ+rjX6U97yLwnV8ZBSx0n/qJ+MDhjf6/Xxk1Kjqq7Zl6AqoyZLYBSCD3jjL
         L4q5jW+x/+6yJMaHQLxZCR5wKadZ1ivA1TZudZ5Nw2ucE8FCtYt5bxVIHK6p8c4cFFy1
         ZeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lTvvZvpgX/vMIJJvqels0YTYJ/RzgUp78mB3uAv5t48=;
        b=BsUVlONA81a4BEXmd8G+ETJjqikHHsZC5blCq6qd4hMR9Lz5KUpEQ8znNNRYUNIAQT
         lKBvhphsXvkcgxDzvoWvHrPNhmfHuA7hsSN3AuT1ngRPydSgI1GMBqNPLfAwAczmmSEt
         BPGZyox68W7g5kTesCw1KrAlfOr6Z4GCqMZPp9rWlRsXkVUDwvKQUylWuYax/nTzzJWY
         Tcoe0ME/oRSH24r3YBANiRSVkv9jCqPNWnKs4Eky1Nl4xwfgh2srexwdQLCjSYqNfJhV
         rG/THVDML5+kBU3BQVAWBLlKSYkCiWOeSJJESDYaEh+5PCI8ZvjK+v+nHOQ6sPUlPN+B
         5apQ==
X-Gm-Message-State: AOAM532xborQLwELhBnVWWlSilD3r+5AIPA3e8t9eZkUs6JplakSy0TH
        /hr7OZw5LiGJv8SES4wJw0J5Qfw5nkRC+pzzI7s=
X-Google-Smtp-Source: ABdhPJy+flb1KMKQX3i7pLtxvOmocpRTp1HRyAjw+R78xUAB+Gs3HcHq38H402Nh2lWxXaNpSko1AXe5ewxEpyl57Wg=
X-Received: by 2002:a05:6402:795:: with SMTP id d21mr13341722edy.270.1641295148030;
 Tue, 04 Jan 2022 03:19:08 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-9-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-9-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Jan 2022 13:17:17 +0200
Message-ID: <CAHp75Ve4N7qOtMhvwGWmQ7VF9guYP6YuvFvBqDY_aXbiCsO0vA@mail.gmail.com>
Subject: Re: [PATCH v2 08/35] brcmfmac: of: Fetch Apple properties
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

On Tue, Jan 4, 2022 at 9:28 AM Hector Martin <marcan@marcan.st> wrote:
>
> On Apple ARM64 platforms, firmware selection requires two properties
> that come from system firmware: the module-instance (aka "island", a
> codename representing a given hardware platform) and the antenna-sku.
> We map Apple's module codenames to board_types in the form
> "apple,<module-instance>".
>
> The mapped board_type is added to the DTS file in that form, while the
> antenna-sku is forwarded by our bootloader from the Apple Device Tree
> into the FDT. Grab them from the DT so firmware selection can use
> them.

> +       /* Apple ARM64 platforms have their own idea of board type, passed in
> +        * via the device tree. They also have an antenna SKU parameter
> +        */
> +       if (!of_property_read_string(np, "brcm,board-type", &prop))
> +               settings->board_type = devm_kstrdup(dev, prop, GFP_KERNEL);
> +
> +       if (!of_property_read_string(np, "apple,antenna-sku", &prop))
> +               settings->antenna_sku = devm_kstrdup(dev, prop, GFP_KERNEL);

No error checks?
But hold on, why do you need to copy them? Are you expecting this to be in DTO?

-- 
With Best Regards,
Andy Shevchenko
