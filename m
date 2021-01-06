Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238ED2EB8F4
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 05:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbhAFEai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 23:30:38 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:22486 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbhAFEai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 23:30:38 -0500
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 1064TfXc022094;
        Tue, 5 Jan 2021 20:29:42 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net 0/7] Bug fixes for chtls driver
Date:   Wed,  6 Jan 2021 09:59:05 +0530
Message-Id: <20210106042912.23512-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch 1: Fix hardware tid leak.
patch 2: Remove invalid set_tcb call.
patch 3: Fix panic when route to peer not configured.
patch 4: Avoid unnecessary freeing of oreq pointer.
patch 5: Replace skb_dequeue with skb_peek.
patch 6: Added a check to avoid NULL pointer dereference patch.
patch 7: Fix chtls resources release sequence.

Ayush Sawal (7):
  chtls: Fix hardware tid leak
  chtls: Remove invalid set_tcb call
  chtls: Fix panic when route to peer not configured
  chtls: Avoid unnecessary freeing of oreq pointer
  chtls: Replace skb_dequeue with skb_peek
  chtls: Added a check to avoid NULL pointer dereference
  chtls: Fix chtls resources release sequence

 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 71 +++++++------------
 1 file changed, 24 insertions(+), 47 deletions(-)

-- 
2.28.0.rc1.6.gae46588

