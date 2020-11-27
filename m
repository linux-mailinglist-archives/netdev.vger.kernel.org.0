Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31B32C6B5D
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 19:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbgK0SIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 13:08:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732851AbgK0SIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 13:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606500524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=/DgUT5SNxJZkOmupt2XLqi4YOdrVCYEQCxi35Ihq2HE=;
        b=CuUGinUeCOFPAhGEzVWELMLy7w9WiVClpndu+ydm8O+paS8uXdqQzLqTjPUXGQxF/F8uAz
        VYOjzroM4UJg0n29Dg0Tod7fz2AcKURIWPXIHcm+enTUQRRfNWlW0fTBbBjZ2PuBOnVBM4
        NS+5xTQnAFJ+7fpiq6pCqiYKjlvhCFw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-g4H2J-D4Mu2v4pB14nOVZQ-1; Fri, 27 Nov 2020 13:08:42 -0500
X-MC-Unique: g4H2J-D4Mu2v4pB14nOVZQ-1
Received: by mail-qk1-f198.google.com with SMTP id c71so4121857qkg.21
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:08:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/DgUT5SNxJZkOmupt2XLqi4YOdrVCYEQCxi35Ihq2HE=;
        b=LZF2PK9cuR6iEeDgeZISZ3YYG7b581Ssy3J5MEO48PYmtkh8g/qya9y8jxcipEFZqO
         12hu6ufivaHkMjNhrpggZlffwHko8oIjrlQNndTvVAraMv5lMym2yCuALjfHjZKG+2qY
         HsujBFB9t7nFS23IHtp2QYz1s2806zdQKAkETsmN6vUivl2ree/aAN3gk8dFJJcLRkEE
         tBG9j8xwRNmQgxucFay2CVhSBoYJ4amMt5WOGB70sZz7f+kNejm/Vf/tGHt8iEYafVwG
         5wtoKD/I7V1lSFKTKlTZgojBBhxRt9HlmigCOwevKs/N1aXryGAM7HFuCpASVG2FniMY
         oYLQ==
X-Gm-Message-State: AOAM533lik97vE2QCZ/rPwpTebx5wV5Rctb7y6VO2OBj51vh2jS7T9Mo
        ffEPx1S28q/ayo/TJSk8eG4EjWNLFVzAiM53LfMGwumwQeN+nh60FgPH+kMayqvMHd8ao7TJkCK
        yPAOVMFjTVrks+XVf
X-Received: by 2002:a05:620a:790:: with SMTP id 16mr9817591qka.169.1606500521548;
        Fri, 27 Nov 2020 10:08:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTJQc/pmRL8xFzMk/FHDQG/ksd1sqzwIdRRI35jLBYQnKKpX3IG3hKq5RW1K8Qd/3Nnae4aw==
X-Received: by 2002:a05:620a:790:: with SMTP id 16mr9817579qka.169.1606500521380;
        Fri, 27 Nov 2020 10:08:41 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id c128sm6276198qkg.66.2020.11.27.10.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:08:40 -0800 (PST)
From:   trix@redhat.com
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: wl1251: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 10:08:35 -0800
Message-Id: <20201127180835.2769297-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/ti/wl1251/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
index d48746e640cc..a1b778a0fda0 100644
--- a/drivers/net/wireless/ti/wl1251/debugfs.c
+++ b/drivers/net/wireless/ti/wl1251/debugfs.c
@@ -39,7 +39,7 @@ static const struct file_operations name## _ops = {			\
 
 #define DEBUGFS_ADD(name, parent)					\
 	wl->debugfs.name = debugfs_create_file(#name, 0400, parent,	\
-					       wl, &name## _ops);	\
+					       wl, &name## _ops)	\
 
 #define DEBUGFS_DEL(name)						\
 	do {								\
-- 
2.18.4

