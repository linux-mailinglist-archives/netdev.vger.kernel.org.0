Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFE11EA886
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 19:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgFARnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 13:43:23 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:41644 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFARnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 13:43:23 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 051HhBcB032125;
        Mon, 1 Jun 2020 10:43:12 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        manojmalviya@chelsio.com
Cc:     netdev@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next V2 0/2] Fixing compilation warnings and errors
Date:   Mon,  1 Jun 2020 23:11:57 +0530
Message-Id: <20200601174159.9900-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Fixes the warnings seen when compiling using sparse tool.

Patch 2: Fixes a cocci check error introduced after commit
567be3a5d227 ("crypto: chelsio -
Use multiple txq/rxq per tfm to process the requests").

V1->V2

patch1: Avoid type casting by using get_unaligned_be32() and
    	put_unaligned_be16/32() functions.

patch2: Modified subject of the patch.


Ayush Sawal (2):
  Crypto/chcr: Fixes compilations warnings
  Crypto/chcr: Fixes a coccinile check error

 drivers/crypto/chelsio/chcr_algo.c  | 11 +++++------
 drivers/crypto/chelsio/chcr_ipsec.c |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.26.0.rc1.11.g30e9940

