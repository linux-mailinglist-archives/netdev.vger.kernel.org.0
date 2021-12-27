Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F1647FC2D
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbhL0LYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236339AbhL0LYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 06:24:18 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31740C06173E;
        Mon, 27 Dec 2021 03:24:18 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 196so13427176pfw.10;
        Mon, 27 Dec 2021 03:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PKOaVp+DaExJUXdJEUY/kcEJXUEhUxNZk2skGH27RGk=;
        b=IFagba8w9Q2MIRkQv6Ms947WdrBqao3xVy6YT2QoH6JBhhuNmJ98Iham5B4MvNwRg9
         fC2QPI+ocZp634JdxPciYb5vBMsWD5g37TBSo8DpwG+wySKlyW/X9xxlBa45QaE/NpnG
         pBwl5iWahEj3La7YNi5MlQMUYTp2ZmzsAS2NrR8SkVHaZdM14qDupOw89K9hHrGZi9ph
         OL4KAHTwOUafssCJpipvPinKtmPPo1FJrMZLWTg7zzZW/kw+9gb2gCMY9OeOdvZwYGxM
         nHHpANEU3OSPfX6lhhLmx3lPImvSY4Ya11pnxF6E1q8T0sN55I+/1jixaNKqJ2oe8wqz
         kKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKOaVp+DaExJUXdJEUY/kcEJXUEhUxNZk2skGH27RGk=;
        b=ChJWBtawNXgSFV5OVNBhyqDYAw3sjtnAud6icob9t2zmjyuDYNq5Y5TNRVOGfhcAJk
         3w0rpuQhM/jyoaIsEY+YF6cE/k7c/8PgodGUS++3vUHN67aOkrmBATDdW+vJhXBRHjnz
         IKpDieslYq6jb5Ol7nDRxUb6WJtrX/TorpspmPy9nrslSx5Fdw483U/h/bNRy+coJt4S
         Pp+F4PM3+x9aLWbbklN455/oz4E4TaOt86JlPxzPTzGhrcowa6qLbaeZ4WncSFDmz0bF
         x9aXydMCn4zQ2EIFm/a4T6UmWkrYeyr5eXnzEGMppLeZ/taDg6DXFd91bqZhhZ3SaOkH
         YtkQ==
X-Gm-Message-State: AOAM531q/bu3e772Nr4TNXTsXa/3OU0p1N8EIl8kj5LuNuEp7e5hAu6e
        1DTYJDzJkinjcKw1F8uUTJ364iRa4PcTuMAx/Kg=
X-Google-Smtp-Source: ABdhPJwlKURnKmkfRtFRmt0VpKdlspKDqSphz73V709cLti80gmU59cF/xhtU13MRqgkpZWE3YRc2IbYuaRSrAhM/t0=
X-Received: by 2002:a63:596:: with SMTP id 144mr15041320pgf.456.1640604257607;
 Mon, 27 Dec 2021 03:24:17 -0800 (PST)
MIME-Version: 1.0
References: <20211223181741.3999-1-f.fainelli@gmail.com> <CACRpkda_6Uwzoxiq=vpftusKFtQ8_Qbtoau9Wtm_AM8p3BqpVg@mail.gmail.com>
In-Reply-To: <CACRpkda_6Uwzoxiq=vpftusKFtQ8_Qbtoau9Wtm_AM8p3BqpVg@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 27 Dec 2021 08:24:05 -0300
Message-ID: <CAJq09z6_o9W8h=UUy7jw+Ngwg26F8pZVRX5p0VYsgoDKFJRgnA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: Fix realtek-smi example
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ooops thanks for fixing this! (Wouldn't happen if we converted
> it to YAML...)

I'm working on it. I might post it in a couple of days.

> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij
