Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459BD54DDC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbfFYLmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:42:53 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44126 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbfFYLmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:42:53 -0400
Received: by mail-lf1-f67.google.com with SMTP id r15so12352253lfm.11
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 04:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KC6UqMNqqkqf945o5TbzjnUd7iFuYFfkkwWAw6cVa+A=;
        b=dRpoMSrornZ5+U7nptq/uktaa04UFIo/QAPLaDjRnueu6KFQvvbSC6ea/xIkrZ1H+I
         Je7LPWkHilJBcantQI2hVUlxVqRs1rx96wT1pMz6dMOJHhnnGQlCkxVOepvxEeCOShTL
         Yk4beULHTY/vTur12Zdo9Cktt4Ag8Xlo1DSjye7uzhgOi6xbe0mMRHDoIUsYjhCT9JDP
         B6XZNeVqaYT95yRVDq8vrsv4Oi62dfsZacGbbZRDRztCjG8Ep7/SB33ub9e+WQ0Ep7vt
         6UyJgyu/fZjIQRTiLMN6bJdHGOJtcz9XOJutcYpEA+DsJl38eDuJcLtKImIBfeVyUsIX
         89pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KC6UqMNqqkqf945o5TbzjnUd7iFuYFfkkwWAw6cVa+A=;
        b=hJp5mbl8ZhYFbNEtigsTNgI0gYgdk2W/LZF++d3cnsit2lLuALOCxlk0Cmh0t7LmyD
         wr3bwsEIhBV7HEu9luwHpiFnvSFqOdZmcnUsaEld9Wfh/XaR4il5e8acNyRs9KkvnjYh
         yM0j8QZxUUaUjhwnhjzcLvoGw8cGJrO+WcCL2YnIsJmM8D+i0OATIxPzui3Rspmxyl+Z
         wSohmVGaA7CHKrdLpAxPeBN1nzyfHU4p8hTgOD9YarTWpBaEuCGW8A7XL9M78FZ9oMy4
         g+2lhF4v8JLXZ7YTd68+CmdrD/VimQVD/MzErQ6fO1C3SfzaHj9aP6i1kS53uZxVITHZ
         eOqg==
X-Gm-Message-State: APjAAAXp+ckg07V+JzgHJ+Ub8dnCy7IjP7iUx8fAbqcCTr03P2xVh17/
        pQfeoZK9HoqaKaK2ILbNVmJgbp0AjQk=
X-Google-Smtp-Source: APXvYqxt2HqTpJfaSIXqLD+CeTVC95mRSNEVCNRSHi4rSCLqw8RN7sSne6onoOM39tgDEByte/9mFg==
X-Received: by 2002:a19:3804:: with SMTP id f4mr6841525lfa.69.1561462970776;
        Tue, 25 Jun 2019 04:42:50 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id r2sm1913675lfi.51.2019.06.25.04.42.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 04:42:50 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, hawk@kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [[PATCH net-next]] net: core: xdp: make __mem_id_disconnect to be static
Date:   Tue, 25 Jun 2019 14:42:46 +0300
Message-Id: <20190625114246.14726-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missed static for local __mem_id_disconnect().

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index b29d7b513a18..829377cc83db 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 	kfree(xa);
 }
 
-bool __mem_id_disconnect(int id, bool force)
+static bool __mem_id_disconnect(int id, bool force)
 {
 	struct xdp_mem_allocator *xa;
 	bool safe_to_remove = true;
-- 
2.17.1

