Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A1621BD50
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGJTFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 15:05:34 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:56110 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbgGJTF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 15:05:26 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 5F7F1BC070;
        Fri, 10 Jul 2020 19:04:16 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        mchehab+huawei@kernel.org, robh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH v2] MAINTAINERS: XDP: restrict N: and K:
Date:   Fri, 10 Jul 2020 21:04:07 +0200
Message-Id: <20200710190407.31269-1-grandmaster@al2klimov.de>
In-Reply-To: <87tuyfi4fm.fsf@toke.dk>
References: <87tuyfi4fm.fsf@toke.dk>
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
 Better?

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d4aa7f942de..735e2475e926 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18708,8 +18708,8 @@ F:	include/trace/events/xdp.h
 F:	kernel/bpf/cpumap.c
 F:	kernel/bpf/devmap.c
 F:	net/core/xdp.c
-N:	xdp
-K:	xdp
+N:	(?:\b|_)xdp
+K:	(?:\b|_)xdp
 
 XDP SOCKETS (AF_XDP)
 M:	Björn Töpel <bjorn.topel@intel.com>
-- 
2.27.0

