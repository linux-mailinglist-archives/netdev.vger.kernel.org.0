Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007D41A6126
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgDLXvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:51:17 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67124C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y24so8479098wma.4
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yeuAm93V6IpEC7hxCyYl+KMTNm6d7S6GxycZRvnFds8=;
        b=LWTrf8pvvN3hx5zvIy7WoVh0gYEFLT4wSOE+7kUGjogd/1AuOufzhKbHGeJ8r2Uh0W
         bZJHg7BIQQfrhuV7OyHlwSCcd8t7DWTVlEiLX77oU3Oz6hB0t3h81g4uKwrw0ppra4sS
         ABlsFeGptiQrb5a90v2e++YoWkG9FvJMbyWU9LDNnJpvLKK4SLfieZREoLKhtCqGGPVe
         REh+kmQ5Y0f0AwkfhJCUeEZVSpkrtDdXSiJTCIKCtbET3OoxufuBSq1lQxkz09r8BtZQ
         pWK5v21LqR9835POJNAzb0K7FVuho/H0iyjETz3HEgxX9ouyr2CGFwoXf962Cd330IWh
         isrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yeuAm93V6IpEC7hxCyYl+KMTNm6d7S6GxycZRvnFds8=;
        b=oPoQW8wJfE/jYVvJwtvafXIOmLAU7FSm14KfFaLkcc8ntSK7KiYLdUe48nREcs1HnN
         3C0nGimWESwBFzipMoWH99OZFMnN3pG5aJ4NGPRcgOVsvUYKIlLiZqc1ea6O2gBikUHk
         bvMPnmqvajNOIhhQVYTKcaHlp4Xl7/myO8HL13GOiUuO6rFWCgpznKJOIBhOVwPK4IrF
         Fg9skE7IMIeuIEbz+Oq2mcFCnMM9OULESu1ES0BVpgYlxMZgNJnjBeXfQF1SpVyOqyk/
         6+f7gPbn8+UrE1O9xyAuv3QtUnZSQtLcXrDonyLdPmW9hJCOy+CHWX/QeJZC2Ff+R6RL
         kD7g==
X-Gm-Message-State: AGi0PubCuLwSLPKv94R49SdIO4B8qOGQbvsswKK/zHcOiV2ZPMi15jdt
        j6ajvW0yYv/kkGCR4oqCwN1DDosp
X-Google-Smtp-Source: APiQypKYArWXzY7GWj7cL2QTXMX9oTs/ofWKVf9dKqysCXIVKpoA4KhbqcJ8o60fK8KyIN7CsRCiMg==
X-Received: by 2002:a1c:7f91:: with SMTP id a139mr15405018wmd.164.1586735475580;
        Sun, 12 Apr 2020 16:51:15 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id w11sm12100578wmi.32.2020.04.12.16.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:51:14 -0700 (PDT)
From:   roucaries.bastien@gmail.com
X-Google-Original-From: rouca@debian.org
To:     netdev@vger.kernel.org
Cc:     sergei.shtylyov@cogentembedded.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH 5/6] Document root_block option
Date:   Mon, 13 Apr 2020 01:50:37 +0200
Message-Id: <20200412235038.377692-6-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200412235038.377692-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
 <20200412235038.377692-1-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastien Roucariès <rouca@debian.org>

Root_block is also called root port guard, document it.

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9bfd942f..ff6a5cc9 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -372,6 +372,11 @@ enabled on the bridge. By default the flag is off.
 Controls whether a given port is allowed to become root port or not. Only used
 when STP is enabled on the bridge. By default the flag is off.
 
+This feature is also called root port guard.
+If BPDU is received from a leaf (edge) port, it should not
+be elected as root port. This could be used if using STP on a bridge and the downstream bridges are not fully
+trusted; this prevents a hostile guest from rerouting traffic.
+
 .TP
 .BR "learning on " or " learning off "
 Controls whether a given port will learn MAC addresses from received traffic or
-- 
2.25.1

