Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF859197F6A
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgC3PTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:19:32 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:3041 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgC3PTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:19:31 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02UFJFT4027024;
        Mon, 30 Mar 2020 08:19:16 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 0/2] Fixes issues during chcr driver registration
Date:   Mon, 30 Mar 2020 20:48:51 +0530
Message-Id: <20200330151853.32550-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Avoid the accessing of wrong u_ctx pointer.
Patch 2: Fixes a deadlock between rtnl_lock and uld_mutex.

Ayush Sawal (2):
  Crypto: chelsio - Fixes a hang issue during driver registration
  Crypto: chelsio - Fixes a deadlock between rtnl_lock and uld_mutex

 drivers/crypto/chelsio/chcr_core.c  | 34 ++++++++++++++++++++++++-----
 drivers/crypto/chelsio/chcr_ipsec.c |  2 --
 2 files changed, 28 insertions(+), 8 deletions(-)

-- 
2.26.0.rc1.11.g30e9940

