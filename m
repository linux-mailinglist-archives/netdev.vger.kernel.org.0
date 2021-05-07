Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27B43763B5
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 12:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhEGK3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 06:29:42 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:44665 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhEGK3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 06:29:41 -0400
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d48 with ME
        id 1mUT2500A3PnFJp03mUeQs; Fri, 07 May 2021 12:28:41 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 07 May 2021 12:28:41 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v2 0/2] add commandline support for Transmitter Delay Compensation (TDC) in iproute
Date:   Fri,  7 May 2021 19:28:17 +0900
Message-Id: <20210507102819.1932386-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains two patches which respectively:
  1. factorize the many print_*(PRINT_JSON, ...) and fprintf
  occurrences in a single print_*(PRINT_ANY, ...) call and fix the
  signedness while doing that.
  2. adds command line support for the TDC in iproute and goes together
  with below series in the kernel:
  https://lore.kernel.org/linux-can/20210506111412.1665835-1-mailhol.vincent@wanadoo.fr/T/#t

For now, I am only sending the kernel mailing list as an RFC. The
patch will be sent to iproute maintainers after the kernel patches
get accepted.


** Changelog **

From RFC v1 to RFC v2:
  * Add an additional patch to the series to fix the issues reported
    by Stephen Hemminger
    Ref: https://lore.kernel.org/linux-can/20210506112007.1666738-1-mailhol.vincent@wanadoo.fr/T/#t

Vincent Mailhol (2):
  iplink_can: use PRINT_ANY to factorize code and fix signedness
  iplink_can: add new CAN FD bittiming parameters: Transmitter Delay
    Compensation (TDC)

 include/uapi/linux/can/netlink.h |  25 +-
 ip/iplink_can.c                  | 402 ++++++++++++++++---------------
 2 files changed, 224 insertions(+), 203 deletions(-)

-- 
2.26.3

