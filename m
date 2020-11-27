Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27B2C74DF
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbgK1Vti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729722AbgK0TrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 14:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606506421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=V+fxQ+9ZE4mMvoPeeRpISpaVS5sv+7iMxFHbjI4wlvg=;
        b=Qt8Boa+UprtWzusbLN9qGVZmjCcM0FhlVinjmLaM/yfzqVnWfJ8v0yjr3UmpoQ6gagORjN
        JUH0V5mgHXZyS4ACORArIZM9u14JASQoDGOjZey1lhzDBsOOzXIXbQPA+gdg2U9bJH5IGM
        x10e+2mmfyL8afqaVqp3z67XHDwYgo0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-Fp72vBb1OIKU8VzBYqTxXg-1; Fri, 27 Nov 2020 14:43:37 -0500
X-MC-Unique: Fp72vBb1OIKU8VzBYqTxXg-1
Received: by mail-qv1-f71.google.com with SMTP id 12so1643341qvk.23
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 11:43:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V+fxQ+9ZE4mMvoPeeRpISpaVS5sv+7iMxFHbjI4wlvg=;
        b=a7g9vnn2DcCO1OQ1df2j0t4Ep8IYltpmEX4ZOjXXPR8MTP2kOhymYW+DMmiV5k334k
         fil4HueiMKsTovdLsNF8nQq3cU1Qf29y4VhCiKn9Dj5chBwCcgSEx3vjZu50Tb0vOIvJ
         aIH9YR9eoiEqT2vkV1xnuQEpJQJE78Gr15ODihAqdl9YBNmIosfTe4c4RlH9s7Av4baU
         x2i4pUzXqXefYsB7ZMEKeK6/ulHjmYhQ2+4c2PUSvjq5rVLpYKeMjbBg9pp9lvmqTe1T
         ar5PJCesM4KSEKHnV3gZsakh1C12PaYs1fscHKFNCV0J+AvPfR21va/OuerOXM8IU2gw
         sNaQ==
X-Gm-Message-State: AOAM530njp2XD1EK7piTLerhL5gIY3qoZhe5Rz7VnW6dj8Pt6H41w36p
        yzM0dABEZAxoWoIC51WDAHQSq0g96xRzmGl/dTGOOzeMFM44U/Gx1hKwyNduplMxTc7QsWJBS5J
        GPtwXOh9DUnVUCJ8E
X-Received: by 2002:a05:620a:a90:: with SMTP id v16mr9957731qkg.479.1606506216871;
        Fri, 27 Nov 2020 11:43:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6lodK6voISGIkjg9/FPTLrFucmHCETDXMNpIo6ewNM+fOmDKlJ1dM4RCPu/VocOlLLHaAVg==
X-Received: by 2002:a05:620a:a90:: with SMTP id v16mr9957714qkg.479.1606506216683;
        Fri, 27 Nov 2020 11:43:36 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id l7sm6906770qtp.19.2020.11.27.11.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:43:36 -0800 (PST)
From:   trix@redhat.com
To:     bfields@fieldses.org, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] NFS: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 11:43:25 -0800
Message-Id: <20201127194325.2881566-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/sunrpc/auth_gss/gss_generic_token.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/gss_generic_token.c b/net/sunrpc/auth_gss/gss_generic_token.c
index fe97f3106536..9ae22d797390 100644
--- a/net/sunrpc/auth_gss/gss_generic_token.c
+++ b/net/sunrpc/auth_gss/gss_generic_token.c
@@ -46,7 +46,7 @@
 /* TWRITE_STR from gssapiP_generic.h */
 #define TWRITE_STR(ptr, str, len) \
 	memcpy((ptr), (char *) (str), (len)); \
-	(ptr) += (len);
+	(ptr) += (len)
 
 /* XXXX this code currently makes the assumption that a mech oid will
    never be longer than 127 bytes.  This assumption is not inherent in
-- 
2.18.4

