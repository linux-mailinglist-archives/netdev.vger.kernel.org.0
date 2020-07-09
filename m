Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D35521A7F4
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgGITnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgGITnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:43:07 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08D6C08C5CE;
        Thu,  9 Jul 2020 12:43:07 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 710BDBC0C2;
        Thu,  9 Jul 2020 19:43:03 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        mchehab+huawei@kernel.org, robh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] MAINTAINERS: XDP: restrict N: and K:
Date:   Thu,  9 Jul 2020 21:42:57 +0200
Message-Id: <20200709194257.26904-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spamd-Bar: /
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp465"
which has nothing to do with XDP.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 See also: https://lore.kernel.org/lkml/20200709132607.7fb42415@carbon/

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d4aa7f942de..2bb7feb838af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18708,8 +18708,8 @@ F:	include/trace/events/xdp.h
 F:	kernel/bpf/cpumap.c
 F:	kernel/bpf/devmap.c
 F:	net/core/xdp.c
-N:	xdp
-K:	xdp
+N:	(?:\b|_)xdp(?:\b|_)
+K:	(?:\b|_)xdp(?:\b|_)
 
 XDP SOCKETS (AF_XDP)
 M:	Björn Töpel <bjorn.topel@intel.com>
-- 
2.27.0

