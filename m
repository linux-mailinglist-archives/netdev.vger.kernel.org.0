Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267244E4163
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237427AbiCVOdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237402AbiCVOdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:33:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6B586A03D
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647959537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBUrqpArInAfXo3P25Vfdg/Bc6VWgQIPEuD8dRnnCFE=;
        b=aWKn/ZGUyrEs/vdWrEN6YQFRqd1Q87KGf3nJD2U920QdaYNS+HA4qmX5W1nNn9TSckq5sS
        LyNZeTXMO7hFm8ZW4xKBOspll5lK4pQDAIluLC0Ancvw9bbUV+06yUwlGPuQoGz692kW/F
        eDZSFOXgb1RPNUXsHc+n1Q/sx8lNDhA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-7ViNrHy8PsyTRjuVxhnzWg-1; Tue, 22 Mar 2022 10:32:16 -0400
X-MC-Unique: 7ViNrHy8PsyTRjuVxhnzWg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 225F43C19845;
        Tue, 22 Mar 2022 14:32:16 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.196.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73C0A4B8D42;
        Tue, 22 Mar 2022 14:32:15 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 2/3] man: fix some typos
Date:   Tue, 22 Mar 2022 15:32:04 +0100
Message-Id: <89a3d5523882071540688bab83c819cc817aed72.1647955885.git.aclaudi@redhat.com>
In-Reply-To: <cover.1647955885.git.aclaudi@redhat.com>
References: <cover.1647955885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dcb-app man page, 'direcly' should be 'directly'
In dcb-dcbx man page, 'respecively' should be 'respectively'
In devlink-dev man page, 'unspecificed' should be 'unspecified'

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/dcb-app.8     | 2 +-
 man/man8/dcb-dcbx.8    | 2 +-
 man/man8/devlink-dev.8 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
index 23fd3374..9780fe4b 100644
--- a/man/man8/dcb-app.8
+++ b/man/man8/dcb-app.8
@@ -170,7 +170,7 @@ priorities that should be assigned to matching traffic.
 \fIDSCP-MAP\fR uses the array parameter syntax, see
 .BR dcb (8)
 for details. Keys are DSCP points, values are priorities assigned to
-traffic with matching DSCP. DSCP points can be written either direcly as
+traffic with matching DSCP. DSCP points can be written either directly as
 numeric values, or using symbolic names specified in
 .B /etc/iproute2/rt_dsfield
 (however note that that file specifies full 8-bit dsfield values, whereas
diff --git a/man/man8/dcb-dcbx.8 b/man/man8/dcb-dcbx.8
index 52133e34..bafc18f6 100644
--- a/man/man8/dcb-dcbx.8
+++ b/man/man8/dcb-dcbx.8
@@ -67,7 +67,7 @@ allows setting both and lets the driver handle it as appropriate.
 .B cee
 .TQ
 .B ieee
-The device supports CEE (Converged Enhanced Ethernet) and, respecively, IEEE
+The device supports CEE (Converged Enhanced Ethernet) and, respectively, IEEE
 version of the DCB specification. Typically only one of these will be set, but
 .B dcb dcbx
 does not mandate this.
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 22735dc1..6906e509 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -199,7 +199,7 @@ pending this action will reload current firmware image.
 
 .B limit no_reset
 - Specifies limitation on reload action.
-If this argument is omitted limit is unspecificed and the reload action is not
+If this argument is omitted limit is unspecified and the reload action is not
 limited. In such case driver implementation may include reset or downtime as
 needed to perform the actions.
 
-- 
2.35.1

