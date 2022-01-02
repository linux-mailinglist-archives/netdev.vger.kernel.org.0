Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155AA4829C1
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 06:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiABFyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 00:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiABFyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 00:54:06 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DBCC061746
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 21:54:06 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id s4so33026145ljd.5
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 21:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5EyGPGRrzaSpBH7dUGkqyF9/f5p7cVq7+HA/jLDDM8I=;
        b=NNatE1smYg3/3sUUusjNfeQrxJfMermAT4Cr+qcdJB9VfFeSiT/RctY7FeEvuuY2QL
         WtBAheXYk3l0zQstb37L7uXeyWycmJTXV1jEQeCypgyZkMS5atDR0NDpXspOV7Uyhbbz
         hYIStWWr2kDbCZwX/MjNlKyb2jZNO5bCVahExgzESzpX7wOFam61Uk1+JOfIm5OcjPvk
         mc5Kt6iRCEp67/Zo3UqYyUoNe/N+DpLXZSnDc3Zdf9oH2S50L8r28a0ycsEqszI9Sge1
         swbTxRYIRa6ddQtuRe9q0ODrEIrSYqZ1vovoNnhRWvvnhSzp0bEaou45lJ4JBozMPnhF
         fBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5EyGPGRrzaSpBH7dUGkqyF9/f5p7cVq7+HA/jLDDM8I=;
        b=1Ov6piiAO8nElzGluiZUyfApnMZdFNUS7ScwTxPcz3ALHimGh/AFfG7GdndZ0Xue7E
         QdpLmZ/DaIRQY2Hm3XZeqLESwVVk+7NJGWKkJP/wbM2Ooa2XE068QlzsxXWGbJKod78f
         S61v2YoZBvCMNCZdhxfFES2TwoNiPm94h+uhZ9eN1HRKJniRlxUkp4hKgY7K+H3py7YV
         ZsZYD7J3euNhnVAK+GTvmasTFYubOoNgqefEPsODNnWlloD+6OfiD8N7ls4NMBLmsPI6
         YHGnW3EyVFp400scthLbMK1m2Ed7+JOVBnUlnwYhK5XG1Jb/ZgW4qwQsmjZe0Jn0Jpjc
         YrTA==
X-Gm-Message-State: AOAM531tuZBoCb+/Msgwnds0x3rnaJ1Y3h857E1vgHyXJKOc0AVWIj4j
        IRcGZdOVQt64fpb3QPEqf8jYv8WoA/GgRQg0BU3cnQ==
X-Google-Smtp-Source: ABdhPJzHrjb1kHLwofScAQ778QMmEbV+rQRrvFiwAD7abFYA7z7oKl1vryfquMnaBTp/+07y5iST4GnsAT4OT1vodL4=
X-Received: by 2002:a05:651c:1a1f:: with SMTP id by31mr26113708ljb.266.1641102844760;
 Sat, 01 Jan 2022 21:54:04 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-15-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-15-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 06:53:52 +0100
Message-ID: <CACRpkdZxKXMz9+PgsZCi4HEJMoM9XH1kYzGJZMrC4B_kK3zghw@mail.gmail.com>
Subject: Re: [PATCH 14/34] brcmfmac: pcie: Add IDs/properties for BCM4378
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
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 4:38 PM Hector Martin <marcan@marcan.st> wrote:

> This chip is present on Apple M1 (t8103) platforms:
>
> * atlantisb (apple,j274): Mac mini (M1, 2020)
> * honshu    (apple,j293): MacBook Pro (13-inch, M1, 2020)
> * shikoku   (apple,j313): MacBook Air (M1, 2020)
> * capri     (apple,j456): iMac (24-inch, 4x USB-C, M1, 2020)
> * santorini (apple,j457): iMac (24-inch, 2x USB-C, M1, 2020)
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
