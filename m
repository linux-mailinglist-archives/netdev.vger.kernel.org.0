Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409AE49FD43
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349761AbiA1P5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349747AbiA1P5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:57:53 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DA8C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 07:57:53 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so5565688pjq.0
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 07:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dLcXi2eNRWRwxCaLxYEV1OJz1Rb3SyRiEQodTjP1sDY=;
        b=F1yvak6TdOxqEv6Tj5XmEEZoF2LTCyVDLfGM28me2yqrJrZdxPukfg1YKrkWc5a+58
         Pn4KrQ9EidDgD1P+5I8+XeD6+1LT7sxczbHx0ZkmFLgHxi2ZaAF8TfKYWwIkkCHc9pWt
         txogMCpxcfxTO26OBKdmZLNTjO1gvc6bEI3LqBkYF2WR6cr2SXmKHawQ7gQUH7BiBWx/
         unRv3AK1q+3L15ev+32WyPh+X13s9n1guVDGZVW5g+dEAysMnq4X6nJJmJwZ5Fbuo1km
         caRBPcTCGZpjrgGK1tIfSspKND/BaTO6dRdCO1xn+n+LtkLjUr1XANAXqZnVoxP/fQWV
         /OLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dLcXi2eNRWRwxCaLxYEV1OJz1Rb3SyRiEQodTjP1sDY=;
        b=WEoWSE3b/1DoNW/l9DnnbiNTRGk6Yz7XmBLoKz57teOT9QQaWJhuaAPC/5LGoe4JZE
         TKaksdlYjYMH9iKQgXupZOL8TKx5//NRYpOIORNEULCbf8oRTLgoxo28bHWUHV46YfEc
         IWkbZH/bgDhA905jf+mwtKLOlvxR4IdkGx3F2jpCX7istWlG5lOk68+bT/JikN7AmBHC
         aFDQ36olEXS68D/DQ9XmQfKs5ksBNIyWOBs9NWy8MyCTSlRlnPa0AeAc3mjDbRzOzyjW
         WmTxJvBZYvzYBg120ZZSvhjGtKG7vylBqwUgY61+H8LOV6CnhkvUs2rLcZy0KDJXzAEB
         4ovw==
X-Gm-Message-State: AOAM530y3qSSUxiskWej9+8LRGxO7gXIpwbKHYGesJmZuKUlHl6FEnpq
        zVR7BX29PcDYqPTKFBhetrVwtfPTSXDOcThdbdk=
X-Google-Smtp-Source: ABdhPJx7Q78KqQY2jTt/SSoU4xtX9SZFgcLQhhTgH7PQcEirHvXRy7QH339sYwxu95ubPXlcK6T1lYbipefxEUfUy5Y=
X-Received: by 2002:a17:902:eb52:: with SMTP id i18mr9111924pli.143.1643385473126;
 Fri, 28 Jan 2022 07:57:53 -0800 (PST)
MIME-Version: 1.0
References: <20220128060509.13800-1-luizluca@gmail.com> <20220128060509.13800-12-luizluca@gmail.com>
 <681c9be1-911a-2a68-63de-09644f24fea8@arinc9.com>
In-Reply-To: <681c9be1-911a-2a68-63de-09644f24fea8@arinc9.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 28 Jan 2022 12:57:42 -0300
Message-ID: <CAJq09z7Wu40J6sb2i0OHCnsZpD71n6DzoB=sTDNUMHGZ89Xt_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v6 11/13] net: dsa: realtek: rtl8365mb: add
 RTL8367RB-VB support
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Frank Wunderlich <frank-w@public-files.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> You should mention the support for this chip model on kconfig like on
> "net: dsa: realtek: rtl8365mb: add RTL8367S support".
>
> Don't you also need to match the "realtek,rtl8367rb" compatible string
> to rtl8365mb_variant on SMI and MDIO drivers?

Yes Arin=C3=A7. You are right. Thanks. The driver will work "as is" using
any of existing compatible strings but I'll send a patch to fix that
after Documentation is updated.

> Ar=C4=B1n=C3=A7
