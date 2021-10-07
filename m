Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4989D425A88
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243567AbhJGSU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243515AbhJGSUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 14:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F56661263;
        Thu,  7 Oct 2021 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633630736;
        bh=e6YjbpFyBdtxs2+stuYdv7OiRKwMGhv1BpFUoa09qL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TleKOU2gceHxC+9rPktNw8y29qiC4zLE67FPdYcfJ23usQAIf1sk3uVpe09zI6ns+
         ZDlG99uxssn+7P/b7h+YwGDH3KzRXPMkET9TvElwPg8dMFcoheNAbAotSCRyaaquf9
         Qyn5GWcRG6qoTo5IBvoZ4mNsHw8MG1aAkrqGca3rWVhufFsT8/JpTdJ/BIT5/zSZmn
         AENdxPvdsyg5qJRYzlAOQkPkMNTd8bleobMtyo9CxSDabyXwVKz5kP5Nu/RSP2wCHo
         E39Wb3dsme9Au9/NEqsfsp7yt+G6zHVnFP7WUnbWFtMtQaec59Hm+pcJCXlYLZ1ddI
         qFOr4237vArhA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, michael@walle.cc,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/3] ethernet: un-export nvmem_get_mac_address()
Date:   Thu,  7 Oct 2021 11:18:45 -0700
Message-Id: <20211007181847.3529859-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007181847.3529859-1-kuba@kernel.org>
References: <20211007181847.3529859-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nvmem_get_mac_address() is only called from of_net.c
we don't need the export.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

