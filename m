Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52EB3433CF
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhCURjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:39:53 -0400
Received: from mx4.wp.pl ([212.77.101.12]:54646 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhCURjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 13:39:40 -0400
Received: (wp-smtpd smtp.wp.pl 21603 invoked from network); 21 Mar 2021 18:39:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1616348377; bh=BdtRDVuiasuVzxbP32z5zPbvtxfC/778wyytwcmZPZw=;
          h=From:To:Cc:Subject;
          b=HQ6Cg3kPALMPDhK9sFpdnN9ZfCiFG92gczrZT0IrY2d31aFAz2XZ9Zrv+EQVKdaK7
           i6KK+2EXERVyEjuWT5T7QWJskj3ZdrevOMpdY/GJSnGPeJHa0JEi4kz2ABbas0K+8G
           fRJFCAEGLIF9fxx03Ls91ZJgeea16pHIxxhZauQs=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 21 Mar 2021 18:39:37 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
Subject: [PATCH v3 0/3] net: dsa: lantiq: add support for xRX300 and xRX330
Date:   Sun, 21 Mar 2021 18:39:19 +0100
Message-Id: <20210321173922.2837-1-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 8d9e0a0ee829500b50475ff81994295e
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [gVLR]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>

Changed since v2:
	* fixed compilation warnings
	* removed example bindings for xrx330
	* patches has been refactored due to upstream changes

Changed since v1:
	* gswip_mii_mask_cfg() can now change port 3 on xRX330
	* changed alowed modes on port 0 and 5 for xRX300 and xRX330
	* moved common part of phylink validation into gswip_phylink_set_capab()
	* verify the compatible string against the hardware

Aleksander Jan Bajkowski (3):
  net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330
  net: dsa: lantiq: verify compatible strings against hardware
  dt-bindings: net: dsa: lantiq: add xRx300 and xRX330 switch bindings

 .../bindings/net/dsa/lantiq-gswip.txt         |   4 +
 drivers/net/dsa/lantiq_gswip.c                | 164 ++++++++++++++----
 2 files changed, 137 insertions(+), 31 deletions(-)

-- 
2.20.1

