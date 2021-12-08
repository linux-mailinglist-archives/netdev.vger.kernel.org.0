Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A4046CD86
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbhLHGTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:19:42 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:45160 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbhLHGTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:19:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=aQvHj8mmm6h0h+le8yRYWHvpJDU5aoqP1q8f0KzoSzs=;
        b=ecHqgI8XTxJ/qc4HWiZzTv97ilxpB9MHFzJvse1VJZrgy2ajU2qaJyx35fLwRBh8A70c
        if+1YQhOXRYDAsjvYJxa/vJDIeLvECg/KGrptB6JCH+yLdb8c7O15bBd93lxh/vLdVjvcf
        If/xwfz59BeWd20Ooj1tGjIZtMfl5nKAfB/2ugu/n7NTdfSQM8kfGI4v4JVu6STJ+DvVVv
        TTkgnDTppfZjFgur8aYGP+nFbc1/Y2CaqkSzNFF1qm99FmPgTDrB8ZZv69ynpYm9atzYlL
        1G1fv2eBxZzmGcPWnUDCQMWSyDG3NgOK98RHxy/ET5FfR2GVdSXbJmgrtI3T0WKQ==
Received: by filterdrecv-7bc86b958d-j7vqt with SMTP id filterdrecv-7bc86b958d-j7vqt-1-61B04DAA-C
        2021-12-08 06:16:10.180268964 +0000 UTC m=+8409379.473909293
Received: from pearl.egauge.net (unknown)
        by ismtpd0064p1las1.sendgrid.net (SG) with ESMTP
        id J0a28OxvSa2ymiJMl_40FA
        Wed, 08 Dec 2021 06:16:09.964 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 458C3700371; Tue,  7 Dec 2021 23:16:08 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 0/2] wilc1000-spi: Add reset/enable GPIO support
Date:   Wed, 08 Dec 2021 06:16:10 +0000 (UTC)
Message-Id: <20211208061559.3404738-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvPWcr8DNNUfZmiks6?=
 =?us-ascii?Q?Lxnknh93JPOtABu=2F+81huHcY8F9W=2FqA++LzUTIy?=
 =?us-ascii?Q?n2hSQ6+QdmJVnNq5=2F7bCKFxt=2FjLeXy9WwW2sYW6?=
 =?us-ascii?Q?E5bMQOhFMKLyohmwC512MMnvGdikzfEHk5Zamqc?=
 =?us-ascii?Q?jrJgkfO3WIoTAifKs+TebdknLjK=2FO+=2FEvh6vN0?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        devicetree@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This version of the patch splits the documentation update and the
actual driver changes into two separate patches.  Also, since SDIO
apparently never uses GPIO lines for reset/enable control, make
simplify the patch to be SPI-only.

David Mosberger-Tang (2):
  wilc1000: Add reset/enable GPIO support to SPI driver
  wilc1000: Document enable-gpios and reset-gpios properties

 .../net/wireless/microchip,wilc1000.yaml      | 15 ++++++++
 drivers/net/wireless/microchip/wilc1000/spi.c | 36 +++++++++++++++++--
 .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
 3 files changed, 49 insertions(+), 4 deletions(-)

-- 
2.25.1

