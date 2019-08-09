Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569FE87B14
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406928AbfHINY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:24:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51035 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406273AbfHINY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:24:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so5724247wml.0;
        Fri, 09 Aug 2019 06:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ILDppnCmjlOfgJgJ2qNB5ceciycNxLir06qMezCpixc=;
        b=eZT+w59UUZFyL2cCRDMRHbuHDIC4RKWJEJrzCdA8oNEb6thqLiNew7cw7jfP0Phi7J
         f+FMHqlAI16KHYSE0ibaSbNqX+dizyMIqiEEEwVV3QIwtMbLv02nJ5CQvVYuUxBXR/VF
         0l8m7qMLUqGDNtWlKpHhxIRJJCdztftGKS301K7JgJ9CsKj+RKbbSLvjJbF6EvypPIlT
         HsPE+Gv/ODbYaM22lNsT33zTECWqnV3KUF3jwZLDkWtami3ij+fUi6/LQnR9Ht9Jh4VY
         781LpF4t7NA2AHAViDrw8v0kl+ezWbfaOn0hkp/rN6EGmJL4j/dHpKgmfceU6/hl+c7n
         e7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ILDppnCmjlOfgJgJ2qNB5ceciycNxLir06qMezCpixc=;
        b=VfuIjVaWUUoGcB6GumWyfYT+9DnU3kXhEg+mwjeczyTWQaoFTBAalQfVWGT2E382YK
         uh6NjRKRn2ZSRCzK4/dxKFRIA/3ey9qql0Twc13vfjky46JfT/B5jEPS9vgcZmkTj1jd
         RWsmciCYwAAv92Zl4ZDm30s0UgbASMEHvQvqrgpaVfhLqYZwS9j3P4F7X9I6DegnrBG8
         Ey5LDH6JU8j4ehpwQLLyfztHv3CN/pSEUXtvnKL9XralshrvueBQpW49a5rxNHyHsqm6
         gWz/SliBDJoJOIqQoR0AQCVoNOL6DYgPaSo6lE5VQgl9G70IloCjXY/PzkJCmmSnKnAf
         qpDQ==
X-Gm-Message-State: APjAAAVRlxFVAu6rkun1MxN8GiwYuPZM5it0L+WlYaodaGtYUwhyQVx8
        YBQICWGSabTYoukjcWS7fEI=
X-Google-Smtp-Source: APXvYqyoIq7cQyCyqyaTH2fo4y1zxmmZ+SxcwfcCyTtt3q94bYPWzefG8vVhK4GVKNwWCIJEWnX5Vw==
X-Received: by 2002:a1c:ab06:: with SMTP id u6mr10757190wme.125.1565357095875;
        Fri, 09 Aug 2019 06:24:55 -0700 (PDT)
Received: from localhost ([197.211.57.145])
        by smtp.gmail.com with ESMTPSA id a2sm4863912wmj.9.2019.08.09.06.24.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:24:55 -0700 (PDT)
Date:   Fri, 9 Aug 2019 14:23:49 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: [PATCH v2] Documentation: virt: Fix broken reference to virt tree's
 index
Message-ID: <20190809132349.GA15460@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix broken reference to virt/index.rst.

Fixes: 2f5947dfcaec ("Documentation: move Documentation/virtual to
Documentation/virt")

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---

Changes in v2:
	- Fix patch description. 

 Documentation/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 2df5a3da563c..5205430305d5 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -115,7 +115,7 @@ needed).
    target/index
    timers/index
    watchdog/index
-   virtual/index
+   virt/index
    input/index
    hwmon/index
    gpu/index
-- 
2.17.1

