Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA24034B2CB
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhCZXTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhCZXSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:18:00 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D76C0613AA;
        Fri, 26 Mar 2021 16:17:59 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q3so6939190qkq.12;
        Fri, 26 Mar 2021 16:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a+VWWWHlMS/iq1KVs+7h3vpEbYcUnUosOcWBIMdkuRE=;
        b=ifrOEYoWcc3FMXnUZr2Foj6HyIpxfECNmfCliafRBXkSKcpQJHAgMwmMiwdmC5/aNR
         1vBghhzyHEvQdSnXIOU3HkmUHQtjLldgZttiLQ2glgZbRz+StDOfQzmrdm9F3Bhf108z
         HULqXoWptYqWboCa0LwFqytJTQMKCI+fYKm3+ddSMKGLIYQ9kFDhD4bPjOFegOFsKO+C
         yvh4mOAVQX+JEt/L8xIlDhFyfH4k5H2whe7fVLZgjmcnpGE974GGVPiHfBGwbvt/bM63
         sYW7CHWmAR5UclKe0K3BaUw7AyWxRQFT8OiLPU4a1/WERaDn2iQsyZeCCZ0vRXoKhqbX
         PuNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a+VWWWHlMS/iq1KVs+7h3vpEbYcUnUosOcWBIMdkuRE=;
        b=uA+kvGx5aYPJUAvEmDaJLSyNBNeRZA1ohI70J3tM/aGI3ioRjrvatC6VHnkwY1sOJE
         OVQsdGM431xe2bQFNpj0RItGLU21YL1gYWPAnZA5+LqF+RHrbtdAaAwVHwLeZjWUatK4
         FLqkoQZsoOTOEhvlg6b0a0h/7k/SHcvkWmTbkOb6wcjo86qhQofiVbKP2VaL8mug7Onn
         njaz4VFlH4etPPHMWef6gLGMaDmSUNb2Un+1MM3RMqRL4ZMh1oza5kThdF/ZfR4+gvgu
         VQiDU8CcczdjeAdjtIojqvIS9WkstT71res/YjgFiWUG4zgzRdgUgdul/LPkbXxHdWtp
         Xpkg==
X-Gm-Message-State: AOAM531DBqPaJFwjZFqWwFtkaPVy6jhoAP2IJGdbCXSlhAOynU9/4BKI
        VK/2ahjfE6YA/9BD2Sxe22o=
X-Google-Smtp-Source: ABdhPJwXQfWzvcNpnUHBb/JY3BGTZ9t8NX0dFTKbALhwLEMM99ABNuH81YIC+FA2HlU4RNroxm/cDA==
X-Received: by 2002:a05:620a:553:: with SMTP id o19mr15572703qko.491.1616800679275;
        Fri, 26 Mar 2021 16:17:59 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:58 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 11/19] ncsi: internal.h: Fix a spello
Date:   Sat, 27 Mar 2021 04:43:04 +0530
Message-Id: <7c3a64c0b14a2babc362a26bd6892802031ae5d7.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/Firware/Firmware/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/ncsi/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index e37102546be6..49031f804276 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -100,7 +100,7 @@ enum {
 struct ncsi_channel_version {
 	u32 version;		/* Supported BCD encoded NCSI version */
 	u32 alpha2;		/* Supported BCD encoded NCSI version */
-	u8  fw_name[12];	/* Firware name string                */
+	u8  fw_name[12];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
 	u32 mf_id;		/* Manufacture ID                     */
--
2.26.2

