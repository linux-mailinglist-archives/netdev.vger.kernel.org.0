Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078303B278C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhFXGoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhFXGo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:44:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F9C06175F
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:42:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lwJ3u-0008QF-KH
        for netdev@vger.kernel.org; Thu, 24 Jun 2021 08:42:06 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3BBDA6427B5
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 06:42:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 055CD6427A3;
        Thu, 24 Jun 2021 06:42:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 477bbe8c;
        Thu, 24 Jun 2021 06:42:02 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-06-24
Date:   Thu, 24 Jun 2021 08:41:58 +0200
Message-Id: <20210624064200.2998085-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 2 patches for net/master.

The first patch is by Norbert Slusarek and prevent allocation of
filter for optlen == 0 in the j1939 CAN protocol.

The last patch is by Stephane Grosjean and fixes a potential
starvation in the TX path of the peak_pciefd driver.

regards,
Marc

---

The following changes since commit c2f5c57d99debf471a1b263cdf227e55f1364e95:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-06-23 14:12:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.13-20210624

for you to fetch changes up to b17233d385d0b6b43ecf81d43008cb1bbb008166:

  can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path (2021-06-24 08:40:10 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.13-20210624

----------------------------------------------------------------
Norbert Slusarek (1):
      can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter for optlen == 0

Stephane Grosjean (1):
      can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path

 drivers/net/can/peak_canfd/peak_canfd.c | 4 ++--
 net/can/j1939/socket.c                  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


