Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4CB53FE9F
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbiFGMVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243582AbiFGMVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:21:43 -0400
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC951C5DBD;
        Tue,  7 Jun 2022 05:20:48 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id w2so30835586ybi.7;
        Tue, 07 Jun 2022 05:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpZMM3nIIUg8SAe8O5vBSQaTSRtJGAcQXYQ3T0pf1NQ=;
        b=7N9KlPz1+u3IKG8y0tWAogfbqNchVdAVjUxWOr6piBciSI3brlYpNEBG2OROWyWh8L
         2n4XkeAoeeo/qLADsi1zv2KQVwElY/IR9+455n2Y1vOoRGvWJ+h7I8E1nZ8kHSy9ntKR
         9uFR+GjhpdsJPxMRRqRn+D1JcENiex1+afbGlEXkoY8kpis1BE/qUbUuFl49sv8HDbyT
         XlYlCqh4c2d5k1iioJGYzhQ0Q3ANjj+a2lmpp1+7Z2j33nB8GvyLgt0PUo6fAaIdI/w2
         lV9HEibr47U40FvBOBNTKEn0oGkPrdVUNSBBdcRKv1SCN2s67MTLhEvHNdKAazIc0iN3
         L/bQ==
X-Gm-Message-State: AOAM532SJ+NrhVeL+sfzcT1gE5MbPdlVka90Ennl3LbRBEyU0XDJxvJE
        4vHv1gMvgpAUz/xHkhC+wln2o5Sk0NlL41T2usE=
X-Google-Smtp-Source: ABdhPJy7JbRPJ+kyEBxwBQ0h03CKHs4s0yzfq7fFavfnLZyLDYAcMebORrDsmuSgoFJc7oG18sfBfS6wYgkFsfGxJ5w=
X-Received: by 2002:a25:6588:0:b0:65d:57b9:c470 with SMTP id
 z130-20020a256588000000b0065d57b9c470mr30465552ybb.142.1654604447877; Tue, 07
 Jun 2022 05:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <CAMZ6RqLNq2tQjjJudSZ5c_fJ2VR9cX5ihjhhuNszm4wG-DgLfw@mail.gmail.com> <20220607103923.5m6j4rykvitofsv4@pengutronix.de>
In-Reply-To: <20220607103923.5m6j4rykvitofsv4@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Jun 2022 21:20:36 +0900
Message-ID: <CAMZ6RqJt8dBrYe+DdOKoVSpak8-5qi7B1vwT2wpe16H+29Ay=g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] can: slcan: extend supported features
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
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

On Tue. 7 Jun 2022 at 19:39, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 07.06.2022 19:27:05, Vincent MAILHOL wrote:
> > On Tue. 7 juin 2022 at 18:47, Dario Binacchi
> > <dario.binacchi@amarulasolutions.com> wrote:
> > > This series originated as a result of CAN communication tests for an
> > > application using the USBtin adapter (https://www.fischl.de/usbtin/).
> > > The tests showed some errors but for the driver everything was ok.
> > > Also, being the first time I used the slcan driver, I was amazed that
> > > it was not possible to configure the bitrate via the ip tool.
> > > For these two reasons, I started looking at the driver code and realized
> > > that it didn't use the CAN network device driver interface.
> >
> > That's funny! Yesterday, I sent this comment:
> > https://lore.kernel.org/linux-can/CAMZ6RqKZwC_OKcgH+WPacY6kbNbj4xR2Gdg2NQtm5Ka5Hfw79A@mail.gmail.com/
> >
> > And today, you send a full series to remove all the dust from the
> > slcan driver. Do I have some kind of mystical power to summon people
> > on the mailing list?
>
> That would be very useful and awesome super power, I'm a bit jealous. :D
>
> > > Starting from these assumptions, I tried to:
> > > - Use the CAN network device driver interface.
> >
> > In order to use the CAN network device driver, a.k.a. can-dev module,
> > drivers/net/can/Kbuild has to be adjusted: move slcan inside CAN_DEV
> > scope.
> >
> > @Mark: because I will have to send a new version for my can-dev/Kbuild
> > cleanup, maybe I can take that change and add it to my series?
>
> Let's get the your Kconfig/Makefile changes into can-next/master first.
> Then Dario can then base this series on that branch.

ACK. I'll keep my series as-is.
