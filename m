Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9630B53D6EB
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 15:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiFDNFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiFDNFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 09:05:22 -0400
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A6C517D0;
        Sat,  4 Jun 2022 06:05:21 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-30fa61b1a83so100470347b3.0;
        Sat, 04 Jun 2022 06:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+bJg133VzTr840Ej01ygsEXox3ooYZgtindEMoofCgA=;
        b=z4ER0C3ra/pWRhGze37mX5PHeW3morCjwfNNLEhHQ5OzhM1a3DeNOZ2ytb33hbkppN
         F/dCkCK7CIf/Z7Tup5D2ARmdqngJfHVM2EWLotvT8P+JsvMEdwXuHU//+7oOxHXl0fcU
         jL71BupOjr3jQ+6cLmFT+YoPsLQhe748d+pxM7zBXaK8TJaEHwItwV/EGSRALjuiE7JU
         bGA34xg2T5iOwZx3YBAQn+8HL9WuQcgt4pUPk9ER/Lrjb4X+Z//Q63v9rJ/0dHp1HJQG
         9S1lg/wAjNWHRrN2gmVcZ1f0Am4KBviDiwJJRsj4HsKuhHUET7Qbg3hN1PZNSFy7V4kW
         EPnQ==
X-Gm-Message-State: AOAM53084wRbV+x5u8lctPjpJyL92IeooqZRN2JLRem7ZzxkOKnTqyyj
        WeRX3Q+iB5zYGmhRFq/jzncLiDhkxBGXBaZwRaU6TO6LcfO4Wg==
X-Google-Smtp-Source: ABdhPJwYIjs+Me6pyYvlBoSJq2e/R0RU2S21TDiiX+WJ4LL3xGMFd39j6X/j499UDcl6oQoqG9eTqVLyCR+fW94WpHw=
X-Received: by 2002:a81:2dc5:0:b0:2f5:c6c8:9ee5 with SMTP id
 t188-20020a812dc5000000b002f5c6c89ee5mr16469638ywt.518.1654347920570; Sat, 04
 Jun 2022 06:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
In-Reply-To: <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 4 Jun 2022 22:05:09 +0900
Message-ID: <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
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

On Sat. 4 juin 2022 at 20:46, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> Hello Vincent,
>
> wow! This is a great series which addresses a lot of long outstanding
> issues. Great work!

Thanks.

> As this cover letter brings so much additional information I'll ask
> Jakub and David if they take pull request from me, which itself have
> merges. This cover letter would be part of my merge. If I get the OK,
> can you provide this series as a tag (ideally GPG signed) that I can
> pull?

Fine, but I need a bit of guidance here. To provide a tag, I need to
have my own git repository hosted online, right? Is GitHub OK or
should I create one on https://git.kernel.org/?

> regards,
> Marc
>
> On 03.06.2022 19:28:41, Vincent Mailhol wrote:
> > Aside of calc_bittiming.o which can be configured with
> > CAN_CALC_BITTIMING, all objects from drivers/net/can/dev/ get linked
> > unconditionally to can-dev.o even if not needed by the user.
> >
> > This series first goal it to split the can-dev modules so that the
> > user can decide which features get built in during
> > compilation. Additionally, the CAN Device Drivers menu is moved from
> > the "Networking support" category to the "Device Drivers" category
> > (where all drivers are supposed to be).
> >
> > Below diagrams illustrate the changes made.
> > The arrow symbol "x --> y" denotes that "y depends on x".
> >
> > * menu before this series *
> >
> > CAN bus subsystem support
> >   symbol: CONFIG_CAN
> >   |
> >   +-> CAN Device Drivers
> >       (no symbol)
> >       |
> >       +-> software/virtual CAN device drivers
> >       |   (at time of writing: slcan, vcan, vxcan)
> >       |
> >       +-> Platform CAN drivers with Netlink support
> >           symbol: CONFIG_CAN_DEV
> >         |
> >           +-> CAN bit-timing calculation  (optional for hardware drivers)
> >           |   symbol: CONFIG_CAN_BITTIMING
> >         |
> >         +-> All other CAN devices
> >
> > * menu after this series *
> >
> > Network device support
> >   symbol: CONFIG_NETDEVICES
> >   |
> >   +-> CAN Device Drivers
> >       symbol: CONFIG_CAN_DEV
> >       |
> >       +-> software/virtual CAN device drivers
> >       |   (at time of writing: slcan, vcan, vxcan)
> >       |
> >       +-> CAN device drivers with Netlink support
> >           symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
> >           |
> >           +-> CAN bit-timing calculation (optional for all drivers)
> >           |   symbol: CONFIG_CAN_BITTIMING
> >         |
> >         +-> All other CAN devices not relying on RX offload
> >           |
> >           +-> CAN rx offload
> >               symbol: CONFIG_CAN_RX_OFFLOAD
> >               |
> >               +-> CAN devices relying on rx offload
> >                   (at time of writing: flexcan, ti_hecc and mcp251xfd)
> >
> > Patches 1 to 5 of this series do above modification.
> >
> > The last two patches add a check toward CAN_CTRLMODE_LISTENONLY in
> > can_dropped_invalid_skb() to discard tx skb (such skb can potentially
> > reach the driver if injected via the packet socket). In more details,
> > patch 6 moves can_dropped_invalid_skb() from skb.h to skb.o and patch
> > 7 is the actual change.
> >
> > Those last two patches are actually connected to the first five ones:
> > because slcan and v(x)can requires can_dropped_invalid_skb(), it was
> > necessary to add those three devices to the scope of can-dev before
> > moving the function to skb.o.
> >
> >
> > ** N.B. **
> >
> > This design results from the lengthy discussion in [1].
> >
> > I did one change from Oliver's suggestions in [2]. The initial idea
> > was that the first two config symbols should be respectively
> > CAN_DEV_SW and CAN_DEV instead of CAN_DEV and CAN_NETLINK as proposed
> > in this series.
> >
> >   * First symbol is changed from CAN_DEV_SW to CAN_DEV. The rationale
> >     is that it is this entry that will trigger the build of can-dev.o
> >     and it makes more sense for me to name the symbol share the same
> >     name as the module. Furthermore, this allows to create a menuentry
> >     with an explicit name that will cover both the virtual and
> >     physical devices (naming the menuentry "CAN Device Software" would
> >     be inconsistent with the fact that physical devices would also be
> >     present in a sub menu). And not using menuentry complexifies the
> >     menu.
> >
> >   * Second symbol is renamed from CAN_DEV to CAN_NETLINK because
> >     CAN_DEV is now taken by the previous menuconfig and netlink is the
> >     predominant feature added at this level. I am opened to other
> >     naming suggestion (CAN_DEV_NETLINK, CAN_DEV_HW...?).
> >
> > [1] https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/
> > [2] https://lore.kernel.org/linux-can/22590a57-c7c6-39c6-06d5-11c6e4e1534b@hartkopp.net/
> >
> >
> > ** Changelog **
> >
> > v3 -> v4:
> >
> >   * Five additional patches added to split can-dev module and refactor
> >     Kbuild. c.f. below (lengthy) thread:
> >     https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/
> >
> >
> > v2 -> v3:
> >
> >   * Apply can_dropped_invalid_skb() to slcan.
> >
> >   * Make vcan, vxcan and slcan dependent of CONFIG_CAN_DEV by
> >     modifying Kbuild.
> >
> >   * fix small typos.
> >
> > v1 -> v2:
> >
> >   * move can_dropped_invalid_skb() to skb.c instead of dev.h
> >
> >   * also move can_skb_headroom_valid() to skb.c
> >
> > Vincent Mailhol (7):
> >   can: Kbuild: rename config symbol CAN_DEV into CAN_NETLINK
> >   can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using
> >     CAN_DEV
> >   can: bittiming: move bittiming calculation functions to
> >     calc_bittiming.c
> >   can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
> >   net: Kconfig: move the CAN device menu to the "Device Drivers" section
> >   can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid()
> >     to skb.c
> >   can: skb: drop tx skb if in listen only mode
> >
> >  drivers/net/Kconfig                   |   2 +
> >  drivers/net/can/Kconfig               |  66 +++++++--
> >  drivers/net/can/dev/Makefile          |  20 ++-
> >  drivers/net/can/dev/bittiming.c       | 197 -------------------------
> >  drivers/net/can/dev/calc_bittiming.c  | 202 ++++++++++++++++++++++++++
> >  drivers/net/can/dev/dev.c             |   9 +-
> >  drivers/net/can/dev/skb.c             |  72 +++++++++
> >  drivers/net/can/spi/mcp251xfd/Kconfig |   1 +
> >  include/linux/can/skb.h               |  59 +-------
> >  net/can/Kconfig                       |   5 +-
> >  10 files changed, 351 insertions(+), 282 deletions(-)
> >  create mode 100644 drivers/net/can/dev/calc_bittiming.c
> >
> > --
> > 2.35.1
> >
> >
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
