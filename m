Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7101254684A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiFJOai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbiFJOag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:36 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D2B62E0;
        Fri, 10 Jun 2022 07:30:35 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id r1so5668056plo.10;
        Fri, 10 Jun 2022 07:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/mjtA9MLjpbHOH3mFEMMpFyEg+q0nrj1i3jXYc4/cy0=;
        b=kf552z2RLbozvVb/HnIWAXj5mQ9L2bbOg50xc+8aPxezVhZNWNBw9+UxJdgFzAClpj
         8p6T5frqptElPXLuTR8l+B9OLDiXxGp6vVd643oVrW7A3ssSN6mB6UXaZxkvV29a+ok4
         R56+OGTCRaI1nkA3piurWJMAIre+LqHMWc4mHNge4/UxnV58rcLvLKlqETMLntPbDHHL
         Kl9j8YSEn10OZAlKZONuLmvsIB222DKcg1fh6ZgdDmlZlAps5cfEgjXjQduAaQr+KhJ8
         59bbhR0kmT8TYQEOHMIi6ebV1FAi2L5ty/lUE7VlkEOqlvjhOCyYMZgQUtdUUWaELN0g
         +CcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=/mjtA9MLjpbHOH3mFEMMpFyEg+q0nrj1i3jXYc4/cy0=;
        b=vIVRBgD6fHdGwnJ3fdLrPMHqFBWB6D1+gy9ptZ/4vvtYzSAztMynHGQuk1hmlhPN3H
         sUO18ckX5API5ZFK6q1dXdalQ/sW+l0yhuaHlAUIyVal3zKHlqx+JrLCz9YvYM1gZw+A
         e44CfBJzGavw8eQqL7VxTGiIpc65xyXV9j6TjNiAamy2LRMIlVMGqdnHeGAFdGwBRQ1F
         NrFzJzQt7IaCcyq26tE5rSP0sm1Yd6fdGzvp6hOBjnHZuygRDD6xdQAxjqYjhoLJSVEN
         B/huxpz+2ZA6n4HLJCL04Qf+AMqVsypXgqeLQKKj65j4VY7qn1pE4mwfaGmzvkloKP1Y
         O3BQ==
X-Gm-Message-State: AOAM533xT7uiQyvR4fV7gTgAp3F8toCQtt+XReHH/9RWYruPgpDR/+S6
        Qbl3bCef7iAFuUQ+EnXNcs5N+R/03qhJ+A==
X-Google-Smtp-Source: ABdhPJzjuYHAMdTge3IJvoeI8We4lcS6sC8AyHf6aJj1MLj/WyEiFyb+lJ1luGQkCn/Dz9l01ADGwg==
X-Received: by 2002:a17:90a:a096:b0:1df:58d7:5b20 with SMTP id r22-20020a17090aa09600b001df58d75b20mr54234pjp.212.1654871434516;
        Fri, 10 Jun 2022 07:30:34 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:33 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 0/7] can: refactoring of can-dev module and of Kbuild
Date:   Fri, 10 Jun 2022 23:30:02 +0900
Message-Id: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aside of calc_bittiming.o which can be configured with
CAN_CALC_BITTIMING, all objects from drivers/net/can/dev/ get linked
unconditionally to can-dev.o even if not needed by the user.

This series first goal it to split the can-dev modules so that the
only the needed features get built in during compilation.
Additionally, the CAN Device Drivers menu is moved from the
"Networking support" category to the "Device Drivers" category (where
all drivers are supposed to be).


* menu before this series *

CAN bus subsystem support
  symbol: CONFIG_CAN
  |
  +-> CAN Device Drivers
      (no symbol)
      |
      +-> software/virtual CAN device drivers
      |   (at time of writing: slcan, vcan, vxcan)
      |
      +-> Platform CAN drivers with Netlink support
          symbol: CONFIG_CAN_DEV
          |
          +-> CAN bit-timing calculation  (optional for hardware drivers)
          |   symbol: CONFIG_CAN_CALC_BITTIMING
          |
          +-> All other CAN devices drivers

* menu after this series *

Network device support
  symbol: CONFIG_NETDEVICES
  |
  +-> CAN Device Drivers
      symbol: CONFIG_CAN_DEV
      |
      +-> software/virtual CAN device drivers
      |   (at time of writing: slcan, vcan, vxcan)
      |
      +-> CAN device drivers with Netlink support
          symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
          |
          +-> CAN bit-timing calculation (optional for all drivers)
          |   symbol: CONFIG_CAN_CALC_BITTIMING
          |
          +-> All other CAN devices drivers
              (some may select CONFIG_CAN_RX_OFFLOAD)
              |
              +-> CAN rx offload (automatically selected by some drivers)
                  (hidden symbol: CONFIG_CAN_RX_OFFLOAD)

Patches 1 to 5 of this series do above modification.

The last two patches add a check toward CAN_CTRLMODE_LISTENONLY in
can_dropped_invalid_skb() to discard tx skb (such skb can potentially
reach the driver if injected via the packet socket). In more details,
patch 6 moves can_dropped_invalid_skb() from skb.h to skb.o and patch
7 is the actual change.

Those last two patches are actually connected to the first five ones:
because slcan and v(x)can requires can_dropped_invalid_skb(), it was
necessary to add those three devices to the scope of can-dev before
moving the function to skb.o.

This design results from the lengthy discussion in [1].

[1] https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/


** Changelog **

v5 -> v6:

  * fix typo in patch #1's title: Kbuild -> Kconfig.

  * make CONFIG_RX_CAN an hidden config symbol and modify the diagram
    in the cover letter accordingly.

    @Oliver, with CONFIG_CAN_RX_OFFLOAD now being an hidden config,
    that option fully depends on the drivers. So contrary to your
    suggestion, I put CONFIG_CAN_RX_OFFLOAD below the device drivers
    in the diagram.

  * fix typo in cover letter: CONFIG_CAN_BITTIMING -> CONFIG_CAN_CALC_BITTIMING.

v4 -> v5:

  * m_can is also requires RX offload. Add the "select CAN_RX_OFFLOAD"
    to its Makefile.

  * Reorder the lines of drivers/net/can/dev/Makefile.

  * Remove duplicated rx-offload.o target in drivers/net/can/dev/Makefile

  * Remove the Nota Bene in the cover letter.


v3 -> v4:

  * Five additional patches added to split can-dev module and refactor
    Kbuild. c.f. below (lengthy) thread:
    https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/


v2 -> v3:

  * Apply can_dropped_invalid_skb() to slcan.

  * Make vcan, vxcan and slcan dependent of CONFIG_CAN_DEV by
    modifying Kbuild.

  * fix small typos.

v1 -> v2:

  * move can_dropped_invalid_skb() to skb.c instead of dev.h

  * also move can_skb_headroom_valid() to skb.c

Vincent Mailhol (7):
  can: Kconfig: rename config symbol CAN_DEV into CAN_NETLINK
  can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using
    CAN_DEV
  can: bittiming: move bittiming calculation functions to
    calc_bittiming.c
  can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
  net: Kconfig: move the CAN device menu to the "Device Drivers" section
  can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid()
    to skb.c
  can: skb: drop tx skb if in listen only mode

 drivers/net/Kconfig                   |   2 +
 drivers/net/can/Kconfig               |  55 +++++--
 drivers/net/can/dev/Makefile          |  17 ++-
 drivers/net/can/dev/bittiming.c       | 197 -------------------------
 drivers/net/can/dev/calc_bittiming.c  | 202 ++++++++++++++++++++++++++
 drivers/net/can/dev/dev.c             |   9 +-
 drivers/net/can/dev/skb.c             |  72 +++++++++
 drivers/net/can/m_can/Kconfig         |   1 +
 drivers/net/can/spi/mcp251xfd/Kconfig |   1 +
 include/linux/can/skb.h               |  59 +-------
 net/can/Kconfig                       |   5 +-
 11 files changed, 338 insertions(+), 282 deletions(-)
 create mode 100644 drivers/net/can/dev/calc_bittiming.c

-- 
2.35.1

