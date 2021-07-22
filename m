Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C803D218D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 12:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhGVJTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 05:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231487AbhGVJTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 05:19:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB8161287;
        Thu, 22 Jul 2021 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626948020;
        bh=1Y4oOrO04OT1bQ0G0raCzLNZXj2VySRuILzlhimGt+8=;
        h=From:To:Cc:Subject:Date:From;
        b=iekcUmIFJVS0FCGNvU+4Sr9dptYQ3mlitjHAUkejxIDtZ+eScAZDBKzEx4eI12I0B
         z5UqRjMHa6KfnBHf8TZDY4ZcSDolDGT/72H3BpVJjC9MgFvUaKypksiXYdx4hAQMe+
         dPMtbubkcVQQHZrppaFly5p3vv4QtSK7hshAKdQWI3gzrVUfal+XYwSsjRnoH50pp/
         am/MYooYDD+Gt+vXX/QtCU4GW7a/odjGanJ8iQBkTYAIG3IlnWcLNWyPoi1JNM4CPU
         oRmNIylw5Rgd5vpOyemAb9oya0nq1ufrkoho2FBr3vorNAmD174KPMFJn9bcWNBhFI
         /2ityDm1joB4Q==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1m6VUz-008mHJ-DK; Thu, 22 Jul 2021 12:00:13 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Rob Herring <robh+dt@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        devicetree@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 00/15] Fix some DT binding references at next-20210722
Date:   Thu, 22 Jul 2021 11:59:57 +0200
Message-Id: <cover.1626947923.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to DT schema conversion to yaml, several references to dt-bindings got
broken.

Update them.

Mauro Carvalho Chehab (15):
  dt-bindings: mtd: update mtd-physmap.yaml reference
  dt-bindings: firmware: update arm,scpi.yaml reference
  dt-bindings: net: dsa: sja1105: update nxp,sja1105.yaml reference
  MAINTAINERS: update mtd-physmap.yaml reference
  MAINTAINERS: update arm,vic.yaml reference
  MAINTAINERS: update aspeed,i2c.yaml reference
  MAINTAINERS: update faraday,ftrtc010.yaml reference
  MAINTAINERS: update fsl,fec.yaml reference
  MAINTAINERS: update mtd-physmap.yaml reference
  MAINTAINERS: update ti,am654-hbmc.yaml reference
  MAINTAINERS: update ti,sci.yaml reference
  MAINTAINERS: update gpio-zynq.yaml reference
  MAINTAINERS: update arm,pl353-smc.yaml reference
  MAINTAINERS: update intel,ixp46x-rng.yaml reference
  MAINTAINERS: update nxp,imx8-jpeg.yaml reference

 .../devicetree/bindings/mtd/gpmc-nor.txt      |  4 ++--
 Documentation/hwmon/scpi-hwmon.rst            |  2 +-
 Documentation/networking/dsa/sja1105.rst      |  2 +-
 MAINTAINERS                                   | 24 +++++++++----------
 4 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.31.1


