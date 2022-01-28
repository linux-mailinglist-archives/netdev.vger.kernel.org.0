Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813B04A0115
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 20:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350983AbiA1Tok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 14:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242071AbiA1Toj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 14:44:39 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28156C06173B;
        Fri, 28 Jan 2022 11:44:39 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 255F72E0EBE;
        Fri, 28 Jan 2022 22:44:37 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id KJi3dlWeRN-iZHuviFw;
        Fri, 28 Jan 2022 22:44:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643399077; bh=lRNhmfPzi+UGUjyKTrBPetbPlJnwRouDfUSwLA92AOg=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=AdnGjkgfa6AQa8JgknXjqnhkvJA0/doISC4USawPEh3nDYT4670LkXYqJV2geRcGh
         pT+P2TXL5FhzE7Q20f64wSMc1TOndnIlcVr9gzZwiauL/ll9zB8I7frgarW7JbG+lk
         kPez2ediCH3OwRaRYqkpy5szwaf/9pGvEqDmUqBk=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id AubVxLDYQ9-iZIGsKMo;
        Fri, 28 Jan 2022 22:44:35 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v4 3/5] txhash: Add txrehash sysctl description
Date:   Fri, 28 Jan 2022 22:44:06 +0300
Message-Id: <20220128194408.17742-4-hmukos@yandex-team.ru>
In-Reply-To: <20220128194408.17742-1-hmukos@yandex-team.ru>
References: <20220128194408.17742-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update Documentation/admin-guide/sysctl/net.rst with txrehash usage
description.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 Documentation/admin-guide/sysctl/net.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 4150f74c521a..f86b5e1623c6 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -365,6 +365,15 @@ new netns has been created.
 
 Default : 0  (for compatibility reasons)
 
+txrehash
+--------
+
+Controls default hash rethink behaviour on listening socket when SO_TXREHASH
+option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
+
+If set to 1 (default), hash rethink is performed on listening socket.
+If set to 0, hash rethink is not performed.
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
-- 
2.17.1

