Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311C73B3653
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhFXS4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbhFXS4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:56:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA56C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:54:01 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y14so5473597pgs.12
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cTJsab/ixif4eEsI06/Uk8jJD6NxQ8p/tNxJZO93op0=;
        b=0q/cLBEPwEk4CniONTbc51hVrOkWYbx9dCWkeAC1FE7jhrj2N0ODXX1h3fTL34z+dx
         Bmay0Fjmuj5mOhor35v0GHy5iI56vOH0Xm+9BlA7zNy4mtWo1QBz3bSszDpBMjxYkhOp
         NUlyvu4F2s7b280LJyygb1dJSPOyks9WYg3rFLNi+3pyN3k+FxSj4PTykTjfePulDhcT
         Sodx9UV961TyC7IDiYquDO5XllIcRgGnqS0PsYh90u2ZjzMZnWl38DdfTnVUKaLF/6/7
         iMhtS8sRg7L2fFn7VICMMkr2RSZEeMHdncdui7mmW6ovEb30nKt3KR5ZSk4YV1ybyJ7W
         XGpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cTJsab/ixif4eEsI06/Uk8jJD6NxQ8p/tNxJZO93op0=;
        b=b+qNITPbneK6+ffTmLV6fqRMrOEnOYPx9C8Mzr0Em6zX+DsOpTSvwG6JXoTAPLeBt4
         D8T7Oh1pJsLQtlT2ImGqf5FA8jnwkftFPTA0QNaC5lG53sPOS4mRgnqCQnhSGi0CQuGl
         wfF7ipMTp1OgXwGCm2DbMkSqBpdTxQd+iYTjfhEYE27L9EaBazmj+BW4QbWU/PRz8R3a
         VrVromn18bkAeWhGtKizvUi5T8Yk2UMvyI3GQx4euAXXC7vzBothl7XYY/fwpty8GZ2D
         HaccE9v9gsdoxKKw5YerMJqye4HZZ01hoGx9nwxH1D7pu+Ld8FL4ndlGhUetXzl5OWxL
         PDaQ==
X-Gm-Message-State: AOAM531Cr7tIi/nxe6hB5stuVhugTPmrTBmNeixwJ8F4SWRT0+udC81B
        mYJ5y9WFu4wRjqC252g0/FqXAgzNOPjiMQ==
X-Google-Smtp-Source: ABdhPJxAswfpMcAM/i109m5wxllZqofeL1IxSlRD8Wz2fxXyOSCUL1Dj6wKWtr4b3hL4cbDj5EHeSQ==
X-Received: by 2002:a63:6e06:: with SMTP id j6mr2938928pgc.370.1624560840958;
        Thu, 24 Jun 2021 11:54:00 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id a6sm3478693pfo.212.2021.06.24.11.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:54:00 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] man: fix syntax for ip link property
Date:   Thu, 24 Jun 2021 11:53:56 -0700
Message-Id: <20210624185356.26643-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ip link property add/delete requires a device; but the
device argument was not show on the man page.
It is correct in the usage message.

Fixes: 3aa0e51be64b ("ip: add support for alternative name addition/deletion/list")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/ip-link.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index fd67e611e947..76d40b72c41a 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -251,12 +251,12 @@ ip-link \- network device configuration
 .in -8
 
 .ti -8
-.BI "ip link property add"
+.BI "ip link property add dev " DEVICE
 .RB "[ " altname
 .IR NAME " .. ]"
 
 .ti -8
-.BI "ip link property del"
+.BI "ip link property del dev " DEVICE
 .RB "[ " altname
 .IR NAME " .. ]"
 
-- 
2.30.2

