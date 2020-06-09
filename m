Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4971F48CF
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgFIVY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:24:59 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:44467 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFIVY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:24:59 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 059LOn5N030078;
        Tue, 9 Jun 2020 14:24:50 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, manojmalviya@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 0/2] Fixing issues in dma mapping and driver removal
Date:   Wed, 10 Jun 2020 02:54:30 +0530
Message-Id: <20200609212432.2467-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: This fixes the kernel panic which occurs due to the accessing
of a zero length sg.

Patch 2: Avoiding unregistering the algorithm if cra_refcnt is not 1.

Ayush Sawal (2):
  Crypto/chcr: Calculate src and dst sg lengths separately for dma map
  Crypto/chcr: Checking cra_refcnt before unregistering the algorithms

 drivers/crypto/chelsio/chcr_algo.c | 81 ++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 22 deletions(-)

-- 
2.26.0.rc1.11.g30e9940

