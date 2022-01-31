Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934994A3C5E
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 01:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiAaAuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 19:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiAaAuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 19:50:04 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B77C061714;
        Sun, 30 Jan 2022 16:50:04 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i17so11491441pfq.13;
        Sun, 30 Jan 2022 16:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5BcSfD6/MPJDRM9kMf6H9kjyX2ZQwqKC6FfCeRB67sI=;
        b=mAoJVGyuYVdpHaoofOs68Bza9bJE7r7gAehK8DWMwp/NQhHj5+CFsH8HhWDpiHE7wm
         3lx59gUOB9rv1aeWRZRDp/YYYd9oi8CUsCo9g8H9uuP2tm6JePh+Oe76Cm3xtUy+Q0Bd
         bqyw6jSJResmiZ/fWX00My4XiwB88AyG8Ycq/02uq68i+6XydV9AOg9Atklqrc7MvThF
         jr7rk5KX7hg6E4RR/ueCdhiJB9sCoTqBMWBiS6PxPI+728XZAr/qxUE4GDFKFkFoBxMO
         amdwVQYKRUT8HF7BotVds9Dmi52DpfLIicSmOJNqIidrp34ucw68FpFlfw0zbrAghSRy
         rlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5BcSfD6/MPJDRM9kMf6H9kjyX2ZQwqKC6FfCeRB67sI=;
        b=TVt4Xo64O1xYagO9VypkktsVgMhucCijm5wtpjmDKr9v88cgZK1qaKDNuKVo6WuUxw
         6iDtLFWXhlw1KKdcf1gCYWWY8fO5LU8qCacHMvoXmLMRtvPP7uVS/nreULrjRK7kxfSZ
         Jko+BqZGGeuzKNhZw4R1OJgI3tQ6BK9cIxLetVo6CbahYQIxFmcaWwcU96+Pj1fqOkiv
         BzyN5Mn7ZokNMSFu+eIkLv+McUgMJrwMw8gkZ9Z/ZUgMn9FYMzkZBhKjttLGHo/rQ/VW
         QpfP0u66d08zlzZMaBGekZGehnS68TNQaTjZqHWu2LVwZ6dscVnQeQ+YOwaXiGJ2yN8q
         Rr/Q==
X-Gm-Message-State: AOAM532hgVIZRFKB5TKUduACHw4tJ38fbQaCkX9i3IAIDzbLWighpR+H
        rDEc674nbldR6OOXEGHVSs0h7/V36li0ZUHLTSyAcnq4jUOQ9g==
X-Google-Smtp-Source: ABdhPJzzQXWZNSSW/TegevCe3ttBWRYC2GKTVKPJNXAXXzvQrT/mEAD+LKMRJMEh3+5XhET9fPkX1LcRWuRX60rS5lI=
X-Received: by 2002:a62:190b:: with SMTP id 11mr17443446pfz.77.1643590203382;
 Sun, 30 Jan 2022 16:50:03 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com> <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
 <7d6231f1-a45d-f53e-77d9-3e8425996662@arinc9.com> <CAJq09z7n_RZpsZS+RNpdzzYzhiogHfWmfpOF5CJCLBL6gurS_Q@mail.gmail.com>
 <a9571486-1efd-49a7-aa26-c582d493ead6@gmail.com>
In-Reply-To: <a9571486-1efd-49a7-aa26-c582d493ead6@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 30 Jan 2022 21:49:52 -0300
Message-ID: <CAJq09z65Ljd12yM742ovC6-FZ83bryQvuE2_cQR2Qvd8zRHi4A@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Your YAML file can cover both types of electrical bus, what you are
> defining is the layout and the properties of the Ethernet switch Device
> Tree node which is exactly the same whether the switch is the children
> of a SPI controller or the children of a MDIO bus controller. If there
> are properties that only apply to SPI or MDIO, you can make use of
> conditionals within the YAML file to enforce those. Having a single
> binding file would be very helpful to make sure all eggs are in the same
> basket.

If you say it is possible, I'll give it a try. I'll just need a hand
with the interruption section.

Luiz
