Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA850D383
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbiDXQdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbiDXQdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:33:05 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D251387CC;
        Sun, 24 Apr 2022 09:29:52 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id E4D5D30B294D;
        Sun, 24 Apr 2022 18:29:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:date:from
        :from:in-reply-to:message-id:mime-version:references:reply-to
        :subject:subject:to:to; s=felkmail; bh=Zr3Qv3Zv3/VJFk8INMY5q9Y7n
        rTZKr/VLSHwuBvEgPo=; b=aalBB/VHfOJeLyhDVnXVWQbYPphbq5rqrxm0FavLp
        u+TegexIZrP3IWOdsL3QXnllxuOJl04QQFhbQTygbqD6VvDQcVWlUfwKG2L5pH8h
        X+7AA7JrYdhBqV/Oml5JjNe7QhXac3U0dvVuGvQeYcUuDDoffm2/RFk1gGFz+LbE
        pp/0yN3htPdbr4EzUGsb/trPH8Sz5nsubtWCqSILwf92CjIS2yNeTM0ImB1T8UzG
        CH072vEByqgO03kA3E81DdEFGQLKp+vPOxZaZmnUMLRUFbCxIgsaP+74cSfUlkKy
        h8apZOPCxD96OYYSqeFGi5BvAx83Nv2kAmJh4ivPqpUpA==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 7FDFB30ADC00;
        Sun, 24 Apr 2022 18:29:50 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23OGTolT030986;
        Sun, 24 Apr 2022 18:29:50 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23OGToDZ030985;
        Sun, 24 Apr 2022 18:29:50 +0200
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
Subject: [PATCH v1 4/4] docs: networking: device drivers: can: add ctucanfd and its author e-mail update
Date:   Sun, 24 Apr 2022 18:28:11 +0200
Message-Id: <e4396244da6b008c671def9f50bb983a10389863.1650816929.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
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

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 .../networking/device_drivers/can/ctu/ctucanfd-driver.rst       | 2 +-
 Documentation/networking/device_drivers/can/index.rst           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 797fb45be187..2fde5551e756 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -536,7 +536,7 @@ CTU CAN FD Driver Sources Reference
 CTU CAN FD IP Core and Driver Development Acknowledgment
 ---------------------------------------------------------
 
-* Odrej Ille <illeondr@fel.cvut.cz>
+* Odrej Ille <ondrej.ille@gmail.com>
 
   * started the project as student at Department of Measurement, FEE, CTU
   * invested great amount of personal time and enthusiasm to the project over years
diff --git a/Documentation/networking/device_drivers/can/index.rst b/Documentation/networking/device_drivers/can/index.rst
index 58b6e0ad3030..0c3cc6633559 100644
--- a/Documentation/networking/device_drivers/can/index.rst
+++ b/Documentation/networking/device_drivers/can/index.rst
@@ -10,6 +10,7 @@ Contents:
 .. toctree::
    :maxdepth: 2
 
+   ctu/ctucanfd-driver
    freescale/flexcan
 
 .. only::  subproject and html
-- 
2.20.1


