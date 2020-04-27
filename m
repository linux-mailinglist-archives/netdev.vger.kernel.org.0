Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5DD1BB229
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgD0XvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgD0XvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:51:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1EDC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:03 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x2so6080836pfx.7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HxXxdgfRY7WXdcvgGcsZC5Y/1fx/3xDhexuO909pXuM=;
        b=JIdL9Qw/5PGtycrj2f7NwXoFKlsUxdf4mo+0G2Sa2fA8r8d4U6b2+fs199pf7IUrjm
         49SbEBDJW3YUpDCo3L+u6YK43ZK6bMXqTtASL9zKGs19g+KjKdWY+GZHlL1wsNsZkrJm
         GLTp9W81jQ+pQFguGWU0JnDxHhlLAGIJJF/kQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HxXxdgfRY7WXdcvgGcsZC5Y/1fx/3xDhexuO909pXuM=;
        b=By7mbxS4q8gih3iFNUJ315g9hp6z1u9S+Wwoy6ejWpydciGPGm7CtWzI3KQfIDs3Hz
         fXGdnhyU/uXHmoONvjxe2erq5PZZea6XsH4EGOvKgV+9nbAfMfExox5Mu0EmO8taNvSF
         M69+iSc7kjRgZvtnYi7ZBh7ruMZLc7S6QWQwth/oX+hvH+PJ6yDSnGaVOIf0TIsrg0S0
         xacSeddimadTMV0UCCfuBRSpjLGiJCVROYZ7qvw0dwSNxhNU/qbkTPLU63bQO9rJbd10
         B2D+ZAsQgdFX68d6kmd7U3BOhBp0htKOkiIKDxTm9nuNdXqXuF1SPE7ZXFPh13XnpYbs
         EOTg==
X-Gm-Message-State: AGi0PubGpz6+rYOE1AKk0l4wtz3XHSXdT4RzZC9z3g5mCP+LUPR+FEAs
        A6o5WjJgU85v511j997SY7GZ0rhT3YA=
X-Google-Smtp-Source: APiQypJ6JiCaCU16pa+6j4lEuP5oFcq0nnewK2Nx+YI8jUOy62p+2CI8RwpzgZOWW9zicEC5FNJRXw==
X-Received: by 2002:a63:48a:: with SMTP id 132mr15627574pge.380.1588031462699;
        Mon, 27 Apr 2020 16:51:02 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 128sm13058106pfy.5.2020.04.27.16.51.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:51:02 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 3/7] bridge: Fix typo
Date:   Tue, 28 Apr 2020 08:50:47 +0900
Message-Id: <20200427235051.250058-4-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 7abf5de677e3 ("bridge: vlan: add support to display per-vlan statistics")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index a708e6d2..3ed60951 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -546,7 +546,7 @@ static int vlan_show(int argc, char **argv, int subject)
 
 		ret = rtnl_dump_filter(&rth, print_vlan, &subject);
 		if (ret < 0) {
-			fprintf(stderr, "Dump ternminated\n");
+			fprintf(stderr, "Dump terminated\n");
 			exit(1);
 		}
 	} else {
-- 
2.26.0

