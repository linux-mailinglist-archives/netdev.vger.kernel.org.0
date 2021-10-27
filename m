Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A2A43D2CD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhJ0UbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239236AbhJ0UbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:31:14 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5148C061767
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:28:48 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id m184so5342953iof.1
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eWHn/jG+avRrBmFKeL+1zT6EQSwQOpXH8c+wEZwCdI=;
        b=eqYjUCU+DPOsJ4VO0oHmq55s4tf+B6tFn0ihxt9NWSqR7ecEfk11UN04t+aZw1GBoQ
         Stt7bJIawXTsNbbIejGqskDjCNlyFyC3hRiJXCfqEbcpGYzwC//tMWnt9T/1eKRsMSY1
         OSKX4iFu9dGi8lypL8EMM7CSOUCaWkKS2zZ2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eWHn/jG+avRrBmFKeL+1zT6EQSwQOpXH8c+wEZwCdI=;
        b=HV53YrLOtw5YJPAOzoy3SDAMtGup0L9qdfS7fLJxx8GdnAGEVfYnfVrRJL9lbOv0pk
         OzAsRtjZc1DPMaplx6iggJQa87c7wr7EWihD2uZZ/9c3FnUq9NicJVAdBWP+e2UoF6xx
         fBNW2ADM5SVpU1sqWCwFK1xMazgRDycUohjeZ0aD1QvtJ2ZwZaA3+WB046K1YAHHoh9e
         NZ+NeoKUrV8Z61CeWs7XHiDp61mBYUH4jHX3n44W+hMx5fhofH0uF0Yjp4hkKgZu0uwR
         qT8I/erv0quQsYD5lQt/Zb2s/vYPG6ni5T3xONEmxHc7juIS1pFqoI6kY5GM+i1LdfAs
         4+XQ==
X-Gm-Message-State: AOAM533ngmiPu4BgXXiFU87/LF/taa6XKxWyJLbIQGDCurYEJUB2VEho
        QkySeG1RRjbJvuxgWGCZ2TuDeusHRV2dgw==
X-Google-Smtp-Source: ABdhPJyqqNy9vZHA1zN7jISqipB+tuyoKAYDpjxwiWrRlmWJYR3xLV9oOefmaiFi5GM5YElIqnN9hg==
X-Received: by 2002:a05:6638:1502:: with SMTP id b2mr31604jat.131.1635366527972;
        Wed, 27 Oct 2021 13:28:47 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i5sm457383ilj.49.2021.10.27.13.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:28:47 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/net: update .gitignore with newly added tests
Date:   Wed, 27 Oct 2021 14:28:46 -0600
Message-Id: <20211027202846.26877-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update .gitignore with newly added tests:
	tools/testing/selftests/net/af_unix/test_unix_oob
	tools/testing/selftests/net/gro
	tools/testing/selftests/net/ioam6_parser
	tools/testing/selftests/net/toeplitz

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/net/.gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 19deb9cdf72f..501550501216 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -31,3 +31,7 @@ rxtimestamp
 timestamping
 txtimestamp
 so_netns_cookie
+test_unix_oob
+gro
+ioam6_parser
+toeplitz
-- 
2.32.0

