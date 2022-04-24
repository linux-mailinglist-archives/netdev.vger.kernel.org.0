Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D9950D377
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbiDXQcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbiDXQcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:32:33 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2F69E9E2;
        Sun, 24 Apr 2022 09:29:29 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 7A27F30B2949;
        Sun, 24 Apr 2022 18:28:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:date:from
        :from:message-id:mime-version:reply-to:subject:subject:to:to; s=
        felkmail; bh=rbdws84/pPnNeVWA2UKPTIunpmkpZDaaF/q976N9vt8=; b=psm
        /M+3k0OMSTqMdnVsNJT2Hi+gAtjzK2pIYp2R4A2ozUuMUieIzMBpH37gm9y+CozB
        dQuchbPBwmj5vDgAkGjapPy6uWBtkdnOzhI+oht+DmGoY8Uq8tKBVVUzS+6Jy/KR
        WXqsn2EMSK++0tt83UeDitUzAuCYmB3eXF91ilTU8j6kNlCzTXLfBU9ykBl0PIsU
        yVy2qPB82mmevBnq4Gpr89KTGDeqtRsJ4s+osR+jcUB5DZi81j9eUxrxsPCRop9p
        lIGYJL1ORbrrfPuzAxv+QxctDXeKxE3ITPPd/25ipyHvxVTCiUxb9hptB1HTSRai
        Z3Y/zAibYi1+xasua6Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 04C1230ADC00;
        Sun, 24 Apr 2022 18:28:56 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23OGSteb030890;
        Sun, 24 Apr 2022 18:28:55 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23OGSou2030886;
        Sun, 24 Apr 2022 18:28:50 +0200
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v1 0/4] can: ctucanfd: clenup acoording to the actual rules and documentation linking
Date:   Sun, 24 Apr 2022 18:28:07 +0200
Message-Id: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The minor problems reported by actual checkpatch.pl and patchwork
rules has been resolved at price of disable of some debugging
options used initially to locate FPGA PCIe integration problems.

The CTU CAN FD IP core driver documentation has been linked
into CAN drivers index.

The code has been tested on QEMU with CTU CAN FD IP core
included functional model of PCIe integration.

The Linux net-next CTU CAN FD driver has been tested on real Xilinx
Zynq hardware by Matej Vasilevski even together with his
timestamp support patches. Preparation for public discussion
and mainlining is work in progress.

Jiapeng Chong (2):
  can: ctucanfd: Remove unnecessary print function dev_err()
  can: ctucanfd: Remove unused including <linux/version.h>

Pavel Pisa (2):
  can: ctucanfd: remove PCI module debug parameters and core debug
    statements.
  docs: networking: device drivers: can: add ctucanfd and its author
    e-mail update

 .../can/ctu/ctucanfd-driver.rst               |  2 +-
 .../networking/device_drivers/can/index.rst   |  1 +
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 34 ++-----------------
 drivers/net/can/ctucanfd/ctucanfd_pci.c       | 22 ++++--------
 drivers/net/can/ctucanfd/ctucanfd_platform.c  |  1 -
 5 files changed, 11 insertions(+), 49 deletions(-)

-- 
2.20.1


