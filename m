Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193A4481EC3
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbhL3Ruv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241512AbhL3Rus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:50:48 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3136FC06173E;
        Thu, 30 Dec 2021 09:50:48 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id t187so8403269pfb.11;
        Thu, 30 Dec 2021 09:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1m6Du5I3sa+4N+2VoevH+uREnRI1E6Wc5yP36akl1eY=;
        b=pEisFIYwefZLbMyOQ/5Nx7FSZTKrg4rIkMrI0cCA2Lr6PEbPWuXnO+xXbEukCLm506
         UmU6w9TGGQUqkoBpRNi/9/lyfaaGizs+XsBEf2zTCwqqax5/k9wGGDwEf+AsLDoABrFl
         wdFCa1wkc5xAXR+gc1fUBbx6aIHexBPo/dMwmVYM3+ZcZFYAOEYdp5b4odFx6V1BJcVi
         0u8+yfzuaVk/7U4kwSfTOEH67RF7wPLBAL1CRW7mkRgQfR4Ktzs7vMUyg7vkvBTpgrxd
         qOuKX3Zorj3Qrw1UlDTKwxeooguq6jYASx5EC6jluiYXYhtkRIFDGajU3rHWefWtw4KV
         Hd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1m6Du5I3sa+4N+2VoevH+uREnRI1E6Wc5yP36akl1eY=;
        b=ko51e/VnJFwy5Clk5HNxjP7npwoKxfLspStsreEqa2mvMqBjWyvKqgButkRPNDCsYL
         s5+OkQZTe6Nt5ldtW69vCHDFUEPpLb+WadaJ5t2+4grW4NvWyLINNofy5bHjsCmc2StX
         QW0I5bZ5kgETkvPNGOmRuUqIwxNxJ1EcSQ1LCTWnryQsVenV/5BJjTphfzRafnC3lxAx
         bWdeCwAfUSeP15W27kHBKCFjqrS+vS1uoKG+6DCHqYRdHIjgvWmzo7uzt5tLv0peVrOQ
         i9oXKjG6ogQaKyZENyxJdM6d8djJRCOXQJ2Spucsfx4djhRowoQjCew2QL3D91i9KdiK
         Yq9Q==
X-Gm-Message-State: AOAM531vCeMqqFgdF1fgbTgU+6Z1GbsNgZ8P4CqaXJ+LYtSMPecVtB9T
        PIay+PmIeEQaE8ibpgdhkaeSsvzchsv9lA==
X-Google-Smtp-Source: ABdhPJwkvyxU931dzrg7RRwBTSQVlzAlI2cjM3RJsqdv2NiibgxE1aricgJuLd6a1esGf18TVGOdXA==
X-Received: by 2002:a05:6a00:2391:b0:4a2:cb64:2e01 with SMTP id f17-20020a056a00239100b004a2cb642e01mr32644900pfc.45.1640886647795;
        Thu, 30 Dec 2021 09:50:47 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id s34sm29980811pfg.198.2021.12.30.09.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:50:47 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH liburing v1 1/5] .gitignore: Add `/test/xattr` and `/test/getdents`
Date:   Fri, 31 Dec 2021 00:50:15 +0700
Message-Id: <20211230174548.178641-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230174548.178641-1-ammar.faizi@intel.com>
References: <20211230174548.178641-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Stefan added these two tests, he forgot to add them to
the .gitignore. Add them.

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index 0a72f03..4e70f20 100644
--- a/.gitignore
+++ b/.gitignore
@@ -60,6 +60,7 @@
 /test/files-exit-hang-timeout
 /test/fixed-link
 /test/fsync
+/test/getdents
 /test/hardlink
 /test/io-cancel
 /test/io_uring_enter
@@ -133,6 +134,7 @@
 /test/submit-link-fail
 /test/exec-target
 /test/skip-cqe
+/test/xattr
 /test/*.dmesg
 /test/output/
 
-- 
2.32.0

