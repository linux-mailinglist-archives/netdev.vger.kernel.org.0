Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D7219EB99
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgDENuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:50:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56127 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgDENuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:50:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id r16so11957724wmg.5
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 06:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=KzzLii1pZBYkP6Y3gUvRSauVcIEMLGqI/eP0PygznkM=;
        b=fh6+eVv1KS5P+AOcdMnuLQ77JGqGxGcxp64GTiYbhoU7+L5XzaOMHEJYWoQf209abH
         qjtCuhOqfd3WSHlT+byVQNioOe/uHXoNfxfmz2Oyw3iM4aDJKNBdMnSLjAz+JqtbKtp3
         5c/1mJurU6UZe+keIqjwZd6CdRE/qNNhxhf+UkbXGDrIQ0hPKrhLY1K58uC3taZynsMV
         nBEvtjysGyRrUDoJz4XxoHWeAzXUGUu3sRbt6OErAHoiFu3iO7usYDbY9jx8LLMGLkyB
         91qcjuGQXvMWUjJr8CzAAg02/QcMprIRYG99NUFhWvyhGq/VvjB5TuPGt7PC2E5Nz9+n
         a1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=KzzLii1pZBYkP6Y3gUvRSauVcIEMLGqI/eP0PygznkM=;
        b=FQimbNwiUSE/oWTfD1H2bYLMdiVKH/+8ozX7FZ4N4Ir9xMbko2x5FvNMOCeowv/nPf
         ObEhQuSX0YWXt4EPMfQnt0t2xhCm6WDWzXZoD9+c4Vi/2cyr/wKo0ZDPCeYnPy3a+Civ
         AagEncGkTplRvPg85fP7LVhzNvZJ9siVr1nzzlKVYASt+V1K13LPFJjcGkFOQjV10mfv
         wSVlE7w0ptxjaAmm9lBQGEgFz4ND+eKrW62jyhKodgyTz4chZKJ8Kbt8c6IHWXStxmjU
         kH+BcJWCabplTxXKOBwqDfwyjenVMLupxc27MJNDrs1qRi1eaChUmilrc0IbiynCriBR
         r9mg==
X-Gm-Message-State: AGi0PuaD3fcHZH7G5mFwbbCO/3OTdNu752RhERGMkmxVgwctffvv1MTC
        mNMtGyA90bOa2vrWwKD935VmQfu5
X-Google-Smtp-Source: APiQypJ6JKrCSMP+qQ+hJGIkP9IVY7H99kFnOrWrE6Slo8Hr7Wo7rmcyJTAizShsEj5Aiadf5y4WKA==
X-Received: by 2002:a7b:cd07:: with SMTP id f7mr17906475wmj.30.1586094599086;
        Sun, 05 Apr 2020 06:49:59 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id o129sm12279658wma.20.2020.04.05.06.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 06:49:57 -0700 (PDT)
From:   "=?UTF-8?q?Bastien=20Roucari=C3=A8s?=" <roucaries.bastien@gmail.com>
X-Google-Original-From: =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH iproute2 2/6] Improve hairpin mode description
Date:   Sun,  5 Apr 2020 15:48:54 +0200
Message-Id: <20200405134859.57232-3-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200405134859.57232-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
Reply-To: rouca@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mention VEPA and reflective relay.

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index efb84582..4dc8a63c 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -332,7 +332,9 @@ cause the port to stop processing STP BPDUs.
 .TP
 .BR "hairpin on " or " hairpin off "
 Controls whether traffic may be send back out of the port on which it was
-received. By default, this flag is turned off and the bridge will not forward
+received. This option is also called reflective relay mode, and is used to support
+basic VEPA (Virtual Ethernet Port Aggregator) capabilities.
+By default, this flag is turned off and the bridge will not forward
 traffic back out of the receiving port.
 
 .TP
-- 
2.25.1

