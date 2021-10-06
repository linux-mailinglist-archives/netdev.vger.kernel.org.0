Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D19F423AC2
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhJFJq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhJFJqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:46:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFEFA610C9;
        Wed,  6 Oct 2021 09:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513498;
        bh=USn8x5LupaSji3uWzQG5LeIP/8bYvr2cT9Xsg+kViAw=;
        h=From:To:Cc:Subject:Date:From;
        b=Ka/D+4rJ7WQuFa9lBKV4/GALGrQuyJ1s22JwaiYCmz3TAOZI8ozWBst+hykVbB4hR
         v3n617SKNcoyNLuGYtaqgkVvgabHgI6RdxS2Zr1jNLl/XSL6l3yZIvM9/3zYnV7VzY
         dL9bp0O/jIN0UQmjq/HUGwaYn7IoRxM4G28iJT8SxMp8mtdrJfLggxg+F7iVnfoYz4
         ybPpgU3sUwNdsHMERhmJlsuJMF1/tvRwZNvcizJ2rtnJU5nfWR/qLdPu0gvGa0J0Nz
         7vD1qZzGNscR7AJ9EV5BZZUERtta48l3Sna9ShULu+ZLb9e78axvk2X5olq3/2VARb
         RjwzAwmIztBGQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     jiri@nvidia.com, stephen@networkplumber.org, dsahern@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next 1/3] man: devlink-port: fix the devlink port add synopsis
Date:   Wed,  6 Oct 2021 11:44:53 +0200
Message-Id: <20211006094455.138504-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When configuring a devlink PCI SF port, the sfnumber can be specified
using 'sfnum' and not 'pcisf' as stated in the man page. Fix this.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 man/man8/devlink-port.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 147c8e271d79..4d2ff5d87144 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -53,7 +53,7 @@ devlink-port \- devlink port configuration
 .RB "[ " pcipf
 .IR PFNUMBER " ]"
 .br
-.RB "{ " pcisf
+.RB "{ " sfnum
 .IR SFNUMBER " }"
 .br
 .RB "[ " controller
-- 
2.31.1

