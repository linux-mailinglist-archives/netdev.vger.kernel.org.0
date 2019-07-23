Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFAB7231E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfGWXfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:35:08 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:57313 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfGWXfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:35:08 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2C381886BF;
        Wed, 24 Jul 2019 11:35:05 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1563924905;
        bh=Nzps3/SY5bbhyY3INK4FUpJb1QUR3fJTW8PvT9B4cO8=;
        h=From:To:Cc:Subject:Date;
        b=ZCkteSMtpWGPDy0qHieIxu71kkVRyyk5ScITlCo2nHKzWsr16OBiohSuads9QIM0U
         ET6n/lh7t+hse82TeWAMJG17+VY+VU6gZjJgBfIDK9EqBSfM6Z/2EGkBOgCMrOK+Wp
         HAjCoj/KC7iIFyT/FIdToN7HhenQ75pABPGh8YAmUAsZTCIZnSMQhqeAoOVZaEaSVl
         hEYLNsM70FLsNuwVl33mxMDCViuK/xPgAN+oc7qX2Q5pA9dg0rtIqUO6jzIrXt1Sp1
         plJxZ8E1HuqbQlFFmbNOb2lryM+nAAcj/mjJwO8nhBGNNlHwdaJqRff5PAtoqhwB0j
         sE4SYwo4WZ7tA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d3799a70000>; Wed, 24 Jul 2019 11:35:03 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by smtp (Postfix) with ESMTP id F302213EECE;
        Wed, 24 Jul 2019 11:35:06 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id E781D1E04FD; Wed, 24 Jul 2019 11:35:04 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     madalin.bucur@nxp.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] fsl/fman: Remove comment referring to non-existent function
Date:   Wed, 24 Jul 2019 11:35:01 +1200
Message-Id: <20190723233501.6626-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fm_set_max_frm() existed in the Freescale SDK as a callback for an
early_param. When this code was ported to the upstream kernel the
early_param was converted to a module_param making the reference to the
function incorrect. The rest of the comment already does a good job of
explaining the parameter so removing the reference to the non-existent
function seems like the best thing to do.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 drivers/net/ethernet/freescale/fman/fman.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/eth=
ernet/freescale/fman/fman.c
index e80fedb27cee..210749bf1eac 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -2439,9 +2439,6 @@ MODULE_PARM_DESC(fsl_fm_rx_extra_headroom, "Extra h=
eadroom for Rx buffers");
  * buffers when not using jumbo frames.
  * Must be large enough to accommodate the network MTU, but small enough
  * to avoid wasting skb memory.
- *
- * Could be overridden once, at boot-time, via the
- * fm_set_max_frm() callback.
  */
 static int fsl_fm_max_frm =3D FSL_FM_MAX_FRAME_SIZE;
 module_param(fsl_fm_max_frm, int, 0);
--=20
2.22.0

