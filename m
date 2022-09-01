Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4FC5A943C
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiIAKW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiIAKWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:22:25 -0400
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB53013608B;
        Thu,  1 Sep 2022 03:22:23 -0700 (PDT)
Received: by mail-qk1-f181.google.com with SMTP id c9so12823092qkk.6;
        Thu, 01 Sep 2022 03:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=SoW9HnsZJkbcsG3RktqGcPg2MNXcaYIQ7LfyNCFqvLI=;
        b=oh37PccD3ZAAJpPxxRTvpTpIRD6rGQzkH5jmVx3zLNjdFIXSmITHgAOlCL9Tk2dieS
         oTVmZaYSpz59mtFdrXl1NKup4+PV7zO70hlgHR8ZQV1criLPIwJ8yhuXAAlW6n3Ka3Ix
         IFVDN0fageac7kYx+q/t++ci0xRmM7wAfEVhPwOpkz1jP1QiT5VZon+CBXLmim/DHagn
         ERVuaO7caNHeoEa0zDzXSyOZ+WFz42+Q0kFmbS8tzHcGnIkjfV3OVpsLQOucBdSJf0PJ
         48KDPsSe11aiPP43GxZJ8+yfjhlW7k/HQh8Ra73w1PPfYFc0N684zwiRj41J9wouuOhS
         rMGw==
X-Gm-Message-State: ACgBeo1vcLAQTcizppuyvdAJQ1XoUpQodyTk23EDIBD8pn6+kfX61Y7J
        m0WQpcE9IKBWeRT2iEQ409qxNmJHs45QVw==
X-Google-Smtp-Source: AA6agR7zsL1+sbg2g+lOb5Keu8r6RrPlkUVQQQnq7xR1F4nHX63ppkYmaA0StwTzut0kdkaFsOtznQ==
X-Received: by 2002:a37:a9d8:0:b0:6ba:be20:48e2 with SMTP id s207-20020a37a9d8000000b006babe2048e2mr18330969qke.301.1662027742459;
        Thu, 01 Sep 2022 03:22:22 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id hf11-20020a05622a608b00b00344b807bb95sm9816703qtb.74.2022.09.01.03.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 03:22:21 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id g5so7934662ybg.11;
        Thu, 01 Sep 2022 03:22:21 -0700 (PDT)
X-Received: by 2002:a25:415:0:b0:696:814:7c77 with SMTP id 21-20020a250415000000b0069608147c77mr18706967ybe.36.1662027741095;
 Thu, 01 Sep 2022 03:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220830164518.1381632-1-biju.das.jz@bp.renesas.com> <20220830164518.1381632-2-biju.das.jz@bp.renesas.com>
In-Reply-To: <20220830164518.1381632-2-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 1 Sep 2022 12:22:10 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVbgybWfmUOwyDrP7M0Drcr3okfKNEwm1kAoPNfbQEJMA@mail.gmail.com>
Message-ID: <CAMuHMdVbgybWfmUOwyDrP7M0Drcr3okfKNEwm1kAoPNfbQEJMA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document RZ/N1
 power-domains support
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 6:45 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> Document RZ/N1 power-domains support. Also update the example with
> power-domains property.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3:
>  * Documented power-domains support.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
