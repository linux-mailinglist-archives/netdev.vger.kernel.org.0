Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8DE4829D9
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiABGBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiABGBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:01:38 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9549CC061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:01:37 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id j11so66686579lfg.3
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=++X+4IgLBv/570wWkxuv+d3gXkmfZziDfkCYW9h+SJs=;
        b=knBJo7GhK2Jk/F9CsVp2X6EbhmF36fhL3Ch9zTgeJWn1Qy/LzVwy4JJyXgWT2b6f34
         fbGzR2BPAh+MgNvWWWX/Iok78ZD1LQDE5V4M+uK/OuehMIb8hKWXE74T8o9RAmoScAi0
         tou+kA0D69AKOyV8UPnna68NTE0to+xqItixTEtGW7vCsAulOkEoFC2XjvAKWGOY5dU4
         1XLUs5ggyFU6Ub6rRRE1vTl4x9svgt0V0u1386If311tYtRluUwEqvR8sPVBKFPESCjn
         fDvVaZZSqTcFA/Kf4a48EkM0VAms2sPyAh6oKCr+Mt9TORj1pdOrbuY5anyr9dKgV42L
         WQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=++X+4IgLBv/570wWkxuv+d3gXkmfZziDfkCYW9h+SJs=;
        b=E/dFw/fryEuS0JxhyFKEfs2L8dIKf8QIDTG+wdPe5udDqJIw+WKlqjnp5dYIvm1ZXs
         RAl637yzBG+GZz3C73lbez+9TzsrBXLa2rbm99RV92NPUEByezYY8P9IXCKw4fbBikfK
         kqPOPtJNoRne+P8NmJs8clyzW12qBy3lLyTetczlQQN3xTXE2xKnnfUDgmRToayxIJFV
         J/QXnowtFQHVF8vR7XY+uDAWz0SSTueBfK8DheYx3hZuNfChXWokjS9TOufRFvqP+VdA
         a+7FZQalXb1fG10MYKBWmww8Maqs6bRUFr7nFPf54HfiAm3RVZYMFL57ZeS/k9W7q2ul
         YrvA==
X-Gm-Message-State: AOAM532X/ZeKtktl8jhEhoGyZid/VVSuq2fNKF97NQ6TKHyGBYAQCA17
        QtpceMuHDPl1zD/sdfDyEK5nhKCTPhwKVNCZ+ZPchg==
X-Google-Smtp-Source: ABdhPJwo+jQV37pSOSt4QRaSzrw1bPUZLyT95BP9G5ewHKlFXkn162F6G0jabBIo80rL7nWLCT5J51HbvqCKRuYML6E=
X-Received: by 2002:a05:6512:261f:: with SMTP id bt31mr20429087lfb.400.1641103295931;
 Sat, 01 Jan 2022 22:01:35 -0800 (PST)
MIME-Version: 1.0
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-20-marcan@marcan.st>
In-Reply-To: <20211226153624.162281-20-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:01:23 +0100
Message-ID: <CACRpkdYhs9_+5iwpB7nJT6xXJ0NBtjDd97_DAxvsMXXV_jg9cA@mail.gmail.com>
Subject: Re: [PATCH 19/34] brcmfmac: pcie: Add IDs/properties for BCM4377
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
> * tahiti:  MacBook Pro 13" (2020, 2 TB3)
> * formosa: MacBook Pro 13" (Touch/2019)
> * fiji:    MacBook Air 13" (Scissor, 2020)
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
