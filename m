Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603F83101E5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhBEA5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbhBEA47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 19:56:59 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C8AC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 16:56:19 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id o16so3361008pgg.5
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 16:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=td8lYf7iJDPIhT02i3PgobJCeNCH7wemudZJq4hsJSQ=;
        b=sMZm39LmejFPYL8leMwzCDWJ1VJD9emiysBnWY/nvuKNb+AgTwWNF4xWuAtihz7FMy
         V8renTw09ViuvL1Vh105bNpXZVOzge6b5ZiQj70UerA7YNEHK181V3P1OqEUV152cxO1
         qPPbjLv3W2TzUQfF5nOVokoKuHXdqgbBeV7Sz6+S69S02vCFfilc6sUixG/I3Pawcgrn
         gQr5Eh+jhZMnBauP6Ggxpxl6KMkqd7n7UdOcILqOP1143o+hD+YWZe5TfMur0cEncJLL
         uVfD6ENY9eRD289W/VD+BUROPrKAgiNTbnYwvkzccEJgoDQXXKdyRqFobzaawne8EH7d
         7bDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=td8lYf7iJDPIhT02i3PgobJCeNCH7wemudZJq4hsJSQ=;
        b=VZi0wMknuf/B1ayQEN3O59PnT2rPPI0SKOvCd0NAl/E3fAxoMUy4rTlHSx/jLKkFJ/
         XAiIkCjNTjNAwK2nda5W9XJF0AiWaNv9dU4JfJpqe+cbh6Grz5amSZ+Tr9QPjlHovreT
         s4JIPMbKEM2LdbVHYzQpHff4MyFhzrFKdzwGR7PsOLGHbHjddv7AtwHUWW+e/EkPI3ZL
         fhlE8/aicooochpogeDeGO/ADybPdJC9i+W6/PY9IrGP3TLDTltGNgIdY1vZBXdctXmE
         pak+CMaW+Q9tLrTOO0Pv1bGpRMe3FvYKsbE+4/NFXgBOFvId/Xi5C1ZAtitrjbe3Wkks
         YdDw==
X-Gm-Message-State: AOAM5309OZUzcFzMnRVSpxaFpbZYqW717TCO6O57fOHWVPHlruAu0nR7
        8lTk9GxwT5zbJkecmp/oZVqbDwlXOms=
X-Google-Smtp-Source: ABdhPJxitpjRN+OJT8DrpTXHer3PFPaaMmIafq15vAeqw2+EZi3a3ClSQbqgPjcJmBMJORUFTCyqVw==
X-Received: by 2002:a63:464a:: with SMTP id v10mr1689802pgk.393.1612486578285;
        Thu, 04 Feb 2021 16:56:18 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 17sm7606717pgy.53.2021.02.04.16.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 16:56:17 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org, mkubecek@suse.cz
Cc:     andrew@lunn.ch, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH ethtool] gitignore: Ignore .dirstamp
Date:   Thu,  4 Feb 2021 16:56:15 -0800
Message-Id: <20210205005615.1058972-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index c4df588c37ea..0b7a71b58b7e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -30,3 +30,4 @@ test-*.trs
 
 .*.swp
 *.patch
+.dirstamp
-- 
2.25.1

