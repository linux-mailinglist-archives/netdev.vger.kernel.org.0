Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6646F33A7EA
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhCNUTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbhCNUTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:19:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2045FC061574;
        Sun, 14 Mar 2021 13:19:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso13617239pjb.3;
        Sun, 14 Mar 2021 13:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Y7oqwR1FBDTTUKS5d9zNCNDgoQjHTeHQRiBncE/k+0=;
        b=BuioQxTQWUbUBbe5QaDUzV9/piX+djNfC+hJ/eTRB3hSEI1zTskpOqHVzaWwLH2vCT
         KtGyBFGIBbIme3uYU2eqgMobX81TNwODQ8k2cW7I27+Vd/yi6izqiz7vALGiNuoC8Wcl
         5rVZBgsojS4XKW4jQZt3Sg0FQDZoVQ/2eUmUT/EQDUYTMhgeAp36cqwCiwMM19b8AXHF
         r9wiqZ6f/K+nPbfUePhJN5Q7eoVfLIhZOFUk3ZpWZf/IDO3dQFWYdMhAjCCcKz6BGEEq
         zSyTbz79fYzfGss/LPmsGE11IguZkHfreS+ZE5OpmmdZecHRzfMc/qHjuvV/tzqnbU66
         Pn9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Y7oqwR1FBDTTUKS5d9zNCNDgoQjHTeHQRiBncE/k+0=;
        b=ZItA1NFSpbq95kIra+20A3kHjsrkRfltUHAJTqestNbFYKZv7zJuFegmz0inyAvF2K
         WwYTyNmdZTii780c8F2PRdpdF5BFilUemvveNnpC/5Z/qUBTPcvgKKbi8eCPTaqbcyW3
         fuc8FDp4dFjUltJ3L17GtjIVC2kDGQ1eb+/sjZGupBkiCc7ugp5hCqgHRimYYKJQ0/4l
         K/YJAraNEn01rsSlpeUfv9pFafOJIZ/AVTiw9vAMAjigfATZqyqOEZj62YhLSkC4t8v6
         mmjenZpfC845TijnVqaPESFOhAHMWxvCwX7BMHwrLNHhn4xIvd/GgjC8kOsbJBnvvJ9q
         g22g==
X-Gm-Message-State: AOAM533ARJfhexneehGFPUnypT6RkW4So7pzZN+pXZbJqbi2ddBumez/
        zmiqOnIVbhD+1JHO/vdNM3I=
X-Google-Smtp-Source: ABdhPJxtFQhsJfyCUUEPR+2+38zQEQpHhCxeocNpXHKiv9P/2FGAK901jWyRTqn479SCQdx/kJxgTg==
X-Received: by 2002:a17:902:f242:b029:e4:6dfc:8c1f with SMTP id j2-20020a170902f242b02900e46dfc8c1fmr8107522plc.0.1615753146588;
        Sun, 14 Mar 2021 13:19:06 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:19:06 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] rsi: rsi_debugfs: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:16 +0530
Message-Id: <20210314201818.27380-9-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_debugfs.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2014 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_debugfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_debugfs.h b/drivers/net/wireless/rsi/rsi_debugfs.h
index 580ad3b3f710..a6a28640ad40 100644
--- a/drivers/net/wireless/rsi/rsi_debugfs.h
+++ b/drivers/net/wireless/rsi/rsi_debugfs.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

