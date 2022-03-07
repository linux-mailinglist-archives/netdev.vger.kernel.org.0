Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2744CEF5A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiCGCMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiCGCMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:12:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C56AE0E7
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 18:11:18 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 195so12357191pgc.6
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 18:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ep+CWNUpop1RNjqxJF+epR1KP5byZCbvgoDBX/AbRgk=;
        b=Kgw+CDJazQFeB2r1VzoVfSUVegXhxi4OgAXwTL/cqgudpD2IDwPdFKiuRq7YHlNzTM
         uR36TESPrCvcqYQ/U9EFEfuG4gEn7povTXTUXUhN/BEzxfZekLrR0cesMKb/x+/KHCP3
         YzOcDJ1lYmHsEhXJODA1l1D1D8ynINsHY103yw8OiV/hFzzCUz2rnu3xQMXPbb1Avq5c
         T4oKOHMvW3WPiDYxLPbdRZkOvqTbZRbYHi1WiyQW6/ua4bv3gRzkk3AFr18/wOQW3dlU
         tTM/1sZFu9OxSYC5MEbSlsH0N0KUB+SiRE1z/bL5KmgpPyNTU/rBetJjA4U5rgsh6G1l
         HEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ep+CWNUpop1RNjqxJF+epR1KP5byZCbvgoDBX/AbRgk=;
        b=Xa2X/gvRJ2STkclsXOZlZTgJ+MqSTIuQfPeUpONQalmAOYfJzQeeQwXMLioWpPypil
         80RlBqBVmJ8UdWVly2QlJuB08sm8hFkHuANXhDrGSDfi+mDlwKrzh0NoN1zZ/fJ6Uzth
         G8NzE8WLTxRUotod9GKh78K1mVLW2JuRRxCzz7ldT+8fNFWJmyYRiatJJSXbk8zWgzLg
         YrXyG+DMuKpRZWKL4BCqHe2tVxlJsmDGgH2QgvUbiSQ8JiNvw+uiUwgdoG6KBzTOvW2d
         mDv1ZeVOkl9F+4Me5u+niXfhnXF5DsbuHA4tNAnYH0UMYV0C9bY6qLmRhR0skgVn9tBa
         9XoA==
X-Gm-Message-State: AOAM532wIKHd1qcElqwn8eAq5PfYm/8myXxy03Zps8BBZAsUQlJWUwQT
        JEoReIFlSEB9E2unnzp3mOXUSVwe9SlAOGJSqLw=
X-Google-Smtp-Source: ABdhPJyYKeLpSEMAR+85gMmYzXj01QuQhqNnCv+2Znl4we401rZv4aaMlmoK/R4c+J0jMxltX/I58X+pIOWfx+JQz7Q=
X-Received: by 2002:aa7:8296:0:b0:4f6:d248:c059 with SMTP id
 s22-20020aa78296000000b004f6d248c059mr10449305pfm.78.1646619077860; Sun, 06
 Mar 2022 18:11:17 -0800 (PST)
MIME-Version: 1.0
References: <20220208051552.13368-1-luizluca@gmail.com> <CACRpkdYZ1cMUn_aiMmbgHLZ41K4uMh48m1LQB5ComU_+sA=O1g@mail.gmail.com>
In-Reply-To: <CACRpkdYZ1cMUn_aiMmbgHLZ41K4uMh48m1LQB5ComU_+sA=O1g@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 6 Mar 2022 23:11:07 -0300
Message-ID: <CAJq09z7RXL7iQPdUd7zqcB2DPc6fL8-UofZ3R456v4ZJrwUjCQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> > RTL8367RB-VB was not mentioned in the compatible table, nor in the
> > Kconfig help text.
> >
> > The driver still detects the variant by itself and ignores which
> > compatible string was used to select it. So, any compatible string will
> > work for any compatible model.
> >
> > Reported-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij

Is there anything else pending I need to do? Docs are already updated
(during yaml conversion)

Regards,

Luiz
