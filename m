Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21ED121DFCA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgGMSgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:36:19 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:28967 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgGMSgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:36:19 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06DIa8xQ004006;
        Mon, 13 Jul 2020 11:36:09 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 0/3] chtls: fix inline tls bugs
Date:   Tue, 14 Jul 2020 00:05:51 +0530
Message-Id: <20200713183554.11719-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches fix following issues.
patch1: correct net_device reference count
patch2: fix tls alert messages corruption
patch3: Enable tcp window scaling option

Vinay Kumar Yadav (3):
  crypto/chtls: correct net_device reference count
  crypto/chtls: fix tls alert messages corrupted by tls data
  crypto/chtls: Enable tcp window scaling option

 drivers/crypto/chelsio/chtls/chtls_cm.c | 6 ++++++
 drivers/crypto/chelsio/chtls/chtls_io.c | 7 ++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.18.1

