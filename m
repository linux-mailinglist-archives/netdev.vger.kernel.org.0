Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0427B1D2924
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 09:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgENHyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 03:54:25 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:57442 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgENHyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 03:54:25 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04E7s1H1023047;
        Thu, 14 May 2020 00:54:02 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 0/2] Fixing compilation warnings and errors
Date:   Thu, 14 May 2020 13:23:28 +0530
Message-Id: <20200514075330.25542-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Fixes the warnings seen when compiling using sparse tool.

Patch 2: Fixes a cocci check error introduced after commit
567be3a5d227 ("crypto: chelsio - Use multiple txq/rxq per
tfm to process the requests").


Ayush Sawal (2):
  Crypto/chcr: Fixes compilations warnings
  Crypto/chcr: Fixes a cocci check error

 drivers/crypto/chelsio/chcr_algo.c  | 9 +++++----
 drivers/crypto/chelsio/chcr_ipsec.c | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.26.0.rc1.11.g30e9940

