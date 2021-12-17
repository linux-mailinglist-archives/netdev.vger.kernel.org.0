Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E159E4784DB
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 07:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhLQGVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 01:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhLQGVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 01:21:50 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C91C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 22:21:50 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x5so1451538pfr.0
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 22:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Otjbg7mbo4OO8l2IAODMvRsvxwgUnHr5i5EoA3HmeX4=;
        b=WimxT70A+cQGhGj2Ye67Kluh0CH797RY9cjn8XmnscCSFkYGf38jE3aTjNobIWf3W+
         BJ5zfohblVjqDd5/yByijAlvVe/NygaQxjP0YBQTcsd6/+KotcrKonTHqaU68H1ftqgL
         mTrPMZD6+ZbWRabRHI9OWUjaM6ubQWl5XKaW6k4gZasUNLnwkfDEYpZictcUwj16KsUy
         srJ9zTR1BiJrdiT843iZPqZfCbDcbxmpxpbGBdcJnm70lu6UltVWbsp7pxeZVrvpJ9cV
         YO3iDjL9dZb1sHKTsHo39dz8jwM0ysZXDxLqUvYWNZd8O5Bz/oxJ0IbgUYA7ES0HbPvf
         73tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Otjbg7mbo4OO8l2IAODMvRsvxwgUnHr5i5EoA3HmeX4=;
        b=SGlhWSuLe80YdUjMy1KEinJhYhtS+xcmemcAkAHLLNRr7x/QkdiL+CS/3cErt6OO6K
         DQJih6QQLD4TUcmJYDnB8bxzmK6IxJveQpfCHHahYozGyXLi1Iv9o5lgiMKSYNvaAdOc
         pCalPxMQDWBlQ1r/nQPSs88boUjQlb08O4elmzr5l4i+qnA1K9B73lXzlntf6Ecbph1b
         kNibOUx+JJCihZ5GP64/qthCnFPuqimnvRy0KClQxbOXyvSc6HxV8hE/JGqDl4hdQrEq
         MeZR1dRCsmClcEbWwRskxB6CPGXlVWwagr5S9FeIwjbH+sw3B/g+SMi4MSgRvetq1fBD
         kdOA==
X-Gm-Message-State: AOAM531CyOagIr1c39CJVCBg8uZa7KQ2Fk5g75raMU4gl9wogfRmtLkg
        s1oer4QIwv3VrlAbMkw9cOvQtTEljClSjqxTyWo=
X-Google-Smtp-Source: ABdhPJzeZitYFft+5uI2VmyyUPxwDfFtfPQ8z8CLESRZxMYZbdqnlvlsL1UeKefyfel03/m6Vk5HHK9EWEMDVFW8tPg=
X-Received: by 2002:a05:6a00:811:b0:4af:d1c9:fa3f with SMTP id
 m17-20020a056a00081100b004afd1c9fa3fmr1739335pfk.21.1639722110106; Thu, 16
 Dec 2021 22:21:50 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-4-luizluca@gmail.com>
 <4a95c493-5ea3-5f2d-b57a-70674b10a7f0@bang-olufsen.dk>
In-Reply-To: <4a95c493-5ea3-5f2d-b57a-70674b10a7f0@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 17 Dec 2021 03:21:39 -0300
Message-ID: <CAJq09z4NJhU7NgzHNg=jRhi1nZgpszPzCssb_z4h0qYUzcO_FQ@mail.gmail.com>
Subject: Re: [PATCH net-next 03/13] net: dsa: realtek: rename realtek_smi to realtek_priv
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alvin,

Em qui., 16 de dez. de 2021 =C3=A0s 20:22, Alvin =C5=A0ipraga
<ALSI@bang-olufsen.dk> escreveu:
>
> Hi Luiz,
>
> On 12/16/21 21:13, luizluca@gmail.com wrote:
> > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >
> > In preparation to adding other interfaces, the private data structure
> > was renamed to priv. Also the only two direct calls from subdrivers
> > to realtek-smi lib were converted into references inside priv.
>
> Maybe split this patch to separate the churn from the more interesting
> change, which I guess is needed to support different bus types for the
> subdrivers.
>

Yes, it is better to split into two commits:

1) net: dsa: realtek: rename realtek_smi to realtek_priv (only string
replace/file move)
2) net: dsa: realtek: remove direct calls to realtek-smi (the good stuff)

And yes, part of the issues you pointed out are just because some
changes landed in the next commit.
As I splitted the commit, I could see a bug in rtl8366rb driver, I
didn't test if priv->setup_interface was set.
It would call a NULL pointer for realtek-mdio interface.
