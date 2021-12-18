Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B26E47992C
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 07:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhLRG1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 01:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhLRG1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 01:27:01 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49542C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:27:01 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y7so3718347plp.0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PGLNrKDEFizlymgwQRTnq4nEQOg4GBd/oUSTQvc8lEI=;
        b=FBgropjrf1xkST/Z3SXwhcXo3h8fbvOj7qOm+Ytm0lPMtzPtuOxpOdH1DuEoxA3CNs
         x/BbcrLSlgqmoAUrWExCXDkez8540FCb1eN5bqkL1ffVni2XoUEaF9XOPzI4L9jd0vMH
         miw6jrPiGdoP25TcOVvZNneFM3net3AVEUiNLIO6WAFIVc0T1C5BuCvCRX5mYIES6tJL
         fQQcMSQh9IT2zmRczuriCFED3sTJh9FNuzIwog7lOip+aT0zezHS6eHddXfmmQhtQHIG
         xyGoEqa9hlNeOswbgttmZvbGFCa7qvFKHaeH3c2/70mmZ9sKH86KUcRWgNRLULEfTe+J
         H5wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PGLNrKDEFizlymgwQRTnq4nEQOg4GBd/oUSTQvc8lEI=;
        b=5MALTcXt3CMilnzi5cLQsVSEhyCpkxw1G4P5aR4rEhmNUcNX4V/5Ad8+6vV1l9uylq
         2wsEuYHwwu0EIMlhTy8HFG8hwm3OBLxIKZmdMseqHlbx5iOpXRJ2kRPO0u2Rh7KwbqFi
         IHQQE/2A6OQ50vd+3m1erEUGPIzLdtFM1244JPoOAHqY5PLkpuv1XRoI8r5gmiUxz3k9
         uFYUt2YVCNdZP476FNUwm2TojazyhvNEonSv91J7xrBdxmNF/StxZG65xlvvRRajW6o0
         viikGsjWztZqWGV2DuMtP/X+Ku0ylKFkprDbQK2Z2oalMKvQmtye7M2t5JB6EUwgMiek
         ADLg==
X-Gm-Message-State: AOAM531G23AH8LTTIuvrSB9DduL0+54CGbF4A4THwe5cmb0qja8GzzTz
        pvmVuLZBWS79iHxBRnVwqpBv93ep6A0TOJnk5Vk=
X-Google-Smtp-Source: ABdhPJziVlPpLdMoRbAKvpCclBOAOkb1UKuvrpLp6EQrsJUS+cWIGfjWQa3t5PzGVCMyF3c486E0sSCQdtv5RgE7Eno=
X-Received: by 2002:a17:902:a60e:b0:148:ad72:f8e8 with SMTP id
 u14-20020a170902a60e00b00148ad72f8e8mr7005160plq.143.1639808820763; Fri, 17
 Dec 2021 22:27:00 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-10-luizluca@gmail.com>
 <CACRpkdZP3jj45Q9Kaky63WfbDWyT1sT6PNSdrVEQ+PYhGmfP6w@mail.gmail.com>
In-Reply-To: <CACRpkdZP3jj45Q9Kaky63WfbDWyT1sT6PNSdrVEQ+PYhGmfP6w@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 18 Dec 2021 03:26:50 -0300
Message-ID: <CAJq09z5DtVVLjZT+aXxbW+ouCX3dTwECWhJ0q3ta=ZyMx0OD3g@mail.gmail.com>
Subject: Re: [PATCH net-next 09/13] dt-bindings: net: dsa: realtek-mdio:
 document new interface
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        olteanv@gmail.com,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +++ b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
>
> I think YAML schema is becoming mandatory for bindings, sorry.
> Are you experienced with this?

Not with kernel YAML schema. But I might be able to handle it.
It might be easier than writing a kernel driver.

Thanks,
