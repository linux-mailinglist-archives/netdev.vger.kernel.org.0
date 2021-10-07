Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDC44253F9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbhJGN1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233176AbhJGN1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:27:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7163E6125F;
        Thu,  7 Oct 2021 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633613120;
        bh=RtH0yJDyPJL2xq/T67sFHCoWE1/krgLSzmWXGKpc/hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UK2Qny1yuzkE2lE7s0W7dFVOvDxXDX2+kEGxkZLc+4CHtxeSoFdC6oIEUrYi+PfCx
         xqk7iWHrpJZGMs/7Y/jKcCbB4++UzysW+qJp7uvvmIrosE81nYNmNx4HlsRUoNKIDl
         qIIyEbV6fAVmlSd0x3k6Sval9ouYHHRHqzjnknY1R7WVofSMPq6H0P57Q1XleC+uRC
         8F9yL8h9tCq8PchpQJR6sSdCAmnFNDiM6dseMu5QWPUg8zzV8S2nFqC0jX0RxCFYSX
         qIXUxzNpf4XnHAXZRuCOJYubAHLG9WDpUYOx7zUkhi/vVBi9scz9KyYlWZafQLDanN
         yJXEoYrvoT+Hg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, michael@walle.cc,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] ethernet: un-export nvmem_get_mac_address()
Date:   Thu,  7 Oct 2021 06:25:09 -0700
Message-Id: <20211007132511.3462291-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007132511.3462291-1-kuba@kernel.org>
References: <20211007132511.3462291-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nvmem_get_mac_address() is only called from of_net.c
we don't need the export.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethernet/eth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index d7b8fa10fabb..182de70ac258 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -558,7 +558,6 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 
 	return 0;
 }
-EXPORT_SYMBOL(nvmem_get_mac_address);
 
 static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
 			       const char *name, char *addr)
-- 
2.31.1

