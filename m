Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F915047F8
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 15:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbiDQOBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 10:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiDQOBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 10:01:17 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E0227CFF
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 06:58:41 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2ec42eae76bso119936377b3.10
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 06:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANR33VVuE6Uq8IZunWisImso7t2gMAK1i+xaKiuRQAI=;
        b=OYT/4cVvCVlj8n0aG04hDXrPm0NCCblbHtRsJwywvDY5vzwobvqOLKCqZSQ5PdQ7t5
         OjKBExv46cv8TOvfrDAQS4n6chyLt4y6bpankUbh6A558XBEj7QrLUDhhFlkDryjl+XV
         TAWNKXfj/mGL1j0yJdTafPCXnBSQBOZUkk3oYsWayvg6ACr92f2Nlcnc6SLPu1IcMMHh
         FOuNVOVagOPVbran2U+tqioner1flqOCllu0LeqnR6XqxKQVoB4RyQE5U7ZKgKmAkUxR
         UO45KWVmIx7RCQUS04ClEI+1Z/nRyIoXZMvkYp0PJ7MgG5L+Qu5Bpc4K2YxSIUAS73XE
         XBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANR33VVuE6Uq8IZunWisImso7t2gMAK1i+xaKiuRQAI=;
        b=y9Wyc0hFH+L2hp1OkOpS8qjpd/sQY5v8fDrQPbuH5e3/z4zKFxXORqqTdBzAl/P1Ih
         Jdu+zrbzRNcBZqRiubRVUMvnRvUYTxvoK3P10Uy210EwXUXA+rZeN5Wlay+Z48ZGXZGA
         oivQ/NGxZY1YyzKTUDkYyHKksualjZvmFI9XFDDAYJ7f9Zadg8jZ16Jl4h532N/vl9i8
         FUR8tMsprTluq0tQtOvY+r+vsxfFWZSGzdhcvszPJg5pOh6Mt5T0gQVLayEuCf6mTTz1
         vsyf4/sl7z/g3gr0752BlyI/1MRKCg2bg5XgnQApF7Xk5oR93dOcpMJWV1a2v+9F8mgz
         b+Ug==
X-Gm-Message-State: AOAM533GMjD+HGEGiJMfkut09CkINn+zACQs4UVIRLWgOFBHwgA6xFIZ
        56tsEg5+gRT6HEAdQT0p5zyc/vc8npcF5zCETaRPDg==
X-Google-Smtp-Source: ABdhPJwISkt+0eAcJceltgKo5AqccZcIk5oQLRd1Rj4FIk7e5WOzQJaC1oOHb+P4cCtMFyV6OrHLjD0OqajBFMTTmws=
X-Received: by 2002:a81:5dc5:0:b0:2eb:3feb:686c with SMTP id
 r188-20020a815dc5000000b002eb3feb686cmr6684230ywb.268.1650203920767; Sun, 17
 Apr 2022 06:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220416062504.19005-1-luizluca@gmail.com>
In-Reply-To: <20220416062504.19005-1-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 17 Apr 2022 15:58:29 +0200
Message-ID: <CACRpkdaZUiYcw2FekoZLvn7LbVUD-_sJkHu-FLcEpJAueVCN9w@mail.gmail.com>
Subject: Re: [PATCH net 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, ALSI@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 8:25 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> Compatible strings are used to help the driver find the chip ID/version
> register for each chip family. After that, the driver can setup the
> switch accordingly. Keep only the first supported model for each family
> as a compatible string and reference other chip models in the
> description.
>
> CC: devicetree@vger.kernel.org
> Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

OK, I suppose we know that Realtek has always maintained the
ID numbers in the hardware? Otherwise we will end up where
bindings/arm/primecell.yaml is: hardware ID numbers that were
supposed to be updated but weren't, so now both DT and the
kernel has to go through all kinds of loops and hoops to make it
work by encoding the number that should have been in the
hardware is instead in the device tree...

Yours,
Linus Walleij
