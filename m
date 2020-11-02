Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E4A2A29C1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgKBLqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgKBLpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:52 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01DDC061A49
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:43 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id y12so14218222wrp.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KYODUgFzLZpQRtZvtEYb1GiOIVfxB6JPRgWqq+iAt+c=;
        b=AJX5cVYbYfywEDxmxD3pZjiVRslIcybEJZ8g2dbXdeUJiSS0Ky0LFXCUV0CYcXYHsb
         dCNANCtu/DivMaX/I6jArtkFyH9j+m54tuCqgcyCwmupDoxAxIPzjB8XDdFizzc9/fAT
         55jJvjAPyVpvsJpvWPMYuEUOP7ktgv4AtUKUI9w35CVqp0zumnqtQzEZ62n/bR+dBH+K
         W7W+fleGsND2HzYP/6g7Ba/xIHWAN1/mwtTkEQO4TY+V9hDs6RLgjDEBHsDGBDmLOw2v
         9l4if4pfCZ8hH1xao+IPz+C4z6Wk+XX7ktqR4nD73+J7ehbZr0YBi+8z4eFLvvOrqjGH
         A6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KYODUgFzLZpQRtZvtEYb1GiOIVfxB6JPRgWqq+iAt+c=;
        b=BmUWEaBpKg1DECcJTqtfTqf0XZcCGanwp64qzizctIzs0FD+rZq88WuW2Iyl4fRZ56
         +E2YAqu9FByF5u25DrX7r/CVBxXaK9Q0aSLSAG598xv4MGljL7tHUhddSjUMjxek+MdV
         nWIsalo5x7J73trBVv4L3bjN81iOUsz3cY+GtC/uLuXAsxMRRYOzcLpIQIFnX43Ks2dN
         E7b9KBnYo73Dyu9Q2xnEWnMij8Wf47m0bxuWkwS16KCls3fRDyxAczqvrPj+3huNb3wa
         OCYrh8KzYFZkp5uOizNL/d3JVC8bFk6KHdxqqdokygQgOyj0ic7SGJEoHJ8b+s1F98jT
         RAKw==
X-Gm-Message-State: AOAM533HEo9GBc3VEMRAwB7c5FHDGcYXhNT/DAO5i2UwSRd3gfTbk2cm
        80HJDEd7iGA/bEeHavTk6qk6gw==
X-Google-Smtp-Source: ABdhPJxwVVKc7cWervgf1tBjuBEil9YpITINaEFrabEoaKUHr5C+ef2qo5WF6jlrUYpN00LtTFFauA==
X-Received: by 2002:adf:9069:: with SMTP id h96mr20674315wrh.358.1604317542636;
        Mon, 02 Nov 2020 03:45:42 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:42 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        netdev@vger.kernel.org
Subject: [PATCH 19/30] net: fddi: skfp: ess: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:45:01 +0000
Message-Id: <20201102114512.1062724-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/ess.c:43:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/ess.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/ess.c b/drivers/net/fddi/skfp/ess.c
index afd5ca39f43b6..35110c0c00a04 100644
--- a/drivers/net/fddi/skfp/ess.c
+++ b/drivers/net/fddi/skfp/ess.c
@@ -40,7 +40,6 @@
 #ifdef ESS
 
 #ifndef lint
-static const char ID_sccs[] = "@(#)ess.c	1.10 96/02/23 (C) SK" ;
 #define LINT_USE(x)
 #else
 #define LINT_USE(x)	(x)=(x)
-- 
2.25.1

