Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002D713A944
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 13:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgANM3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 07:29:31 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:55722 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgANM3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 07:29:31 -0500
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00ECTEff031366;
        Tue, 14 Jan 2020 04:29:15 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH 0/3] Crypto/chtls bug fixes
Date:   Tue, 14 Jan 2020 17:58:46 +0530
Message-Id: <20200114122849.133085-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches fix followings
patch 1: Corrected function call context
patch 2: TCP listen fail bug fix
patch 3: Added stats counter for tls

Vinay Kumar Yadav (3):
  Crypto/chtls: Corrected function call context
  crypto/chtls: Fixed listen fail when max stid range reached
  chelsio/cxgb4: Added tls stats prints

 drivers/crypto/chelsio/chtls/chtls_cm.c       | 30 +++++++++----------
 drivers/crypto/chelsio/chtls/chtls_main.c     |  5 ++--
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  7 +++++
 3 files changed, 24 insertions(+), 18 deletions(-)

-- 
2.24.1

