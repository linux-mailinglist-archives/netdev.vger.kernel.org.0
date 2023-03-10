Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0916F6B54BA
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjCJWnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjCJWmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:42:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7548F14DA3F
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 14:42:28 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1palQh-0002d9-AB; Fri, 10 Mar 2023 23:41:39 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1palQe-003GqF-FD; Fri, 10 Mar 2023 23:41:36 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1palQd-003uES-O4; Fri, 10 Mar 2023 23:41:35 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Roy Pledge <Roy.Pledge@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Date:   Fri, 10 Mar 2023 23:41:22 +0100
Message-Id: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1698; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=9JhTrjmQKjtQFlUasQrySTFuLZLu/NtOD5qmM4eufeE=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkC7H+eh7sOlGHBG4L1QyBTw+rzQkNoN+qxvPCW eOgwZqzcbSJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZAux/gAKCRDB/BR4rcrs CbK0B/0cW9Eel9XtT+/ciaqOL8Ou4+Z2zYziEPD7ScbF4q+swN4VVcdYcsxqOOR5SiCfeGux/vG nfJ22a6m2IawQ7zblHVSfehklr+v3pYyUgmnGpbO5okqmN/5jUpGzX065Jj5HYNwZAslY6DAflI D5Ck9zcwuJo37fBXnMh2xpLh7KcYnpLZ5pqRB7J21MV8GIG74zP6OK4PeYlRknsbM0JK4bxYke/ tM6VZ35AX9hYDbmv+HLyVdwO4NLT3cOwA+5Jq4gUz+86LDPobXlAeUjXFOBmILtaEfOPHG8f9+Y 3mUfL1lOujCuuV9tHfDxz2xosDkMqNZKtFI0Gu2kAo5I3Wig
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

many bus remove functions return an integer which is a historic
misdesign that makes driver authors assume that there is some kind of
error handling in the upper layers. This is wrong however and returning
and error code only yields an error message.

This series improves the fsl-mc bus by changing the remove callback to
return no value instead. As a preparation all drivers are changed to
return zero before so that they don't trigger the error message.

Best regards
Uwe

Uwe Kleine-König (6):
  bus: fsl-mc: Only warn once about errors on device unbind
  bus: fsl-mc: dprc: Push down error message from fsl_mc_driver_remove()
  bus: fsl-mc: fsl-mc-allocator: Drop if block with always wrong
    condition
  bus: fsl-mc: fsl-mc-allocator: Improve error reporting
  soc: fsl: dpio: Suppress duplicated error reporting on device remove
  bus: fsl-mc: Make remove function return void

 drivers/bus/fsl-mc/dprc-driver.c              | 12 ++++-----
 drivers/bus/fsl-mc/fsl-mc-allocator.c         | 27 ++++++++++---------
 drivers/bus/fsl-mc/fsl-mc-bus.c               |  7 +----
 drivers/crypto/caam/caamalg_qi2.c             |  4 +--
 drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c       |  4 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  4 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-ptp.c  |  4 +--
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  4 +--
 drivers/soc/fsl/dpio/dpio-driver.c            |  8 +-----
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  3 +--
 include/linux/fsl/mc.h                        |  2 +-
 11 files changed, 28 insertions(+), 51 deletions(-)


base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
2.39.1

