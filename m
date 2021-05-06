Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5F53752F3
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhEFLVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:21:23 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:26206 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhEFLVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:21:21 -0400
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d58 with ME
        id 1PLC2500T3PnFJp03PLKjj; Thu, 06 May 2021 13:20:23 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Thu, 06 May 2021 13:20:23 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v1 0/1] add commandline support for Transmitter Delay Compensation (TDC) in iproute
Date:   Thu,  6 May 2021 20:20:06 +0900
Message-Id: <20210506112007.1666738-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This additional patch adds command line support for the TDC in iproute
and goes together with below series:
https://lore.kernel.org/linux-can/20210506111412.1665835-1-mailhol.vincent@wanadoo.fr/T/#t

For now, I am only sending the patch to the CAN mailing list.

Vincent Mailhol (1):
  iplink_can: add new CAN FD bittiming parameters: Transmitter Delay
    Compensation (TDC)

 include/uapi/linux/can/netlink.h | 25 +++++++++--
 ip/iplink_can.c                  | 72 ++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+), 3 deletions(-)

-- 
2.26.3

