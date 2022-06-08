Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17E5542671
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiFHFBw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jun 2022 01:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiFHFBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:01:41 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8823104C6;
        Tue,  7 Jun 2022 18:43:48 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ef5380669cso194218037b3.9;
        Tue, 07 Jun 2022 18:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yFX0ScDTbzbhgTtVTbyM2Jww+3EPJG7CHlISZZneC/A=;
        b=59JWVnM5HhUO/XryciH+kETEnIMZKp6yYAI6JqVjVOPNHOdDIuMqg1oGzU1YaWrdAn
         SVTlNO4DMVuQOOeW7p5maH9JOzxVefRCnqJ7/e5nlSaoKrohtFHZ5Tb2t+sBMaG9M/U6
         va9m9npND9TKtvJaw0TSODomwle4QdZeCA6gy5ZzBm1I5S5qOAqbO4Tphj9jQscd9mtw
         O4cWHQDysNF/Z/3fSoH2V8ug+iI2dZk9fzyxla2EXCynqW9qPnwAfLO311wMswIlh9TR
         1Hf8tDXVyNUd62ftgWohvCOaWBTDd0Q8J7WYq72RlFruDlv/lXHZndbs4dhQuVwvNIrs
         /l6Q==
X-Gm-Message-State: AOAM530kaMI0kf9BlQ3Q/fUFE5UKVmK622sO7ZjOvrMblEsANv7KDmD+
        debHyCItfLAv/p7b4T6RwVFIvB+xiMPWdKsefBU=
X-Google-Smtp-Source: ABdhPJy/8H+x3FlXFOirCvhyOHm/sGzv12loESI0dHu34OYJFkJP3OB773LdV2b1aJSA777LrGPhTaCfKxI1y8+y1yI=
X-Received: by 2002:a81:5ad6:0:b0:300:3244:341 with SMTP id
 o205-20020a815ad6000000b0030032440341mr35299576ywb.191.1654652305684; Tue, 07
 Jun 2022 18:38:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr> <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
 <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
 <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
 <20220607182216.5fb1084e.max@enpas.org> <20220607150614.6248c504@kernel.org>
 <20220608014248.6e0045ae.max@enpas.org> <20220607171455.0a75020c@kernel.org>
In-Reply-To: <20220607171455.0a75020c@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 8 Jun 2022 10:38:15 +0900
Message-ID: <CAMZ6RqJhshinGuG-wVAwyTiS42ZzwBRE1mdeiPg5gwamAVAR3Q@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Max Staudt <max@enpas.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 8 juin 2022 at 09:14, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 8 Jun 2022 01:43:54 +0200 Max Staudt wrote:
> > It seems strange to me to magically build some extra features into
> > can_dev.ko, depending on whether some other .ko files are built in that
> > very same moment, or not. By "magically", I mean an invisible Kconfig
> > option. This is why I think Vincent's approach is best here, by making
> > the drivers a clearly visible subset of the RX_OFFLOAD option in
> > Kconfig, and RX_OFFLOAD user-selectable.
>
> Sorry for a chunked response, vger becoming unresponsive the week after
> the merge window seems to become a tradition :/
>
> We have a ton of "magical" / hidden Kconfigs in networking, take a look
> at net/Kconfig. Quick grep, likely not very accurate but FWIW:
>
> # not-hidden
> $ git grep -c -E '(bool|tristate)..' net/Kconfig
> net/Kconfig:23
>
> # hidden
> $ git grep -c -E '(bool|tristate)$' net/Kconfig
> net/Kconfig:20

OK. So we have a proposal to make CAN_RX_OFFLOAD an hidden
configuration. I did not consider this approach before because the CAN
subsystem *never* relies on this and I did not really explore other
Kbuild files.
| $ git grep -c -E '(bool|tristate)$' net/can/Kconfig
| <no output>

Before pushing my driver upstream, it was also an out of tree module
for about one year and I relate a lot to what Max said. But Jakub
explanations are consistent and reflect the best practices of the
kernel development.
Also, mainstream distribution would do an allyesconfig and ship the
can-dev.ko with everything built in. So the lambda user would still
have everything built-in.

I will let people continue to comment for a couple of days before
making the final choice and sending the next version. But so far, I am
leading toward Jakub’s idea to make it a hidden feature.

> > How about making RX_OFFLOAD a separate .ko file, so we don't have
> > various possible versions of can_dev.ko?
> >
> > @Vincent, I think you suggested that some time ago, IIRC?
> >
> > (I know, I was against a ton of little modules, but I'm changing my
> > ways here now since it seems to help...)
>
> A separate module wouldn't help with my objections, I don't think.
