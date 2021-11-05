Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6183B446029
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 08:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhKEHi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 03:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhKEHi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 03:38:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFD1C061714;
        Fri,  5 Nov 2021 00:35:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o10-20020a17090a3d4a00b001a6555878a8so2757473pjf.1;
        Fri, 05 Nov 2021 00:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yj6d8xJx4ibW+J5ZUUzngpRiqpGE8l4IguCidEsjbJo=;
        b=gCpvBGnMpy33SN8qb2yD+2s+9573XZSRpJxOnoic4r16DU5ERAn7T6r9h8qhtB1dPi
         1DfpDIGl2jJn63E8Qc+Txst058mHWdAKONL4N+hXvBlhpNr0CcGjpU7kC/8/SNNXJpEm
         jnJaSRdgPDQts5TYaSAIYtZL/OvVmRRHtQ7k18xrVE2H81ESpPyVMdDI+WjfddLZHx3Z
         z+CwfXyqPg9Z3Lx408wKr0+y9/d7c/te9BnyWIWlXU6zQaOL2jaZeeuI0v29antg4w5W
         3sPNrHtsKfzgkoJms6psu4xFI4YnL5CKQWNTAf9BcSTdMuELa6mvypOCkCejLQuEmPq/
         rO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yj6d8xJx4ibW+J5ZUUzngpRiqpGE8l4IguCidEsjbJo=;
        b=20RY30jekdsoh6K0KJyZFJMIYUjFIugTgrmVe/n4v++wOsUIm+rkG0c4piug0hJOi0
         FQSlbqQFhfqJ9JTfV9H2P7fTUx0oyw5uetr943quCs4/ghL5QU1xW6UdS5xkKEoUqGGf
         HEDSDVOO0/jRACtqyOGwl8wb4EvxDdkOqRrl88gGgOamRaqgUuOK7h79u3xDsaYekrkC
         7ytwtTUQeHfmhyTDL4JL2YcRH4IOS3TvyNJY+hZxbilbdhSHjb4nonirhQieg4vgyz0y
         U0tfNVNKGH77lyMrIkYIk/hlXYdsiImJ6GlvQg5CAy4UMONREMZqHtuIdyxbz7tsO0wE
         GPuQ==
X-Gm-Message-State: AOAM530metY1S9ALoX+Mp3hVzZiPfvS6xBP30cRx/X8ouCUY4BaSfKgY
        jBULft2kbdGHbMj53lO4Cwt5rtn+0hg=
X-Google-Smtp-Source: ABdhPJxzrGaRXjfZb+frFeyCIfFYNj8GjZpqEB8q816tBTdi78BU09kznxeGAeWh8F+Qb+VgTY8c/g==
X-Received: by 2002:a17:902:db0e:b0:142:13e4:b456 with SMTP id m14-20020a170902db0e00b0014213e4b456mr19455460plx.43.1636097747362;
        Fri, 05 Nov 2021 00:35:47 -0700 (PDT)
Received: from desktop.cluster.local ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id mg12sm8584429pjb.10.2021.11.05.00.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 00:35:46 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] net: udp: correct the document for udp_mem
Date:   Fri,  5 Nov 2021 15:35:41 +0800
Message-Id: <20211105073541.2981935-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

udp_mem is a vector of 3 INTEGERs, which is used to limit the number of
pages allowed for queueing by all UDP sockets.

However, sk_has_memory_pressure() in __sk_mem_raise_allocated() always
return false for udp, as memory pressure is not supported by udp, which
means that __sk_mem_raise_allocated() will fail once pages allocated
for udp socket exceeds udp_mem[0].

Therefor, udp_mem[0] is the only one that limit the number of pages.
However, the document of udp_mem just express that udp_mem[2] is the
limitation. So, just fix it.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 Documentation/networking/ip-sysctl.rst | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index d91ab28718d4..8edc1547170b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1012,13 +1012,11 @@ udp_l3mdev_accept - BOOLEAN
 udp_mem - vector of 3 INTEGERs: min, pressure, max
 	Number of pages allowed for queueing by all UDP sockets.
 
-	min: Below this number of pages UDP is not bothered about its
-	memory appetite. When amount of memory allocated by UDP exceeds
-	this number, UDP starts to moderate memory usage.
+	min: Number of pages allowed for queueing by all UDP sockets.
 
 	pressure: This value was introduced to follow format of tcp_mem.
 
-	max: Number of pages allowed for queueing by all UDP sockets.
+	max: This value was introduced to follow format of tcp_mem.
 
 	Default is calculated at boot time from amount of available memory.
 
-- 
2.27.0

