Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2EB53FE98
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbiFGMUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243837AbiFGMUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:20:09 -0400
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD964C5E6A;
        Tue,  7 Jun 2022 05:20:05 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id s39so3264111ybi.0;
        Tue, 07 Jun 2022 05:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJl5uDTfeXSgFEAYnHs/jRj0vy7VJnNLGNEZQoMWkYY=;
        b=jNwQEXn4QAM4N2paOiazAh9aXrlU1TB3oJZ/9XV6/lFgZiXdUs5DTRfClZFR0w6kMh
         JFlduPIhDO3OCXgH0m8qovqvuImgRhW1HnTM/VEMklMJbH0yJ4Kj4jbGI54/ncLLaHPB
         Sz7PPYjp5iZEh5w1uya3R2jiPiJObunrK9+JQXgwdfm4EOB37PujZ96r/WUH0M5sp3ri
         br4bjwH7CD8q7wlUP6a+2RNiicW0jbc5DgI5u7x5Lne/yFUdoZ2Jg8v56yeNhJbaiwb/
         qPEXpxo1xIXWlP2CC1SOd7CDD3Mmnyftn2jrE7+GqRzMa36ShJUp34qrvs5ZgcOkYVyo
         RwWA==
X-Gm-Message-State: AOAM531oEV3vK1W0P6uqKNSlZJ74F0rRqQF45Nr0TXLkM7gnvXeNAZNC
        LDZCoQ/EA0C9c4kxoL7DZAbcIfZEn0S3s6ID2kA=
X-Google-Smtp-Source: ABdhPJwkFYxRQqmHTYUNii6VodytnbHMzW38+RWHy5jejauFkRTX5xO+DCxpjkOZ6gOnKW+cpkDgL7SAoZegxI5l2yg=
X-Received: by 2002:a25:9841:0:b0:663:eaf2:4866 with SMTP id
 k1-20020a259841000000b00663eaf24866mr1119907ybo.381.1654604404961; Tue, 07
 Jun 2022 05:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Jun 2022 21:19:54 +0900
Message-ID: <CAMZ6Rq+QpY23bmB4n1DfqaGgxU=i8sKm1Ee9R18xGSv9H5yMVQ@mail.gmail.com>
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
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Max Staudt <max@enpas.org>
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

+CC: Max Staudt <max@enpas.org>

On Tue. 7 Jun. 2022 at 18:47, Dario Binacchi
<dario.binacchi@amarulasolutions.com> wrote:
> This series originated as a result of CAN communication tests for an
> application using the USBtin adapter (https://www.fischl.de/usbtin/).
> The tests showed some errors but for the driver everything was ok.
> Also, being the first time I used the slcan driver, I was amazed that
> it was not possible to configure the bitrate via the ip tool.
> For these two reasons, I started looking at the driver code and realized
> that it didn't use the CAN network device driver interface.
>
> Starting from these assumptions, I tried to:
> - Use the CAN network device driver interface.
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

In his CAN327 driver, Max manages to bring the can0 device without the
need of dedicated user space daemon by using line discipline
(ldattach):
https://lore.kernel.org/linux-can/20220602213544.68273-1-max@enpas.org/

Isn't the same feasible with slcan so that we completely remove the
dependency toward slcand?
Max what do you think of this?

> Now there is a clearer separation between serial line and CAN,
> but above all, it is possible to use the ip and ethtool commands
> as it happens for any CAN device driver. The changes are backward
> compatible, you can continue to use the slcand and slcan_attach
> command options.

Yours sincerely,
Vincent Mailhol
