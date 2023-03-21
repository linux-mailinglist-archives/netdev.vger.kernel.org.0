Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58D66C36BC
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCUQP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjCUQPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:15:35 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4524D2AE
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:15:17 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.187.55])
        by andre.telenet-ops.be with bizsmtp
        id b4F32900A1C8whw014F35Q; Tue, 21 Mar 2023 17:15:03 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1peecv-00EAjz-GP;
        Tue, 21 Mar 2023 17:15:03 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1peedb-00B9By-5X;
        Tue, 21 Mar 2023 17:15:03 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 0/2] can: rcar_canfd: Add transceiver support
Date:   Tue, 21 Mar 2023 17:14:59 +0100
Message-Id: <cover.1679414936.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

This patch series adds transceiver support to the Renesas R-Car CAN-FD
driver, and improves the printing of error messages, as requested by
Vincent.

Originally, both patches were submitted separately, but as the latter
depends on the former, I absorbed it within this series for the resend.

Thanks!

Geert Uytterhoeven (2):
  can: rcar_canfd: Add transceiver support
  can: rcar_canfd: Improve error messages

 drivers/net/can/rcar/rcar_canfd.c | 71 ++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 26 deletions(-)

-- 
2.34.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
