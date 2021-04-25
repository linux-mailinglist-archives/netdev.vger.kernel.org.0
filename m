Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2D36A6CA
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 12:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhDYKvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 06:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhDYKvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 06:51:38 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE44C061574;
        Sun, 25 Apr 2021 03:50:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g1-20020a17090adac1b0290150d07f9402so3521243pjx.5;
        Sun, 25 Apr 2021 03:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RURj9XuYGzMSpSGq6ZIOr5+JIyOF+Ge9AaA7rhnAEGM=;
        b=dAUHhmljewOAjM8L+nhYGIOQy+wuRcc9sgKpHvmmNgFTic9/EOTZlgDyZcbJ+IB9+0
         ZmTpMVWNGmP8+IIxT78nBz+6pXRJql/dOLjpvk2ceaySAMhHYqSOF1CtLOvInb+7hEbv
         jPVj4OeSzOO/H+HDiKJowLt5yEmVpQtaYAixN5AidexBf1JPvyfTGi24Yicqo0iAiXhj
         RQ7R1llV/KZc/nuXU9D57VbVtVgbgT06bLT7Tk9ZjCyjXerrpvYgNbyi0vIBInp23kzc
         ndeRTmqv1feBBdwYjb4xiKzFLnvkkYhKkeypkmTAmvI5I146s47gZLvn5AnsIeMxrzXk
         HuBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RURj9XuYGzMSpSGq6ZIOr5+JIyOF+Ge9AaA7rhnAEGM=;
        b=rIyqbbHWbyMp8NzBGm8XrjNgjSrDNufrrh2ChDkXB6Q4VQ5NI/PA96hnAKa8Fm00FD
         3+Rn8SEkB1iw6Zfuc1avMn4Q85o5wKa+W31e+Nz+VTr7PctsRS5DJiHAk5HHmYtQY/p3
         1x0v+3KSaXTuA/DAvJd8VWAQPAUr1ZzuavSS2rBc/sI/BWaTZ1aZUx1wM3pObB/Uml/p
         CSU4M+adlfb180RKEPqFsgq9TMWpvaCef5S03lKtiAcVB9NQ5aYh7tNHrmHMusNMq1/A
         V/h8X9tN9DScNDDiV5wn7ieyeuE0GSSEhkOwms3bRnkrs3uMvINuSf5ae2gHBLKfreP6
         2r+g==
X-Gm-Message-State: AOAM531H+o9Tbii4P4ragxUriEGi6FkA873ckVn5d4OroTu9H+3Tp18A
        At40dYny9U2o9amTg3L3CJE=
X-Google-Smtp-Source: ABdhPJzbzKUG8Qg4A7QzgaIYOxKGJjLuLrcg7g/RDZHhvj1HHxiJmqhGw5XAOIuxCAfFxodReJij0w==
X-Received: by 2002:a17:90b:1948:: with SMTP id nk8mr14649666pjb.154.1619347858250;
        Sun, 25 Apr 2021 03:50:58 -0700 (PDT)
Received: from localhost.localdomain ([49.37.83.82])
        by smtp.gmail.com with ESMTPSA id g185sm8502663pfb.120.2021.04.25.03.50.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Apr 2021 03:50:57 -0700 (PDT)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] ipw2x00: Minor documentation update
Date:   Sun, 25 Apr 2021 16:20:42 +0530
Message-Id: <1619347842-6638-1-git-send-email-jrdr.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel test robot throws below warning ->

drivers/net/wireless/intel/ipw2x00/ipw2100.c:5359: warning: This comment
starts with '/**', but isn't a kernel-doc comment. Refer
Documentation/doc-guide/kernel-doc.rst

Minor update in documentation.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 23fbddd..47eb89b 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5356,7 +5356,7 @@ struct ipw2100_wep_key {
 #define WEP_STR_128(x) x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8],x[9],x[10]
 
 /**
- * Set a the wep key
+ * ipw2100_set_key() - Set a the wep key
  *
  * @priv: struct to work on
  * @idx: index of the key we want to set
-- 
1.9.1

