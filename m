Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FEF3450ED
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhCVUhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:37:47 -0400
Received: from mx3.wp.pl ([212.77.101.10]:23353 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230377AbhCVUhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:37:34 -0400
Received: (wp-smtpd smtp.wp.pl 5930 invoked from network); 22 Mar 2021 21:37:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1616445452; bh=2+W0kEGsXziylTprHM+qyJg5jdwnKhdmEKuCIHvSSWs=;
          h=From:To:Cc:Subject;
          b=l8w5MxKB3QM+0cqvM1kLMmLts7wS8B/KtlKUI3+vRXhEbVluQeXBXejHcBZPzHLCn
           L4Tf5pizr4D3itXTJtHAMjJafoQQsPWioJTE65dluubDb/ONYcheHFflE+R4F8yqNJ
           afIQBKS2IXKH2MuclaS3RZbK0qbJRe+pknGsYRQg=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 22 Mar 2021 21:37:32 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v4 0/3] net: dsa: lantiq: add support for xRX300 and xRX330
Date:   Mon, 22 Mar 2021 21:37:14 +0100
Message-Id: <20210322203717.20616-1-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: ffe7570c990774ebea490853c7a51c9c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [kaKB]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed since v3:
	* fixed last compilation warning

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
 drivers/net/dsa/lantiq_gswip.c                | 162 ++++++++++++++----
 2 files changed, 136 insertions(+), 30 deletions(-)

-- 
2.20.1

