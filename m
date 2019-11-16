Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409E4FF325
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfKPQXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbfKPPmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:47 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 879BA20733;
        Sat, 16 Nov 2019 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918966;
        bh=4z89RHmeFDHuAuKOgDLQ9eeVOAGtPmlhUw8to3NyyBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GWyPftyLb0670JiQ14QydhWsp385Oubz63xSlqTVY//yDumsdO6UfmsaTj3Bz+M7
         6jrYD7amz6eu4kUcjH96tSekNc/tkFTBDjYn2TxCEhUwzsUvjac9MKuFDks1RLo/TI
         wmOfev9KC7kn6vSfaArlhwAzZaYn6bTHDOpDv8uo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 082/237] SUNRPC: Fix a compile warning for cmpxchg64()
Date:   Sat, 16 Nov 2019 10:38:37 -0500
Message-Id: <20191116154113.7417-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e732f4485a150492b286f3efc06f9b34dd6b9995 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_seal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/auth_gss/gss_krb5_seal.c b/net/sunrpc/auth_gss/gss_krb5_seal.c
index eaad9bc7a0bdc..e1f0571843c8c 100644
--- a/net/sunrpc/auth_gss/gss_krb5_seal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_seal.c
@@ -63,6 +63,7 @@
 #include <linux/sunrpc/gss_krb5.h>
 #include <linux/random.h>
 #include <linux/crypto.h>
+#include <linux/atomic.h>
 
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 # define RPCDBG_FACILITY        RPCDBG_AUTH
-- 
2.20.1

