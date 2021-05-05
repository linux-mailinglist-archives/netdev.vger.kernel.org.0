Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344E4373427
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhEEEQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhEEEQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 00:16:29 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65938C061574;
        Tue,  4 May 2021 21:15:32 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id r18so439527vso.12;
        Tue, 04 May 2021 21:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwFMGO9HkR2TbGCzhvL5JqySxlTQeVpbc4kaTKGs3BE=;
        b=So4uNSovbAF6AIxmxcgpac+3XujPMso0OpejYWnatVakC+VivuKTDYJq0JprrWEHeO
         5koxPBUPGvj04vYyKqS3LvP1R/ZT8e0elRemrGF+TCDmI+1HSobRhK3T57X2/+CCz3Jb
         utFgiKh52kcQwh2CrqFuBs7uhHnV82iL0NFb3NVwPgndlWKOUy9XG22VuNt3tJGRDt6v
         aKij0fCQ5786h2ms4htCaoJPGLSkwNUyTViy0CoPc8gjx5jXP1qQtsj56Wo3foj6DlgY
         6DfKxITLKO8e2FQp/YxSYCnjTJcTGJjOMLG1hZNJv0ROwhEixRjv1GuApkYc1toe73I+
         4+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwFMGO9HkR2TbGCzhvL5JqySxlTQeVpbc4kaTKGs3BE=;
        b=EHOtlxrDyaG4eCqINpWuWz62Xns7A/gcu2bEIftlTCaP+lz1T2nam92+5k8mu1vqPK
         wqv3No7RtX4SyhUqaxiUFTstDUqEKd55cY7u6A2FHft/OumR/j7uasqoNV4DokjC/0Sc
         1d4bUY+/BXIFgcio3WCk7+F+HNA3uXYj8VCxtKtLvbC6SlBEKvs/MWW/WG6KGfxb3u/j
         KsGl7gUxXO1mX2vBa6kxMZCPQsgvKFao3rA3akTnKN4gIPj+VusY9h18ZPWTznU52PY6
         /1Q+lHzgXNfCH8eAQTh2XUaimJYe8SgHx13k1ViVd5Lia8nrtrjIt3+9O+by9AhEsRMC
         NPPw==
X-Gm-Message-State: AOAM533jVW296pXajxHWxe1sTerlEP1SrAj5dqGNQct/fDI+Zd0BIkOm
        wwyrdI6AWp5vcMyRwd9RLFc=
X-Google-Smtp-Source: ABdhPJznfIdsSQkkIyOEynUhQcAchBMBTfxBweZKp5EmG8G0bNl5ZSXY59PMVszgcZKHog8oZt56/g==
X-Received: by 2002:a67:e915:: with SMTP id c21mr520283vso.32.1620188131439;
        Tue, 04 May 2021 21:15:31 -0700 (PDT)
Received: from localhost.localdomain ([65.48.163.91])
        by smtp.gmail.com with ESMTPSA id y124sm2601112vkc.45.2021.05.04.21.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 21:15:31 -0700 (PDT)
From:   Sean Gloumeau <sajgloumeau@gmail.com>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     kbingham@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>,
        Sean Gloumeau <sajgloumeau@gmail.com>
Subject: [PATCH 0/3] Fix spelling errors of words with stem "eliminat"
Date:   Wed,  5 May 2021 00:15:19 -0400
Message-Id: <cover.1620185393.git.sajgloumeau@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I happened upon a spelling error in v5.5 of the kernel for "eleminating"
in miscdevice.h. After grepping in linux-next I realized that this
error was fixed in miscdevice.h, but found related errors for words
sharing the stem "eliminat". These patches aim to amend these spelling
mistakes, and add entries to scripts/spelling.txt to avoid adding
similar spelling mistakes to the remote in the future.

Sean Gloumeau (3):
  Fix spelling error from "eleminate" to "eliminate"
  Fix spelling error from "elemination" to "elimination"
  Add entries for words with stem "eleminat"

 drivers/net/ethernet/brocade/bna/bnad.c | 2 +-
 fs/jffs2/debug.c                        | 2 +-
 scripts/spelling.txt                    | 3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)


base-commit: 9a9aa07ae18be3b77ba132a6eff3a92c9b83e016
-- 
2.31.1

