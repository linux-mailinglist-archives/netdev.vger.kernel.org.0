Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158794829D5
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiABGAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiABGAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:00:52 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CF0C06173F
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:00:52 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bp20so68493220lfb.6
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTLmkAGe0nMUNWPjMKpLbDUGkN7ojNy65opvZtoCGow=;
        b=ngXXgI5MFCua4XE6UIuvOL3zYQCZkNeU6n0Khg3UpYyr3l07WCX0OrVf4nSBfQeEbq
         alRr1JnZ3PvXvKSeNKXQboDjsFpBF8CGwnT0a2KA1dWftbkA9oU/CB2gJIdOV2xbuqz5
         Zfj/reC5Hu+RzVnaphUVbKDvy9Bk9J8R0DTJZPuEYB/7fNiZmCyOJwHIHmulsQnGt47j
         qoGpu4AeEmvW/zi77f+SQnYyOjkH/NnFGRmtH9LTYCIOtDGvoU/Lei32PPFZvC7iteGl
         k7/2fp4iU7etc8itLW19f/8h/5/9OvOupfCfEhDTnUI+zu9WUF/LKZlsTck5AWcbhWe5
         h5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTLmkAGe0nMUNWPjMKpLbDUGkN7ojNy65opvZtoCGow=;
        b=LtAz5Ai3T/bHz4qKUOqb6HVe71X2oKuCyqUWWyWxPcIu5YgMO8joWefyswxWM1ApYV
         xRROih8mQ0TVS2bVPSHBZWLf/NNK9297NbnRLqwleMPGUmXVlKg6TdUb11KabFxQh/U6
         KDRgHfex9WHgvIsHc9GRs/CzQ4Ebru3xkTx/WNqlIyDkNmbQ7lDO+uL8vIH/4BV4LjJU
         x7espjOCiWYvAKBfEH/0Fo3PCK0QnJVxD7Uo3EpuGf2aCRh0fp25FokK23ZYMqiusmFb
         joni/yOGjLkP/psql2oY0hKOTf6nUtXF3/mEfSmEesDecChlfJ3Pbs+CJsS42Xplm5GY
         aZCg==
X-Gm-Message-State: AOAM531eWUtM2AbT13o2wV+0Y1XOxIaDuQYUnb2VUL+YEo9Vs94nMZrP
        2SAx3g5X5GePkdebhM3oC/rP6tjSVnVEhy62LzZZuA==
X-Google-Smtp-Source: ABdhPJycF0PZrYIBhbNaYzZXJsO4SuCYCZ+KgaA+cK/5b51H/hols6a1ZdcsP/UHLOD7kBzjTTaIwnvv1hnAoxJDvUM=
X-Received: by 2002:a05:6512:39ce:: with SMTP id k14mr19035581lfu.508.1641103250662;
 Sat, 01 Jan 2022 22:00:50 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-19-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-19-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:00:38 +0100
Message-ID: <CACRpkdZ1gRO+qyEPmKMVdMcLuOdekEMye5_4gLQCdFDF8f=r0g@mail.gmail.com>
Subject: Re: [PATCH 18/34] brcmfmac: pcie: Add IDs/properties for BCM4355
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

On Sun, Dec 26, 2021 at 4:39 PM Hector Martin <marcan@marcan.st> wrote:

> This chip is present on at least these Apple T2 Macs:
>
> * hawaii: MacBook Air 13" (Late 2018)
> * hawaii: MacBook Air 13" (True Tone, 2019)
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
