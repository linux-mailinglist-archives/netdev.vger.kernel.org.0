Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B5C41BFD9
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244645AbhI2H22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:28 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33056 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244600AbhI2H22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:28 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id E289720166; Wed, 29 Sep 2021 15:26:45 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 00/10] Updates to MCTP core
Date:   Wed, 29 Sep 2021 15:26:04 +0800
Message-Id: <20210929072614.854015-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds timeouts for MCTP tags (a limited resource), and a few
other improvements to the MCTP core.

Cheers,
Matt

Jeremy Kerr (7):
  mctp: Allow local delivery to the null EID
  mctp: locking, lifetime and validity changes for sk_keys
  mctp: Add refcounts to mctp_dev
  mctp: Implement a timeout for tags
  mctp: Add tracepoints for tag/key handling
  mctp: Do inits as a subsys_initcall
  doc/mctp: Add a little detail about kernel internals

Matt Johnston (3):
  mctp: Allow MCTP on tun devices
  mctp: Set route MTU via netlink
  mctp: Warn if pointer is set for a wrong dev type

 Documentation/networking/mctp.rst |  59 ++++++++++
 include/net/mctp.h                |  56 ++++++---
 include/net/mctpdevice.h          |   5 +
 include/trace/events/mctp.h       |  75 ++++++++++++
 net/mctp/af_mctp.c                |  66 +++++++++--
 net/mctp/device.c                 |  53 +++++++--
 net/mctp/neigh.c                  |   4 +-
 net/mctp/route.c                  | 190 ++++++++++++++++++++++++------
 8 files changed, 431 insertions(+), 77 deletions(-)
 create mode 100644 include/trace/events/mctp.h

-- 
2.30.2

