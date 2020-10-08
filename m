Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413AD2873F0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgJHMT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729739AbgJHMT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:19:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82631C061755;
        Thu,  8 Oct 2020 05:19:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e10so3864789pfj.1;
        Thu, 08 Oct 2020 05:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QK7x4WnMDD1w1AJigxZca0jvkUm/6wXO+3vn95iqnN0=;
        b=ah5DZbSny0r8zD0poMrz7u2KbugGuHbiELrKWzDy7luR9o49V1lzS7Ippkm2TDz7GD
         JvRELWTqlBeqQ02BgSm5dNckoFTqY5QrcbDMkPBr0E/wNgbO63Piu/9A8Xh3X3y3Y2Nz
         pfqiPSjXxMDUnv+9AUcHbuGLRHR5sBA+RG6Cg66KNbJiVJQPAslnxhPI3mMDJSK54056
         CUV/qNslf+7yEl1+Wjtxgv6lEcyeTJ9oi4nnw0kNEuBaxoXMMK+KP+6G5Yp3bYEcjK0F
         d69386wwX9db+jCIr6pSByetkcpL0YWa45+phiPvoeJ10I0e+ItSydAsBX0WPHO7iRXQ
         FTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QK7x4WnMDD1w1AJigxZca0jvkUm/6wXO+3vn95iqnN0=;
        b=PGzMCyVSO9ErrXbC+9/+QekqDVHMc+R0J4+P8VDnZA0vVZCSbQCV1d3bDy1DeeKryu
         Bb/RpQMpU75cqtFu95M78sVNhi9c3zo7SiKenhwuJAb7gA+WmqyhiuBanarWgPS9pVnM
         /R/bri5V2ibXqZphYthGE2OpLpbpBX8cbwLq6NhFFBF16N1Kol/wKhwQ/L/BHs3lxYDh
         sDqH2PybjaoXjK2KylclodD+A9pUjh3tABWAhLpMxiFK1vhMZc+QsTJ0nixu4wGE4Rba
         F5PRK9V3HoAEZM6V7ksGJ4jDKC6oGE9amT1MjnVIJO3eL1SVayuaWcieFnT/pBypFQ6k
         7cHA==
X-Gm-Message-State: AOAM530ZcsG850wltHSUu6mLHG4YkrCZLkPsxCSwTng9Y54CiLCynNQW
        Q5vxqdgo4cLHdAs+UcMbFPqxKWbHH6Ag
X-Google-Smtp-Source: ABdhPJy+OvvEdPcMzlBntde+cxsU2+kLyABp3rjbzeAEnj8gMImZKC8vY6ovtHlmqMTewoBcOEnXuA==
X-Received: by 2002:a17:90a:bc2:: with SMTP id x2mr3876963pjd.54.1602159594117;
        Thu, 08 Oct 2020 05:19:54 -0700 (PDT)
Received: from localhost.localdomain ([47.242.140.181])
        by smtp.gmail.com with ESMTPSA id c7sm7233914pfj.84.2020.10.08.05.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 05:19:53 -0700 (PDT)
From:   Pujin Shi <shipujin.t@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hankinsea@gmail.com,
        Pujin Shi <shipujin.t@gmail.com>
Subject: [PATCH 2/2] net: smc: fix missing brace warning for old compilers
Date:   Thu,  8 Oct 2020 20:19:29 +0800
Message-Id: <20201008121929.1270-2-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201008121929.1270-1-shipujin.t@gmail.com>
References: <20201008121929.1270-1-shipujin.t@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For older versions of gcc, the array = {0}; will cause warnings:

net/smc/smc_llc.c: In function 'smc_llc_add_link_local':
net/smc/smc_llc.c:1212:9: warning: missing braces around initializer [-Wmissing-braces]
  struct smc_llc_msg_add_link add_llc = {0};
         ^
net/smc/smc_llc.c:1212:9: warning: (near initialization for 'add_llc.hd') [-Wmissing-braces]
net/smc/smc_llc.c: In function 'smc_llc_srv_delete_link_local':
net/smc/smc_llc.c:1245:9: warning: missing braces around initializer [-Wmissing-braces]
  struct smc_llc_msg_del_link del_llc = {0};
         ^
net/smc/smc_llc.c:1245:9: warning: (near initialization for 'del_llc.hd') [-Wmissing-braces]

2 warnings generated

Fixes: 4dadd151b265 ("net/smc: enqueue local LLC messages")
Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 net/smc/smc_llc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index d09d9d2d0bfd..85df0ef60500 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1209,7 +1209,7 @@ static void smc_llc_process_srv_add_link(struct smc_link_group *lgr)
 /* enqueue a local add_link req to trigger a new add_link flow */
 void smc_llc_add_link_local(struct smc_link *link)
 {
-	struct smc_llc_msg_add_link add_llc = {0};
+	struct smc_llc_msg_add_link add_llc = {};
 
 	add_llc.hd.length = sizeof(add_llc);
 	add_llc.hd.common.type = SMC_LLC_ADD_LINK;
@@ -1242,7 +1242,7 @@ static void smc_llc_add_link_work(struct work_struct *work)
  */
 void smc_llc_srv_delete_link_local(struct smc_link *link, u8 del_link_id)
 {
-	struct smc_llc_msg_del_link del_llc = {0};
+	struct smc_llc_msg_del_link del_llc = {};
 
 	del_llc.hd.length = sizeof(del_llc);
 	del_llc.hd.common.type = SMC_LLC_DELETE_LINK;
-- 
2.18.1

