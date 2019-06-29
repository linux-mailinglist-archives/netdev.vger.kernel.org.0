Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D885AD09
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfF2TRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:17:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36123 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfF2TRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:17:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so4582586pfl.3
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 12:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YK4t9qMKuGruoaHvyjw/JEJclDmdzWPdTztiq22JC2U=;
        b=bFnQnozZdaN9e6PvRSRtzJaABnjaYTc3g/01dL9Uu2BpqVzIAjFQqhS6fYDDcjns62
         Lbi8uhT03v9TyzlsOoWu8sElM3apsJoNYECHlheREopx55YqkdHlncI3RFazRwKaIHt5
         bpSsWw+5tzoMilvbdN3/14y8Z898TnMJxks9elzDmgiNbgNbMFSv1+kYWPaVvfj/wnC9
         stXipWKUetC9tX2Sfi0WuRcymfNLKbb6ePv1ZAly8j3QBDmlIRuIKDyrU0NsUyGTtIJW
         T4f8M5KGYr69OvqmBpx378yiTjWi2rAZ3nFM5XuhbaR9xh2zHU88k82nOD0RxZRM4LEA
         tgqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YK4t9qMKuGruoaHvyjw/JEJclDmdzWPdTztiq22JC2U=;
        b=p0RWiy5VVrpd0qg+58mF2pPBH7v5yWk2rZ2nwOBc+VjoXWTLYZg0VJYtTxBzc1zmaj
         D7Rc39MwM81SCiqFreq+vc9Uy34+zNd0KK89ZoDpdLO9X0XOHuaHvEu3zHyhV43UmPeS
         P/JlPSdsSSG1fix/lm4ZszPjJOtJm8ihTCd0avsLwuZnnbU2nIfNHqjpeU0y3mp2WfC2
         cSizy2BOdcxC5ePiCZBfn7n3TgEIzTSffjwCiEMSUC3dOIt0tGRJj2HfnKjaAdxpJtGJ
         0/V1GqfTRMZERE8ogv9HuOxyboDAYPSUL09/1sr0GEO2K7D7sX5nyauVjRuQaS6t15B6
         /TeA==
X-Gm-Message-State: APjAAAU2dss0t/vadCDCy9DeVzcNaDki63/ouUA4zF09stIdecLKzkTg
        XKith4BYZkJ3+8M8UaJjUv/Nr71pAYM=
X-Google-Smtp-Source: APXvYqx3fmDU4rwlFLBxyvfBlR7qdRP1zdoLLwqZGeqWwyjxD7fc2GwX2G2yo6jptKsmoISjTdrAVA==
X-Received: by 2002:a17:90a:c596:: with SMTP id l22mr21219748pjt.46.1561835857333;
        Sat, 29 Jun 2019 12:17:37 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id h6sm5995223pfn.79.2019.06.29.12.17.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 12:17:36 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [Patch net] xfrm: remove a duplicated assignment
Date:   Sat, 29 Jun 2019 12:17:14 -0700
Message-Id: <20190629191714.5808-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 30846090a746 ("xfrm: policy: add sequence count to sync with hash resize")
Cc: Florian Westphal <fw@strlen.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/xfrm/xfrm_policy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b1694d5d15d3..3235562f6588 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -582,9 +582,6 @@ static void xfrm_bydst_resize(struct net *net, int dir)
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	write_seqcount_begin(&xfrm_policy_hash_generation);
 
-	odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
-				lockdep_is_held(&net->xfrm.xfrm_policy_lock));
-
 	odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
 				lockdep_is_held(&net->xfrm.xfrm_policy_lock));
 
-- 
2.21.0

