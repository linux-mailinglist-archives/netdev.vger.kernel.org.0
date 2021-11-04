Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888F4444ED8
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhKDG3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhKDG3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:29:05 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9D4C061714;
        Wed,  3 Nov 2021 23:26:27 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id p17so4587335pgj.2;
        Wed, 03 Nov 2021 23:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlnnt3n3O4Jk/rf550R30jHD5iuaforuARNIfO1qRrU=;
        b=Q3MVElHB90l/Gng+gMKxJXEErRAq29eXKemft+xA+adhXOZ/NMc/W92sfgb8xZl+Ql
         NgnoFw6KHmbP+64CdGOlsG6qYK9NRSmEoya4p15+pPlRkWA8i2zdTlQT6s3EtRQ/11jF
         ULYtnara3+lqXNmx1fNqCzV2oaaN8I9eLr6adnWJD1eU3DsQBtU27q7I/D2x4OMmExxJ
         c47OdBFkW+nEk4x7m9KN3MVaa0azsOYJjVSXYE/6+my1PMPMoXbd9Uyc02+1RIntggYy
         M3DCOhYSsPG3gNoY1jSiy4mPn5+1kQXorePgZKqQA8PuyxeW/1S0IQE5kblzk21AAKZJ
         JYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlnnt3n3O4Jk/rf550R30jHD5iuaforuARNIfO1qRrU=;
        b=jcj8t1MJ2a0eRD+35fwg7L3bR8GTazeK06+9pnuPoDXHKj2IjM5zs1lc5yUSagNbWB
         1dHLrIa6Ur5+Qjnk+XqQO5ajCo3QQZE/5INnhmIW+9LqmH+G4g1O34hSnK3w67HxpqXR
         DotQ4ltU8K7NqXGb0RcGamHNC5+7Fy4lAzmuW976KUtS4J7/Thvf2lrWt7yyjK7eZ+Vu
         ZHsGi7EW12PM6jxq/+PKzyods9apeyGvcuSmCcGnvrqStM4SSHfyKPskOfHgowPkhs1b
         B9sUWRSsxaYHJ6JdFR6ZzW0onGw3T56t+DbJRAbCp92fc1HN5ablFRp62jQTGTAuS/dd
         +AtQ==
X-Gm-Message-State: AOAM5324Cmx3BofJV+xva0ozytOvBuR+9H3ywWhuTU1BBputkZyRdhax
        QLVtro48vUuO9cqzwitOrVugJNTtFHQ=
X-Google-Smtp-Source: ABdhPJx220Vg/l6cKgMODZdCbqjkrY2TQ9yb+WgAGxk7h2rm9u/BFrL0LnjVBOBH5hmq5aXIamadkw==
X-Received: by 2002:a63:af09:: with SMTP id w9mr36793326pge.323.1636007187287;
        Wed, 03 Nov 2021 23:26:27 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h6sm929669pfg.128.2021.11.03.23.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:26:27 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] xfrm: Remove duplicate assignment
Date:   Thu,  4 Nov 2021 06:26:21 +0000
Message-Id: <20211104062621.2643-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The statement in the switch is repeated with the statement at the
beginning of the while loop, so this statement is meaningless.

The clang_analyzer complains as follows:

net/xfrm/xfrm_policy.c:3392:2 warning:

Value stored to 'exthdr' is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/xfrm/xfrm_policy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 7f881f5..e8a31b9 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3389,7 +3389,6 @@ decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)
 		case NEXTHDR_DEST:
 			offset += ipv6_optlen(exthdr);
 			nexthdr = exthdr->nexthdr;
-			exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 			break;
 		case IPPROTO_UDP:
 		case IPPROTO_UDPLITE:
-- 
2.15.2


