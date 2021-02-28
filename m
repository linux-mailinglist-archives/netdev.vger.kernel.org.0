Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D241327381
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 18:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhB1RGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 12:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhB1RF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 12:05:58 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9862FC06174A;
        Sun, 28 Feb 2021 09:05:17 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a22so23774983ejv.9;
        Sun, 28 Feb 2021 09:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jk467Hk8sccWYhVzgEMkA6whGpvO2G5yv/mUzelQNJ8=;
        b=dJxzGlwQaY3FG9cJLl91luleu4NE9REZpE49mfL2CSPoHrnWKsyWfkjIk6P7nQGz6J
         a6jeIGuSKU1nKRM90aXIH7pyT5LscX2miGVARwYDVTSBe1w5aHHO0R/USdgyhOF2S++l
         wF+jZjtBXhYvz0Wk1FBlDbvmbLlyYAWxevTfkiUNB5XHk/lzeJDUQh+twRjLYndOjUj3
         LnJbzh3KkvEOs6V4QdfXuaWjpeN/R3oW36Rg4wvCN9SgfJzOdhcVM6qInLgge7ZxNYo/
         6+mR5px7rvGybwSKXXW9jBZgxVpeljEHnZHX07Rj4on8G5/wP3/hEU+Lg903GeGtM+5u
         84hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jk467Hk8sccWYhVzgEMkA6whGpvO2G5yv/mUzelQNJ8=;
        b=I/TPxw7P822JO6HUYm6p26Ldc5/HliZppmfD3ND9XugdAZD+XrrxhzZpCG3YyCi2H/
         rBQWuWkWzCMbSpVcP3ZjI3MT9FVEEQxHKTIE3nU5x8b3KxMinTmIJFsWi4WPv/BbJLuJ
         P4H8xndE4uiu3RlGb6Vnt88takGDDYr774VC/5bd/KHIEYMOU8M85zDbtLmLaN+sMCCc
         uNj0bE8UUqB5pdP9UcJSMFSMRKMgmXQse2dSny2J857VEGzLx9YT1bawsaBXpmaCd/eZ
         nF8u6BwRcB2FnlBY16CCDCIYHN0g5sFq7brmV32uae4X8XGR4iffzqRsVdMhhwSYcYV4
         i8sA==
X-Gm-Message-State: AOAM533/7ebPfmJoJnZ8/UZ5p+ZzVBBE5OLiZH7W1G/ypn8EmwnCPUyf
        U9nXtMXjD2IMUGd2ALtpFQ==
X-Google-Smtp-Source: ABdhPJzVU2DokbFcUMZhcVBGnhUqfgbvKAMh1A0mklUt1I33IF96Oy7q8pgTBLMZKEdvjYEPMQbh4w==
X-Received: by 2002:a17:906:38d2:: with SMTP id r18mr5041707ejd.104.1614531916356;
        Sun, 28 Feb 2021 09:05:16 -0800 (PST)
Received: from localhost.localdomain ([46.53.249.223])
        by smtp.gmail.com with ESMTPSA id 35sm11991890edp.85.2021.02.28.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 09:05:16 -0800 (PST)
Date:   Sun, 28 Feb 2021 20:05:14 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        vgupta@synopsys.com, linux-snps-arc@lists.infradead.org,
        jiri@nvidia.com, idosch@nvidia.com, netdev@vger.kernel.org,
        Jason@zx2c4.com, mchehab@kernel.org
Subject: [PATCH 10/11] pragma once: delete few backslashes
Message-ID: <YDvNSg9OPv7JqfRS@localhost.localdomain>
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 251ca5673886b5bb0a42004944290b9d2b267a4a Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 19 Feb 2021 13:37:24 +0300
Subject: [PATCH 10/11] pragma once: delete few backslashes

Some macros contain one backslash too many and end up being the last
macro in a header file. When #pragma once conversion script truncates
the last #endif and whitespace before it, such backslash triggers
a warning about "OMG file ends up in a backslash-newline".

Needless to say I don't want to handle another case in my script,
so delete useless backslashes instead.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/arc/include/asm/cacheflush.h          | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/item.h | 2 +-
 include/linux/once.h                       | 2 +-
 include/media/drv-intf/exynos-fimc.h       | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arc/include/asm/cacheflush.h b/arch/arc/include/asm/cacheflush.h
index e201b4b1655a..46704c341b17 100644
--- a/arch/arc/include/asm/cacheflush.h
+++ b/arch/arc/include/asm/cacheflush.h
@@ -112,6 +112,6 @@ do {									\
 } while (0)
 
 #define copy_from_user_page(vma, page, vaddr, dst, src, len)		\
-	memcpy(dst, src, len);						\
+	memcpy(dst, src, len)
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/item.h b/drivers/net/ethernet/mellanox/mlxsw/item.h
index e92cadc98128..cc0133401dd1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/item.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/item.h
@@ -504,6 +504,6 @@ mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u16 index, u8 val)		\
 	return __mlxsw_item_bit_array_set(buf,					\
 					  &__ITEM_NAME(_type, _cname, _iname),	\
 					  index, val);				\
-}										\
+}
 
 #endif
diff --git a/include/linux/once.h b/include/linux/once.h
index 9225ee6d96c7..0af450ff94a5 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -55,6 +55,6 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
 #define get_random_once_wait(buf, nbytes)                                    \
-	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))                      \
+	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))
 
 #endif /* _LINUX_ONCE_H */
diff --git a/include/media/drv-intf/exynos-fimc.h b/include/media/drv-intf/exynos-fimc.h
index 6b9ef631d6bb..6c5fbdacf4b5 100644
--- a/include/media/drv-intf/exynos-fimc.h
+++ b/include/media/drv-intf/exynos-fimc.h
@@ -152,6 +152,6 @@ static inline struct exynos_video_entity *vdev_to_exynos_video_entity(
 #define fimc_pipeline_call(ent, op, args...)				  \
 	((!(ent) || !(ent)->pipe) ? -ENOENT : \
 	(((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
-	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))	  \
+	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))
 
 #endif /* S5P_FIMC_H_ */
-- 
2.29.2

