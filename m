Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF94840DF
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiADLah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiADLah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:30:37 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E829C061761;
        Tue,  4 Jan 2022 03:30:36 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q14so139440733edi.3;
        Tue, 04 Jan 2022 03:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0yty/Vql/ha5wH7OZotX+MYGyccXlZrjOYzGRLc8osI=;
        b=Ob1v2V/1KmrPCwBo+PVBUCo0h9Yl9nquFidnZ8qBujjcJn1jOUUljpHnQMqCS7tPci
         HLE7SFA0YHB334q34rR9tA8qGWWO4Ln2svhzpOTrj20UxtANmtpCZwCbZQ5UhvXQQC9E
         Ve98gHi3SaDehDkyPzU5f88IztLdsJgRrbHNvKbXU1V1pzJV4OHgbOFmUG9H04JqpxlW
         1aVJ1SxwLbAkxqS4REP4JvObUEJw1uppLw1yJnz4LMLzKPGx0OC+OugT4oNW4R/uvgw1
         N2RfLJ7hUflX7cmDAffiCRRY+vkvO9OF0tD1Iv83TBSk/9a0j4XubYzDuvlW+qfak3pp
         0AhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0yty/Vql/ha5wH7OZotX+MYGyccXlZrjOYzGRLc8osI=;
        b=z900lw44t4Kt7PtqiyLHo5IHVL9je4y60XXOK9BjlcUfK5rZ4/12Na+6aJWt6n/Qih
         tkpoGmQjrxpgbIL4MdBMRQZB5zsYJUlAZTzv98+3XYCOw6ua8jTiuc0HAxdHqAtwL9nP
         eQMR41IaoIeFJ6M2U/0kxcc+NXiDUMusyKJ51JDgnHMqUUvraAX5wF44vpKQSSGHr9hD
         clvtDUYBAUVHHXo7TMopuWKS2DYjl621/I9bNeugFjkNYRydNxb1ojTmlcS3mhkJ42Ux
         6s9fn+UbaT2dzmzh0kg75m/ZBEPcn8M+9fYaKxtvWTYRaV2/G50b3Zw/vXqEvRK/v4uD
         ekZg==
X-Gm-Message-State: AOAM5313Zrx+jeXDuaT5H63MaKQBJ0f8LJgUsqD3VixaFWzOWWk6P3U8
        g0fBHFlmGEQf13t2ABaDCrSNBWSpYsGwyYx5vTY=
X-Google-Smtp-Source: ABdhPJzstuNjGXH7i4SJZO7W6jJ03BLb3g5gKSn1e6dIAouguCI/zvBRkWCkEcva7qTCxiSiFsVGFOqOCRh/YPwjBtU=
X-Received: by 2002:a17:906:3ed0:: with SMTP id d16mr38212898ejj.636.1641295835170;
 Tue, 04 Jan 2022 03:30:35 -0800 (PST)
MIME-Version: 1.0
References: <20220104072658.69756-1-marcan@marcan.st> <20220104072658.69756-7-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-7-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Jan 2022 13:28:44 +0200
Message-ID: <CAHp75VcXgVTZhPiPmbpAJr21xUopRXU6yi=wvyzs6ByR8C+rzw@mail.gmail.com>
Subject: Re: [PATCH v2 06/35] brcmfmac: firmware: Support passing in multiple board_types
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
> In order to make use of the multiple alt_path functionality, change
> board_type to an array. Bus drivers can pass in a NULL-terminated list
> of board type strings to try for the firmware fetch.

> +               /* strip extension at the end */
> +               strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
> +               alt_path[suffix - path] = 0;
>
> -       alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
> +               strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
> +               strlcat(alt_path, board_types[i], BRCMF_FW_NAME_LEN);
> +               strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
> +
> +               alt_paths[i] = kstrdup(alt_path, GFP_KERNEL);
> +               brcmf_dbg(TRACE, "FW alt path: %s\n", alt_paths[i]);

Consider replacing these string manipulations with kasprintf().

-- 
With Best Regards,
Andy Shevchenko
