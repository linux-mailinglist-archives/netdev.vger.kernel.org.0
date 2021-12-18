Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3495479927
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 07:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhLRGPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 01:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhLRGPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 01:15:35 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD81C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:15:35 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gj24so4195274pjb.0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xD9DPWA0Pzw0uZ6PPvLPL2j7ioPg9Ew9S/wTuvqliQ=;
        b=pzyWmTcli2iBAU9M8kg7ovZBjuR267sR8l16CuageDK+DNID16nSNuByyr3lYh6I0t
         001668izH+2ddsKkbgog+aDbM78aouL39TLLJdaNfZJp4xYb2PiLmtPNWsoQbkFh2Y5/
         DOuKNEP7ORM+LhFJDciQAQJDKd+2tFc6AreNYF+CSOjcz2WtZLnPmSWjxbzn9nUAkVj5
         jHz2FqM0cPJ+kxENpCwJvoYYDWXJ1azrcADNhDYYt8Tz5Bp3AhMb6ak1kFr6jW+D9VK+
         gOZevTp6TTVid0v3CF1xO/4htvYi4wJh2L6u2UO4qUk+HqOWsyIBK2HWH2bqnm+ViMSq
         oIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xD9DPWA0Pzw0uZ6PPvLPL2j7ioPg9Ew9S/wTuvqliQ=;
        b=CD+SWtMdMxZbTln1MC5cnOKGAIavKdujQCkA+pWd7oi6glC5Em7HtYHoYzV2hNJ2dY
         yD2wutVddCwumrftNcfge+bdT9/DLlkjK3WovlgER48cMHzl+dMeYF/SHXjZAQvb4NLB
         s8cI6qJB1V70zbiY8Z89h6T40HM4VoLktBWKbvDmJQCrfr1I1nBpcA2KSRzd6xcP7Mky
         Pyu5pZI0InpVsQZ7dxwsncsgrWWd7l/S4Mc3FNdcO26tACe7RHCWhy5tDBCMOeEHunHW
         6GjoWsYOYAxK4/5nx3129JLIU8+U3Dde7zUWovsqD5H8/A41LXueRLgxlA8DD1zYIP94
         u0Xg==
X-Gm-Message-State: AOAM533JcoZarBN9J3S6rEqF96czK/9RPqMIF+3ufg/hgUehyk60HOPt
        wjnmWptri5JX75bhbB0/HZQljIZ9coR1aRjnlHA=
X-Google-Smtp-Source: ABdhPJwECbc1GjXiY9UAQbK6s614Y4ESBMAnQX2JhGdGDIwYW/AEZdyR8hX8gHjWV7qmKS5hFrEDnRtDIPPX2q0O72A=
X-Received: by 2002:a17:90a:f405:: with SMTP id ch5mr14758602pjb.32.1639808135014;
 Fri, 17 Dec 2021 22:15:35 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-4-luizluca@gmail.com>
 <4a95c493-5ea3-5f2d-b57a-70674b10a7f0@bang-olufsen.dk> <CAJq09z4NJhU7NgzHNg=jRhi1nZgpszPzCssb_z4h0qYUzcO_FQ@mail.gmail.com>
 <CACRpkdakKuQuRff2Rb=8hkDka=+eeWox_9tvm-nhCrGzffed9w@mail.gmail.com>
In-Reply-To: <CACRpkdakKuQuRff2Rb=8hkDka=+eeWox_9tvm-nhCrGzffed9w@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 18 Dec 2021 03:15:24 -0300
Message-ID: <CAJq09z67bze1cXmJNtUnCFsZG6-+_KemqyHBiFY3DJZM=VQ=fQ@mail.gmail.com>
Subject: Re: [PATCH net-next 03/13] net: dsa: realtek: rename realtek_smi to realtek_priv
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I would probably name it "rtlsw" (for "realtek-switch") instead of
> "smi" or "priv" since "priv" doesn't hint about what it is just that it is
> a private state of some kind, but it's no big deal.

priv is used by other drivers. And it makes it easier to copy code from them.

>
> Yours,
> Linus Walleij
