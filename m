Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8A91C4C8F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgEEDOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:14:12 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:16825 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgEEDOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:14:11 -0400
Received: from beagle7.blr.asicdesigners.com (beagle7.blr.asicdesigners.com [10.193.80.123])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0453Dquu019487;
        Mon, 4 May 2020 20:13:53 -0700
From:   Devulapally Shiva Krishna <shiva@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        secdev@chelsio.com, Devulapally Shiva Krishna <shiva@chelsio.com>
Subject: [PATCH net-next 0/5] Crypto/chcr: Fix issues regarding algorithm implementation in driver
Date:   Tue,  5 May 2020 08:42:52 +0530
Message-Id: <20200505031257.9153-1-shiva@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series of patches fixes the issues which came during
self-tests with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.

Patch 1: Fixes gcm(aes) hang issue and rfc4106-gcm encryption issue.
Patch 2: Fixes ctr, cbc, xts and rfc3686-ctr extra test failures.
Patch 3: Fixes ccm(aes) extra test failures.
Patch 4: Added support for 48 byte-key_len in aes_xts.
Patch 5: fix for hmac(sha) extra test failure.

Devulapally Shiva Krishna (5):
  Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests
  Crypto/chcr: fix ctr, cbc, xts and rfc3686-ctr failed tests
  Crypto/chcr: fix for ccm(aes) failed test
  Crypto/chcr: support for 48 byte key_len in aes-xts
  Crypto/chcr: fix for hmac(sha) test fails

 drivers/crypto/chelsio/chcr_algo.c   | 89 +++++++++++++++++++++-------
 drivers/crypto/chelsio/chcr_crypto.h |  1 +
 2 files changed, 68 insertions(+), 22 deletions(-)

-- 
2.18.1

