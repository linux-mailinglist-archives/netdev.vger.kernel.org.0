Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF12D6B88
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389406AbgLJXEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388813AbgLJXEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:04:01 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C0EC061794
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:21 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CsTwG3zznzQlXL;
        Fri, 11 Dec 2020 00:02:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymq8b+BvK8ACzLQkchbYZfNWxfEh5dW9Z6/7sAwy+6s=;
        b=XJW1SDr1DnT9IJ6JP3MXfW5Ou56rpwyn9erF+BQ0pda66B9lwDPtfYCSflQLoI3vEcKa1l
        dVct2MWkFu8p/a+zs/PLh2s36KvvaJQnVdX7w2buEhp0GHozNyg9unLaOMfI8xrQvVOnIC
        gQnzG5k0WP8zyEwpheImrNJIKmKglxkdU6repzXvFqIoyndKz/oHqXN5BaCI9ad68+iboA
        iu2y8EbVRnK4EEUuVUMhFV2PCakXxmBy4qW3WoBtSyFij5gd2KUc36H2//8kfUl6brrFQk
        cwnrL5DHhFU1C9InJOHX/x689+2LTPx7NPP/ru4YP+NYBLBasJd+daAHjXKyGw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 2EJN9WVQnNnO; Fri, 11 Dec 2020 00:02:51 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 04/10] man: dcb-ets: Remove an unnecessary empty line
Date:   Fri, 11 Dec 2020 00:02:18 +0100
Message-Id: <dacff746ee8f644c2ee1db066ea77a7f8ad7d356.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.58 / 15.00 / 15.00
X-Rspamd-Queue-Id: 90D9A17BB
X-Rspamd-UID: 794aec
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Petr Machata <me@pmachata.org>
---
 man/man8/dcb-ets.8 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/man/man8/dcb-ets.8 b/man/man8/dcb-ets.8
index 1ef0948fb062..9c64b33e30ff 100644
--- a/man/man8/dcb-ets.8
+++ b/man/man8/dcb-ets.8
@@ -61,7 +61,6 @@ the DCB (Data Center Bridging) subsystem
 .ti -8
 .IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
 
-
 .SH DESCRIPTION
 
 .B dcb ets
-- 
2.25.1

