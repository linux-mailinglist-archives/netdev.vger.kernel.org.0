Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FD842BDD2
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhJMKxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhJMKxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:53:13 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F339C061749
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 03:51:10 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id u18so9830835lfd.12
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 03:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rKfrG5HHh3oByuKlWlvIaOLx1lvfyWUDrGma858qYu4=;
        b=PM4nQ3HIhjJ2Pk5nkf2WdoHIipWVFAbxEGjfZadAqybQ4lcctoKu6oL9ozmu4+CRTZ
         uYIVnj/KasRu8P5C8j4KeWBZdHkmqWbcg7FZJjB+IlCLrSuPl9oyPQNc/6z5IY0xtYk7
         iea0guujK7W4loKN/Bdg1IGrCMUqIZBnVFNemU99yxwV+YBihHQBEb1VKi1cfodpIegh
         CqhZR3NK8QqpiewaxmZ4tx9ILWzWKuWea8Qx64M/DM4EjYcwY7FVTJLLeQKSwvVgOxFh
         fwXO2hJYhvFlED8pENWDK/HoSvWXn+/0A/nSz63cQ16tnLAP5Vss6BNjbr+lMjQOKMFG
         T5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rKfrG5HHh3oByuKlWlvIaOLx1lvfyWUDrGma858qYu4=;
        b=EKjOzajleD6KCLIdJxPaydLMd6QaTVpeY3V7i4wMnsIx4PRHeWjPVGZAS55mE58END
         pyXjHoUIFKOxEHgXQLr6jNE7rdyHZuon7Ap9nWQiYCH8zHtRjuj3F39sp6yx0SsCBc5M
         Cl6bG0t4hC1e7mfxOAqnF+IS/6UzFsfI+fOOrCmv30acTSuIdR/sOmCRHgIQQfUR1te9
         /grPehmBWY/Rdlzk6jFimZMFeYw23Tdco8wEGC+SeXA20hZJts41WnRP2d2BBlBPs/tA
         8kpjIFhIDEUKZpNqiKyFgTMvs6Iq4A3pJFEZLa1RX1XjOc51+y6rlwvxTuyI0rca+8lx
         Y5Pg==
X-Gm-Message-State: AOAM531KHGmbcLJI517D6wu2tiWSaY71hyA/U7q7YtHgS5gVtV+lLAex
        szPTlfsVvqAGVejvwbGCk3k4tJhfaivYnAcBxUgY4Q==
X-Google-Smtp-Source: ABdhPJzSXmuXGLBC0odLomW50c6wMRcojgUpr4C5z0oUp4TqIelvRRd22KJdLKLOYhRHwdIro3XxaIq1Ttl1rW8y4uE=
X-Received: by 2002:a05:651c:4d2:: with SMTP id e18mr35521797lji.432.1634122268377;
 Wed, 13 Oct 2021 03:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211012123557.3547280-1-alvin@pqrs.dk> <20211012123557.3547280-3-alvin@pqrs.dk>
In-Reply-To: <20211012123557.3547280-3-alvin@pqrs.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 13 Oct 2021 12:50:56 +0200
Message-ID: <CACRpkdaTZYgW8PWabUoKA97B6yOUUGaNsnXOrrxtHc38fU8Qnw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/6] net: dsa: move NET_DSA_TAG_RTL4_A to right
 place in Kconfig/Makefile
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 2:37 PM Alvin =C5=A0ipraga <alvin@pqrs.dk> wrote:

> From: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>
> Move things around a little so that this tag driver is alphabetically
> ordered. The Kconfig file is sorted based on the tristate text.
>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
