Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F8C33DA73
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbhCPRPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239108AbhCPROE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 13:14:04 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B280C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 10:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=SNd1NC05kzjzUXrk9iyFECNnh7DNfCihWph8pL99bq8=; b=JJhWXyR9bT6NbKdEAKE9PYA+Wn
        pcarwhC/oci2ZPPjV+XG3kjJ2mmxJn9ShFlXQy1faXD3HMdTfn7qwq1pgftW/tO7DLKKGqftH0UPK
        rZyO9Rd4nijI6xbwUeVkYlwoA0pXneE+vc9W+HOQw76EJiKXvqj+9nVqHyZJ9tfGwHo1c4WBUji8L
        UN1MLo+ble4DXOuQ3ckQBh/FUYhiz+2vnGJwOpEQF0fNo9qD7yWzpCsEIF+m7+vLNmjfIaCTUMuvP
        CbXWKUkmZNEeSJICcxGKWoe1W+E6dEWcSvSz3z7uvC5cw6wceI8G4ntr8wosGzzEz+ECXfT1tuYAg
        kKPYVdiw==;
Received: from [2602:306:c5a2:a380:9e7b:efff:fe40:2b26]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMDGY-001O05-Bx; Tue, 16 Mar 2021 17:13:59 +0000
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Ishizaki Kou <kou.ishizaki@toshiba.co.jp>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
From:   Geoff Levand <geoff@infradead.org>
Subject: [PATCH] MAINTAINERS: Update Spidernet network driver
Message-ID: <6399e3a4-c8b0-e015-c766-07cbb87780ab@infradead.org>
Date:   Tue, 16 Mar 2021 10:13:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the Spidernet network driver from supported to
maintained, add the linuxppc-dev ML, and add myself as
a 'maintainer'.

Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa84121c5611..7451cd55af18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16887,8 +16887,10 @@ F:	tools/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
+M:	Geoff Levand <geoff@infradead.org>
 L:	netdev@vger.kernel.org
-S:	Supported
+L:	linuxppc-dev@lists.ozlabs.org
+S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/toshiba/spider_net.rst
 F:	drivers/net/ethernet/toshiba/spider_net*
 
-- 
2.25.1

