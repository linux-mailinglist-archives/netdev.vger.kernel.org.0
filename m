Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E81327219
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 12:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhB1Ldf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 06:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhB1Ldb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 06:33:31 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D592FC06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 03:32:50 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id p10so47072ils.9
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 03:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdRhJ5L+KmvDchRR3K2d2Fs9Vt3CM/mGoUkDGZ5+eUA=;
        b=Kt4onAfl3+t4QOnhzg7PI6yeEBOJyMziPXFKzebcynDNK0i//bDxfJlkjtbsmnu1Xp
         YOKh+CG10no5o8D6Xn6NMJrk5UmJiy2CrAgx/goIdkoC/UiNEs5vn0CyTFmbiLG9asyw
         LxHAGz2oetPdZjE57emoNMOysO1kEcaK0DxdUDnd9PtVhcTwl8Nl0jokPLKJohlE6INL
         e08rWKoKO97N6t9TEoZ2iFl/5l6XtGQuY1GSWTlHJWxIGm0apK7emEJosfaDuxB9ydZ8
         xStOIC0nLoAHuFT+hJcysTfQsJUnkuBvFEOhfkXvNC3XMYhldTsTvxc2JffkAdYMnhuf
         EErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdRhJ5L+KmvDchRR3K2d2Fs9Vt3CM/mGoUkDGZ5+eUA=;
        b=lW4efbGPs9cShC57sDeCs7t3H2B4xuU3C+PlS8Dm0otk5SqPWUHTI1+WLTm1njRCoK
         ysf0y4HDpaed+LdNb1WFEIPAobs8ts9lCCqVHQHK2Rt0RYeZArOYL3W9MH7knajPfKt6
         ZQfmMGIY9LuU8re+vCmwJ80dEBZ9c06kSRB6OPC3MB5nwW41iCyZ61Ya1tzU7YBmdi+H
         7Arcn3zV02dowGy7ce6hW542IdD5AtK+encn0Q9FmC2QilWFV8K9o8EqyqF081Q28VgR
         W1uVnNFApr4KN4dqNm1TXYOzlcZ992340pj5J9NBHJekERsEJS/CFk9gJytIdiE1wcUL
         hXoA==
X-Gm-Message-State: AOAM531UwrU26ShYUSKbZBHyTGIeGLQYzY89tMUVnjTJm47TkaH4L5Nr
        YXH9PHPcFJKfG6t5XBGFq2pe63IarC7Ths6scXA=
X-Google-Smtp-Source: ABdhPJw4+uruPb3CeBoBUIO7QkVcNIJE5E9hMyyIw00tuMw1VSNXwDGPNi7t3ZnotOrYqBvVMOhutOtTUw5Ke3ilwiY=
X-Received: by 2002:a05:6e02:1aa9:: with SMTP id l9mr9320615ilv.108.1614511970381;
 Sun, 28 Feb 2021 03:32:50 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-2-dqfext@gmail.com>
 <CACRpkdaP9RGX9OY2s1fqkZJD0fc3jtZ4_R4A7VvL0=po-KEqyQ@mail.gmail.com>
In-Reply-To: <CACRpkdaP9RGX9OY2s1fqkZJD0fc3jtZ4_R4A7VvL0=po-KEqyQ@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sun, 28 Feb 2021 19:32:42 +0800
Message-ID: <CALW65jbFu6apesQrdNiCSZPC2ziVOHBgjoGJi5NTgkZrD0Qv5A@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 7:47 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> I names the previous protocol "RTL4 A" after a 4-byte tag
> with protocol indicted as "A", what about naming this
> "RTL2 9" in the same vein? It will be good if some other
> switch is using the same protocol. (If any...)

RTL8306 uses 0x9 too, but the tag format is different...

>
> >  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
> > +obj-$(CONFIG_NET_DSA_TAG_RTL8366S) += tag_rtl8366s.o
>
> So tag_rtl2_9.o etc.
>
> Yours,
> Linus Walleij
