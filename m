Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4167243127F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 10:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhJRIye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230392AbhJRIye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 04:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA94660FD9;
        Mon, 18 Oct 2021 08:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634547143;
        bh=dQK1LN2qRpI9yrCG6odMWztdR+yHK/4XIGNgZXiROgs=;
        h=From:To:Cc:Subject:Date:From;
        b=St1YTGWQdcqidQnbqtKcVXXUbHJdN36S/mfxlxuV8rK4MVzLWcES8HMdv+JGgCxwf
         56a1+k8wbU3ICKcGqjwOq2eec+QHgt2XjBJuFjEHM//EbWm9X8ebGtwq2jnDCdCiqO
         MPGPVVZUqRcFkzhNYM9IDQzVmxOnQmqteyez25UkxpdXk9Xz5RaeXx5fzKe74C8Wfd
         VVqG2AVMZMwwpfkswkl7K6qLaxRNWKmp9F6ToZk6xGgXAqTCgzMLNVVNMqFhMsinGq
         BzseZcp5IiV3jshgA7FnHvXcjf967OnxP5ur2vDBYBv+j7ETEuVJObk9cgT26T69Es
         2M/VNEtg1IU5w==
From:   Antoine Tenart <atenart@kernel.org>
To:     jiri@nvidia.com, stephen@networkplumber.org, dsahern@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH iproute2] man: devlink-port: fix pfnum for devlink port add
Date:   Mon, 18 Oct 2021 10:52:20 +0200
Message-Id: <20211018085220.193480-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When configuring a devlink PCI port, the pfnumber can be specified
using 'pfnum' and not 'pcipf' as stated in the man page. Fix this.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 man/man8/devlink-port.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index e48c573578ca..e668d0a242eb 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -50,7 +50,7 @@ devlink-port \- devlink port configuration
 .RB "} "
 .RB "[ " flavour
 .IR FLAVOUR " ]"
-.RB "[ " pcipf
+.RB "[ " pfnum
 .IR PFNUMBER " ]"
 .RB "[ " sfnum
 .IR SFNUMBER " ]"
-- 
2.31.1

