Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD366BB448
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjCONRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCONRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:17:12 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B09624C8B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:16:44 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5416698e889so246567327b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678886203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQ3eXjwbttuSy1jojETL4F0LELQttESdV4EJu8Cz1Rs=;
        b=Wi7YKk4pInAi0NM33rIZ+cs/wlDJ4brXMuNSXi9LhXRPdUnLsc18k2UOiZ+EOvUo55
         AEtFR4ncMJ26HgraZNXwTIMlen5NLQHbCA8BcCgyVPgBrMjgfG+3w3btZ5KUpPu58OzP
         qCuGFtkn3ixV7ZMZ7hjhXLsvF1w+xlP1noJsxTkJV1X1MZm+f9QX/NsYrO+ewPx7MH2E
         tWXX/pPwu/NbeSpRMW2Uq1Kat+oyn6rE9V/GWGJBNVITOCVzQDhRTu99gT5yMuWZowxg
         KZwFPOj4I8JMnKvnelONwiGULEHXASWjtwNgi8U6ZBdzUmDfObK2rRSl6CBCES/foh51
         iv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678886203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQ3eXjwbttuSy1jojETL4F0LELQttESdV4EJu8Cz1Rs=;
        b=blTNSMP2EZ9UGLHOYIak+NTv2QivaOt+ZlVTF8i1f6t/zY3ucyaM/+UuPwoxAE8xBa
         SXpEPrt6Q9zq+NscGBxEARRFU3ZFDC5zBmxiVjXqYJKiwM9G7RWDqai+cIYT8652A/p4
         Qs+EE4fRCikkl4DE9b6wa0VZkIPH/HRgFJcdVG6l9dg54JrKHME/gQMLKmgtwHgcd781
         XOmktG2dx6TgGf9VKs21mRs8iIhPS0GQkPv30Cg1bXy7Hr+5WxmkzUFxMsjc40YkkkwA
         BWh+0gy4ITNPJUXd7Dz1ujqT8vGxW1rTQPzFti00y5pyXKlUC1RqvLQ3CkVyU47D9Swj
         btTg==
X-Gm-Message-State: AO0yUKXGRKwIK7clGHFh20n4TnZv7YGV68PFMJYX0KYxtJN/2+Lyqv7v
        pfvKHi6fIltNz8GNIvzZDMZGpNvTb85R8UqU53iQ6g==
X-Google-Smtp-Source: AK7set/7kcSIdBeBjQgDrxxsGgjDVizVzEQVvblH0H30lKgrgsFXvSmSoKoksW2pLmIlOEK5H4EX0UAorAFxnD7sTj4=
X-Received: by 2002:a81:ac67:0:b0:541:753d:32f9 with SMTP id
 z39-20020a81ac67000000b00541753d32f9mr9565761ywj.9.1678886203678; Wed, 15 Mar
 2023 06:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de> <20230315130917.3633491-2-a.fatoum@pengutronix.de>
In-Reply-To: <20230315130917.3633491-2-a.fatoum@pengutronix.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 15 Mar 2023 14:16:32 +0100
Message-ID: <CACRpkdYUnM5CgBAz8kCni89Uq9Hahk2h5GU-LN0x2-HYEiyR-w@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: dsa: realtek: fix missing new lines in error messages
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        kernel@pengutronix.de, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 2:09=E2=80=AFPM Ahmad Fatoum <a.fatoum@pengutronix.=
de> wrote:

> Some error messages lack a new line, add them.
>
> Fixes: d40f607c181f ("net: dsa: realtek: rtl8365mb: add RTL8367S support"=
)
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
