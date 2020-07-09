Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896FE2198AD
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgGIGaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgGIGaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:30:14 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC41C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 23:30:13 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o8so619635wmh.4
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GGkkfPBgCYDEMdWX01WzA5f8FzKOhiCh33CsoasxCEE=;
        b=jyvIfq0ozNkLFSgxvzaQJ4ndL4FKG01uA9cukN5w5abnZY0Bd1jc1bShoF/y6u2OIO
         tcZX3Vo/u+cjMq04yi0PPxbiFEKXHOQWpzXwVC48McDqmFYeeXZEn41UPR01JylKYmFF
         NYDuAMeekfqu5KwSDGei3QUyMR3HGb8DcXVS3rmSOynEuHE7wdGP76H9QoLfZmEKbf9A
         6scRdddp5wzs2MDp+TP5eUOd4LCCP/IJOKaH5SUYwPTdZbIvxf7EO7jXtUaASdasKJam
         Ihg8PHdnntVIIoYl2xDd/dyjBpmmK6614Y4PDJ2b2rEyGKKML2nwYs3jU84YpS6fqgl8
         w2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGkkfPBgCYDEMdWX01WzA5f8FzKOhiCh33CsoasxCEE=;
        b=CIVS+BL44C+tzDLbUjmrjwexEBOXCw7B+bqzTiQjks3+b1AQdgNJ4WRo6o514MHka6
         4o+kiKiZd8DDaio0NOJ3QiHdeuaZmaSYYVS5ZG+b/3eAV1xuAfjm2w1Zg0et2kXy46tN
         72vPr3dzVa1wIQOeXlDSI6OkJBUS6oRIPr4J127H6Q7RWntwdrWaAet5kWbL50e2UwI7
         5rQ3WKvDWbTnB5+9Uc4zE5AkVthP1EcTRyXxSKSzunN+aRy0yy/cra+Urop/S+MC221L
         94dT2og6TGlIf/jAAgZW72HwOKq8DxZP8hmWuuwoD9OQ6yXzlmrOpq87G6MsD+iz3wfB
         cPrg==
X-Gm-Message-State: AOAM531QcrJs3ZAPF3osYe2npV7+IGcPQFue0+PHaQBQjP1sx9hy9OVa
        ONXE5QlDCdDXRKipza33Ad4=
X-Google-Smtp-Source: ABdhPJyKrgCv4BKXlmYhqEUEjB5eQRZQI4Ua5enFBVqZSRvKN6GW4N6Vkprd/idJTlk2WUd8RQLmGQ==
X-Received: by 2002:a1c:4c16:: with SMTP id z22mr12388101wmf.103.1594276212563;
        Wed, 08 Jul 2020 23:30:12 -0700 (PDT)
Received: from localhost.localdomain ([77.139.6.232])
        by smtp.gmail.com with ESMTPSA id l8sm3777854wrq.15.2020.07.08.23.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 23:30:11 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2,v2 1/2] ip xfrm: update man page on setting/printing XFRMA_IF_ID in states/policies
Date:   Thu,  9 Jul 2020 09:29:47 +0300
Message-Id: <20200709062948.1762006-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709062948.1762006-1-eyal.birger@gmail.com>
References: <20200709062948.1762006-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit aed63ae1acb9 ("ip xfrm: support setting/printing XFRMA_IF_ID attribute in states/policies")
I added the ability to set/print the xfrm interface ID without updating
the man page.

Fixes: aed63ae1acb9 ("ip xfrm: support setting/printing XFRMA_IF_ID attribute in states/policies")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 man/man8/ip-xfrm.8 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index f99f30bb..d717205d 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -61,6 +61,8 @@ ip-xfrm \- transform configuration
 .IR EXTRA-FLAG-LIST " ]"
 .RB "[ " output-mark
 .IR OUTPUT-MARK " ]"
+.RB "[ " if_id
+.IR IF-ID " ]"
 
 .ti -8
 .B "ip xfrm state allocspi"
@@ -238,6 +240,8 @@ ip-xfrm \- transform configuration
 .IR PRIORITY " ]"
 .RB "[ " flag
 .IR FLAG-LIST " ]"
+.RB "[ " if_id
+.IR IF-ID " ]"
 .RI "[ " LIMIT-LIST " ] [ " TMPL-LIST " ]"
 
 .ti -8
@@ -561,6 +565,10 @@ used to match xfrm policies and states
 used to set the output mark to influence the routing
 of the packets emitted by the state
 
+.TP
+.I IF-ID
+xfrm interface identifier used to in both xfrm policies and states
+
 .sp
 .PP
 .TS
-- 
2.25.1

