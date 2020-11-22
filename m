Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1C72BC313
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 02:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgKVB6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 20:58:00 -0500
Received: from novek.ru ([213.148.174.62]:39788 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgKVB57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 20:57:59 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 3CDE65001D3;
        Sun, 22 Nov 2020 04:58:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 3CDE65001D3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606010292; bh=/dxbDDpsQzgHNHTEbnlg/Uegz70knoOTWjuxOFmarwA=;
        h=From:To:Cc:Subject:Date:From;
        b=NDNrMk0pRLmZK1VmNsN3+oa17dXIWt8LS+SSdQKmquD+zM+gnhRTG5sv4C6EzAY8g
         RyDwXVFmY3l3iqYFaCyfx9Q80WDnAkPrlFlU80kA0AzTlc11YzDOqJmRF64LAbbOh/
         e607srsPSPm8xvmdNuTkhB75BDoAoJ1co89kzK8U=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net-next 0/5] Add CHACHA20-POLY1305 cipher to Kernel TLS
Date:   Sun, 22 Nov 2020 04:57:40 +0300
Message-Id: <1606010265-30471-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 7905 defines usage of ChaCha20-Poly1305 in TLS connections. This
cipher is widely used nowadays and it's good to have a support for it
in TLS connections in kernel

Vadim Fedorenko (5):
  net/tls: make inline helpers protocol-aware
  net/tls: add CHACHA20-POLY1305 specific defines and structures
  net/tls: add CHACHA20-POLY1305 specific behavior
  net/tls: add CHACHA20-POLY1305 configuration
  selftests/tls: add CHACHA20-POLY1305 to tls selftests

 include/net/tls.h                 | 32 ++++++++++++++++---------------
 include/uapi/linux/tls.h          | 15 +++++++++++++++
 net/tls/tls_device.c              |  2 +-
 net/tls/tls_device_fallback.c     | 13 +++++++------
 net/tls/tls_main.c                |  3 +++
 net/tls/tls_sw.c                  | 36 ++++++++++++++++++++++++++---------
 tools/testing/selftests/net/tls.c | 40 ++++++++++++++++++++++++++++++++-------
 7 files changed, 103 insertions(+), 38 deletions(-)

-- 
1.8.3.1

