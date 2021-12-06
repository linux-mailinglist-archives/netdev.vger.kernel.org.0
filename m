Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3499646AE65
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376630AbhLFX2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:28:48 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:13682 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348507AbhLFX2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:28:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=c2NTbZCDixOoUAwx9rh2PN2ajYe2rIBMZrk7UOUzRPc=;
        b=g+NlwStWzLWaGYggOmzcoQIAkoGk5kdWbDAX62cWf8U2C0ArFqPROUGPg6w2Sm7R0kT8
        Nt1/aGpU0x9wyzA7rfSCWCv9oiBbWHq5he4vzbNgUB6kyurr/+ILeIcz+KtsOgwxol3Ol4
        YsWAMBdOVhbza10ZRePIBbau87QYUbvN4FGkXCVZU9/PEF54nMxO3YakpHja5YA/AgISBQ
        ddZ7Ss2EtH31HsheI2M+6J5ztZcG5qM6Lk0i2K0+dO4Cz6bq7I4Kwv0UZRpfXHnyzsFF7d
        bLr+lNRuquJtlApf1TYPrStSkHYyyr9UY+sf1hhhAkl5rRVOZs/4F8ZJqhvsQDaQ==
Received: by filterdrecv-7bc86b958d-l42lh with SMTP id filterdrecv-7bc86b958d-l42lh-1-61AE9BDE-1E
        2021-12-06 23:25:18.457749048 +0000 UTC m=+8298334.833729961
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-0 (SG)
        with ESMTP
        id L6T4MAqWR9qPlPTgt1klRA
        Mon, 06 Dec 2021 23:25:18.251 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 7BB5C70016C; Mon,  6 Dec 2021 16:25:17 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: wilc1000: Minor error message fixes
Date:   Mon, 06 Dec 2021 23:25:18 +0000 (UTC)
Message-Id: <20211206232429.3192624-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvKPxA4fnzmuMjyHMI?=
 =?us-ascii?Q?EIFttpHD5XpwTMcVP9nMYQEC7G63sBU3Q6xgWyV?=
 =?us-ascii?Q?HvAX0qEviqtR02cZU3EsY5xrn6Z2Q7EoZYoEyUI?=
 =?us-ascii?Q?FxgRghPq1E57K8BAjbjLNWobaD=2FshEjADmb2m7Z?=
 =?us-ascii?Q?zA3xiXqkROqzL3Sx07Fx3RiFptBPZQOQmxWXii?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches fix minor typos in the wilc1000 driver.

 drivers/net/wireless/microchip/wilc1000/hif.c    |    2 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

