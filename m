Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02048295F
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 06:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiABFil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 00:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiABFik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 00:38:40 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26865C061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 21:38:39 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id p13so32104389lfh.13
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 21:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NKM5pDpKGo5CtAH2kaYK05iHThvnh/g8xXIKQdgPzT4=;
        b=Jaa78xZz4Ef1rWk+5+c+lsETsvvfUKfaFf2NdHyTLKUbozrIHly0Eb9oAX2cbexbA6
         JfqMuVuwGZ7a2wmeOJkQUblcPzxM4WjQxcztd2DRYI5dsNnvbK1fAsK1Osvniu0eptPf
         jX+lqvjCrkef75juC+FtShWUq8RsfAI/eiChjMHu8God82rZ5elKzIuJ5Pcx7hjdR9/G
         Szd3hPGvTv6CVGJnnMejGdd5GAB2UuxdVLgTaJHCvuCEjUOJgbdMImQrFFLjPEUcC3dJ
         n8mS+18IpE93eTslSNobZIPTClvNekn6UV1EOKyZ28XCVO0dTYNVzfMMJBnKlG7nXRf/
         ykrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NKM5pDpKGo5CtAH2kaYK05iHThvnh/g8xXIKQdgPzT4=;
        b=qNm4aimNvqYTWd4VoT/we9BIYGiLHdJqqVeh6Qus1ApsMueGGlzvpEWGu6TWBhe31R
         YkLma4kcAvhvaDA4b0va+MUE6PNxZ0Es2CaxvXwAMcqu1FlTFTE2Xv9VgDH2/Vtdqqev
         abZwTPtKmUbux/LXIbA5QO0NmoZlgAMatgOScB5XQbHRHjE4yUgDteQjeCBRiaMT90zx
         1m6X8amVAhbLyls60NatZQrC6Lt3WOVrItwERDNTvEzrB4U0taNjQOh/c3BGopo09AHH
         PYJddSVKiEkdOgh0tDxOvfPncqxtdroemtH6TktH3seoQhhIuarQHC3xMFOtzEoyFaCp
         QhGA==
X-Gm-Message-State: AOAM533CR/VjliPB3UXlGLhqehJm01wAm/xDWXOiEdsA4C2VFSQBycXC
        KkzErRES31mlWZe/7xm4vmTVZwQbjgBKYC+BLQdsrw==
X-Google-Smtp-Source: ABdhPJwScD+cSe/FoT2vC+ARQMc7NMM24G1QSYXN5N9jDj/84sI63A0trDPqp1K62en32Eo/3RO6hb6S+ag/FDiF8VA=
X-Received: by 2002:a05:6512:750:: with SMTP id c16mr37581258lfs.622.1641101917347;
 Sat, 01 Jan 2022 21:38:37 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-8-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-8-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 06:38:25 +0100
Message-ID: <CACRpkdbyFr-ZQuKOtx4+RRRBddmPGGUTY0j2VvT_7KxRBEQzNQ@mail.gmail.com>
Subject: Re: [PATCH 07/34] brcmfmac: pcie: Read Apple OTP information
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

On Sun, Dec 26, 2021 at 4:37 PM Hector Martin <marcan@marcan.st> wrote:

> On Apple platforms, the One Time Programmable ROM in the Broadcom chips
> contains information about the specific board design (module, vendor,
> version) that is required to select the correct NVRAM file. Parse this
> OTP ROM and extract the required strings.
>
> Note that the user OTP offset/size is per-chip. This patch does not add
> any chips yet.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Overall looks fine!

> +       const char *chip_params;
> +       const char *module_params;

This variable name "module_params" is a bit confusing since loadable
kernel modules have params...

Can we think of another name and just put a comment that this
refers to the WiFi module building block?

Sometimes people talk about SoM:s (system-on-modules), so
maybe som_params or brcm_som_params?

Yours,
Linus Walleij
