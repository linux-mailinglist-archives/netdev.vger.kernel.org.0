Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894E846AE6D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353802AbhLFXa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:30:58 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:22900 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245603AbhLFXa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=Juz9Xsl4ZH+dwm+rB72l7PDASug6d5DRJB5/zKUQ200=;
        b=YqUMuTPGDJQemTHg1Rg8/v4yhVP76zQsOqPpSB9bdxc4mteuDrTfCp2QyssVRu0m64ww
        ApvW2GwBsqstDOpDnl4TS6Ot+itgTxgKZxm/CCxHNt3FyLrO/7E3ZnsUvWsl1oG1iADrdX
        lMpT4SA1PwZDNnw85O7GNhsEj15hiAWWPk5C54WKePN1yPBS+JiD9aojx6jtWRa5Cngpg8
        NlADEaJ3mVt3/W0MBujIR+zg2O27EtCJ8ubEWVXkoUm5hUCTxgCKjGmA8CZ9GgxNO5zTch
        dVS247jF+MYanqRKRJj4uRBsvPbtBmqV8J7S+3v99LG91Usr594nh3SVxd2t5ZPw==
Received: by filterdrecv-7bc86b958d-pcmn7 with SMTP id filterdrecv-7bc86b958d-pcmn7-1-61AE9C5F-1B
        2021-12-06 23:27:27.553131691 +0000 UTC m=+8298427.950383570
Received: from pearl.egauge.net (unknown)
        by ismtpd0063p1las1.sendgrid.net (SG) with ESMTP
        id 08fAf3y0Tfy9_xs1Z1beLA
        Mon, 06 Dec 2021 23:27:27.277 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 55B1670016C; Mon,  6 Dec 2021 16:27:26 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: wilc1000: Fix minor typos in error messages
Date:   Mon, 06 Dec 2021 23:27:27 +0000 (UTC)
Message-Id: <20211206232709.3192856-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvKMLBLYoogBoWcacY?=
 =?us-ascii?Q?=2FgVyq0ZQ0g+BRw+bdUgCYC2o1QqMLse72bqHBdq?=
 =?us-ascii?Q?U0m7Lg=2FxVhgCtLbfY205oTvOIEl7fuz6Rmud0Kt?=
 =?us-ascii?Q?Yk4sDnPTgbjPvve4CKY65kINtoNwBF+EqdPUsy1?=
 =?us-ascii?Q?96Tu2aMFgs2A4ki2rYCatl4QWY3Z9+ofQpeoiA?=
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

These two patches fix typos in error messages.

 drivers/net/wireless/microchip/wilc1000/hif.c    |    2 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

