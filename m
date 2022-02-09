Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7504B000B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiBIWUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:20:52 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiBIWUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:20:51 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DC8C102FD8
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 14:20:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id qe15so3464075pjb.3
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 14:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kdt1F3Bev2NvPY2nh8CHsKMq0vqpY4VLm3GuBJ2PHwc=;
        b=AiKLMNWhTq/HbFZR5Xbox69UqqdhSyhGqRLihR+WEzs/DWrTKfjY6qSAUU/YrZQ6fc
         WldoRNrx+2Gs53MZ74bA3wBVY2sHeg0yz88g0N8unRtHpfDmf4LpMmzLaTxxCrHP93+P
         zaSwmd829cvmhGBzRX2TOmznI9Uc6MkYk8bBmr8XKJGRUviW4uChlILI7DI4Rqp+VkKB
         NqaWijZC5XfF17qm+7zBtbWeD3kCAUTbK5yi7MYWUyEgK1o6lOvQfqLXlwE4MuDn7JV0
         3razwieBsKVnbp3nW4pikXwZcnNx+Id5sp6MbaPUt9G6RnZLiPDyKDuUrrbN2M+lmvfW
         8D2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kdt1F3Bev2NvPY2nh8CHsKMq0vqpY4VLm3GuBJ2PHwc=;
        b=dmb0hLg6d4pACCaiDC+y3TQ+kLo3BLFQErlanOPGgc/RXtjynEZglnh3sgBYJqyLek
         8/+MPVaOr+IM4Teuo23DMzeqLGJSd2SnCFvJfvvK+xQBwXbEczN4zlsZQRE/j0z9E6l6
         CmMOcFQm0Xfi1LnUq9OHrfb49+BwMgCGrH68wk/RO3vfuHLU9bNcBwXxHs2CZbOwrD3O
         8WW99gPYngMTQUVrbm2MtxaGPAdE10y6nkKBY0fQpxN6dBDeUS9M9efH8xk236nK2NEV
         1AHCaImANOaqSkclpMNDn8HKfWgnSQu5nRYvCczQh4govv5gu+EnkNb+BGcO2YeRzMT7
         sTYg==
X-Gm-Message-State: AOAM530tRIRdEnj7DYCwghhe6wsDln+VI20ltAZFM87ho043fEXq6FWa
        PpDoWRpLXS6OBPsp2sbf4jJ5xOnBLNA4DKytbB9XlD3SjZqBDfwt
X-Google-Smtp-Source: ABdhPJx3WVyYlYCMGJoUvIFrPSvbOVZUZ1My6q8M8SKX/SCXcwTCQkQRAWndJvJ3K7oTjRIBHSrVHlxZsTVLJjsrSFg=
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr5057228pjb.183.1644445254035;
 Wed, 09 Feb 2022 14:20:54 -0800 (PST)
MIME-Version: 1.0
References: <20220208051552.13368-1-luizluca@gmail.com> <YgJtfdopgTBxmhpr@lunn.ch>
In-Reply-To: <YgJtfdopgTBxmhpr@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 9 Feb 2022 19:20:43 -0300
Message-ID: <CAJq09z7iZenWZVRA1SMppMF6GLJRe-buBrx7xdaTa2x=gSfd-w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
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
> On Tue, Feb 08, 2022 at 02:15:52AM -0300, Luiz Angelo Daros de Luca wrote:
> > RTL8367RB-VB was not mentioned in the compatible table, nor in the
> > Kconfig help text.
> >
> > The driver still detects the variant by itself and ignores which
> > compatible string was used to select it. So, any compatible string will
> > work for any compatible model.
>
> Please also update the binding documentation:
> Documentation/devicetree/bindings/net/dsa/realtek-smi.txt

Hello Andrew,

I just sent the doc update.
https://patchwork.kernel.org/project/netdevbpf/list/?series=612748

Thanks,
