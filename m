Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749574311A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389050AbfFLUtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:49:17 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:19112 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388615AbfFLUtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:49:17 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x5CKnCGs012537
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 14:49:12 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x5CKnCV2014125
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 12 Jun 2019 14:49:12 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 0/2] Microchip KSZ driver enhancements
Date:   Wed, 12 Jun 2019 14:49:04 -0600
Message-Id: <1560372546-3153-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple of enhancements to the Microchip KSZ switch driver: one to add
PHY register settings for errata workarounds for more stable operation, and
another to add a device tree option to change the output clock rate as
required by some board designs.

Robert Hancock (2):
  net: dsa: microchip: Add PHY errata workarounds
  net: dsa: microchip: Support optional 125MHz SYNCLKO output

 Documentation/devicetree/bindings/net/dsa/ksz.txt |  2 +
 drivers/net/dsa/microchip/ksz9477.c               | 66 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.c            |  2 +
 drivers/net/dsa/microchip/ksz_priv.h              |  2 +
 4 files changed, 72 insertions(+)

-- 
1.8.3.1

