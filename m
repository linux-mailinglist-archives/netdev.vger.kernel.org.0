Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4D53FB29
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240973AbiFGK1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiFGK1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:27:19 -0400
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CB6C29;
        Tue,  7 Jun 2022 03:27:17 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-30fa61b1a83so164886487b3.0;
        Tue, 07 Jun 2022 03:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SW76TWICctgjJctTa+dyak49A3AOcc7XLFtXuzyipso=;
        b=6FEMhIL+6E20YFtx57e57Kmj6RNqC92G6La0rbS8B20upnxKoJBJHLqs3px0mI0a0F
         B5/uf8H9woK5C8hlPMWbh0nrJzzWptCDZnFLsBCXCri+7PkdN+YNRIRV+N040g0vYRys
         Ot6KJsNxrm2OSACWCMAj4GiLdl+COOEr2S8G/3k+PvDhlvY+WSDswe4gGnicJISlHKlF
         V2AjlMrVe2omkdSaplR73Es/eWvC9ekM8V5VD9TCCBIWGYGdYLX35E0rsQrg2M1KpMIT
         bRqeEzBnBIayMQsG75Icx6imaMn3mx1fD7TK2ljuRBWX/yoKwvE5BY539RY9oX1ewCuR
         ihjg==
X-Gm-Message-State: AOAM530PBUmumOuo+AS6PC4hBa5crxet8NX1TEl6AKTKVz+zzRQtmA4W
        sAiPN/AO5rwOfQVKQ2MeSwgeUTayoAYNxnqn/ZA=
X-Google-Smtp-Source: ABdhPJxfOYg3dDzULfiTsTYRdV+bdsjmA1KGeJJ/BCdZygPnnAyVZ9I5vsGUcMj3BqTo0Ilbc+UXVaM6rJwiDS7dVvs=
X-Received: by 2002:a81:1845:0:b0:30c:b463:cff3 with SMTP id
 66-20020a811845000000b0030cb463cff3mr30511932ywy.45.1654597636787; Tue, 07
 Jun 2022 03:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Jun 2022 19:27:05 +0900
Message-ID: <CAMZ6RqLNq2tQjjJudSZ5c_fJ2VR9cX5ihjhhuNszm4wG-DgLfw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] can: slcan: extend supported features
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
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

On Tue. 7 juin 2022 at 18:47, Dario Binacchi
<dario.binacchi@amarulasolutions.com> wrote:
> This series originated as a result of CAN communication tests for an
> application using the USBtin adapter (https://www.fischl.de/usbtin/).
> The tests showed some errors but for the driver everything was ok.
> Also, being the first time I used the slcan driver, I was amazed that
> it was not possible to configure the bitrate via the ip tool.
> For these two reasons, I started looking at the driver code and realized
> that it didn't use the CAN network device driver interface.

That's funny! Yesterday, I sent this comment:
https://lore.kernel.org/linux-can/CAMZ6RqKZwC_OKcgH+WPacY6kbNbj4xR2Gdg2NQtm5Ka5Hfw79A@mail.gmail.com/

And today, you send a full series to remove all the dust from the
slcan driver. Do I have some kind of mystical power to summon people
on the mailing list?

> Starting from these assumptions, I tried to:
> - Use the CAN network device driver interface.

In order to use the CAN network device driver, a.k.a. can-dev module,
drivers/net/can/Kbuild has to be adjusted: move slcan inside CAN_DEV
scope.

@Mark: because I will have to send a new version for my can-dev/Kbuild
cleanup, maybe I can take that change and add it to my series?

> - Set the bitrate via the ip tool.
> - Send the open/close command to the adapter from the driver.
> - Add ethtool support to reset the adapter errors.
> - Extend the protocol to forward the adapter CAN communication
>   errors and the CAN state changes to the netdev upper layers.
>
> Except for the protocol extension patches (i. e. forward the adapter CAN
> communication errors and the CAN state changes to the netdev upper
> layers), the whole series has been tested. Testing the extension
> protocol patches requires updating the adapter firmware. Before modifying
> the firmware I think it makes sense to know if these extensions can be
> considered useful.
>
> Before applying the series I used these commands:
>
> slcan_attach -f -s6 -o /dev/ttyACM0
> slcand ttyACM0 can0
> ip link set can0 up
>
> After applying the series I am using these commands:
>
> slcan_attach /dev/ttyACM0
> slcand ttyACM0 can0
> ip link set dev can0 down
> ip link set can0 type can bitrate 500000
> ethtool --set-priv-flags can0 err-rst-on-open on
> ip link set dev can0 up
>
> Now there is a clearer separation between serial line and CAN,
> but above all, it is possible to use the ip and ethtool commands
> as it happens for any CAN device driver. The changes are backward
> compatible, you can continue to use the slcand and slcan_attach
> command options.
>
>
>
> Dario Binacchi (13):
>   can: slcan: use the BIT() helper
>   can: slcan: use netdev helpers to print out messages
>   can: slcan: use the alloc_can_skb() helper
>   can: slcan: use CAN network device driver API
>   can: slcan: simplify the device de-allocation
>   can: slcan: allow to send commands to the adapter
>   can: slcan: set bitrate by CAN device driver API
>   can: slcan: send the open command to the adapter
>   can: slcan: send the close command to the adapter
>   can: slcan: move driver into separate sub directory
>   can: slcan: add ethtool support to reset adapter errors
>   can: slcan: extend the protocol with error info
>   can: slcan: extend the protocol with CAN state info
>
>  drivers/net/can/Makefile                      |   2 +-
>  drivers/net/can/slcan/Makefile                |   7 +
>  .../net/can/{slcan.c => slcan/slcan-core.c}   | 464 +++++++++++++++---
>  drivers/net/can/slcan/slcan-ethtool.c         |  65 +++
>  drivers/net/can/slcan/slcan.h                 |  18 +
>  5 files changed, 480 insertions(+), 76 deletions(-)
>  create mode 100644 drivers/net/can/slcan/Makefile
>  rename drivers/net/can/{slcan.c => slcan/slcan-core.c} (67%)
>  create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
>  create mode 100644 drivers/net/can/slcan/slcan.h
