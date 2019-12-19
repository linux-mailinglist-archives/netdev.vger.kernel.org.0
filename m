Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F74125FF1
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLSKwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:52:32 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:7101 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfLSKwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:52:32 -0500
Received: from cyclone.blr.asicdesigners.com (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBJAqL21010899;
        Thu, 19 Dec 2019 02:52:23 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 0/2] chelsio/chtls
Date:   Thu, 19 Dec 2019 16:21:46 +0530
Message-Id: <20191219105148.32456-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches address two issues in chtls.
patch 1 add support for AES256-GCM based ciphers.
patch 2 fixes memory leak issues.

Thanks,
Vinay

Vinay Kumar Yadav (2):
  chtls: Add support for AES256-GCM based ciphers
  chtls: Fixed memory leak

 drivers/crypto/chelsio/chtls/chtls.h      |  7 ++-
 drivers/crypto/chelsio/chtls/chtls_cm.c   | 27 +++++-----
 drivers/crypto/chelsio/chtls/chtls_cm.h   | 21 ++++++++
 drivers/crypto/chelsio/chtls/chtls_hw.c   | 65 ++++++++++++++++-------
 drivers/crypto/chelsio/chtls/chtls_main.c | 23 +++++++-
 5 files changed, 109 insertions(+), 34 deletions(-)

-- 
2.18.1

