Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C10A731CF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbfGXOhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:37:42 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44868 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfGXOhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 10:37:42 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so47313387edr.11;
        Wed, 24 Jul 2019 07:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TWTT6YD5xmmHLQ8NqWxp5VF2vzE1ezaxf9lnh1XS2/w=;
        b=CA+jpzga4i8X7wUqQh3D2NsxFNLhZs4qlXqRH6J20hyHLc7tr/bRzvILcNcs8TxIT1
         vKwRTH5QYASlKQ681RU/pBhw81k+9XoByq9x6c5jqdG6HcoMqVQ8mL4yJt/dGkmto9WO
         y4+IHa1XI3Mg4pqqKkMmAPjxzOcmSuyfJOO/QNbk8GFPo3r8QGLuKsdMkGaSO3wyKTZb
         WQwSHAamnTvCF/hEs3t/OVqmH5z/8f4ENxUZroRz8IafJe53/EValYRW97LQUhMKnfDS
         ZM7UZ+H3debMoNEO8aPSWAWFqkQdpqWjRzErQ7U0/iEl/jemFWj0KvZSUyOlOJmgjB//
         vvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TWTT6YD5xmmHLQ8NqWxp5VF2vzE1ezaxf9lnh1XS2/w=;
        b=nf9IcrQSCSjjjsKR7VYhuJ3o7SzkqmnKw1RZ9L8EXqP3h/WGyczlm9Mbu2KVBorLLO
         mDkNcHojXWzcMJCzChPYZahZuJhpHTrm85/m82jFo9T8qthU0ZUSR64HGzHIeysYxzjx
         3Hp42pAWgIdmqx+QQPLSn2PWvtrRkrmoQxzRa+PR4TCq98HO1YH30+vsePQNCrTf4SSu
         Dk2tsiF9Q0i05dRv8PKSnieV9ZdbgK69wtuoNV/0g6gc2Ws+iUUP3DYtwe1ToCMlm+G+
         34Kra9hcTPhC9W9xHPTGUdX572c6j177hjodvHVk+OpEe3haO1am/v6xHj8dL61ZdWpa
         jjXQ==
X-Gm-Message-State: APjAAAX1iAWwme58A8Abp1bcusvWB41BTRV+wGnepOYnfuAVNl2LHs/e
        6rRIxDA7IYrr2N2RnA+JqQ==
X-Google-Smtp-Source: APXvYqxC/jZNJyEw4Ahjdq75WHaL0LyYNComFoAz8fwPe58jYKm0eNtQsy23cTgEfzNUw5n9mhp9Gw==
X-Received: by 2002:a17:906:5042:: with SMTP id e2mr61790141ejk.220.1563979060071;
        Wed, 24 Jul 2019 07:37:40 -0700 (PDT)
Received: from presler.lan (a95-94-77-68.cpe.netcabo.pt. [95.94.77.68])
        by smtp.gmail.com with ESMTPSA id ns22sm9281459ejb.9.2019.07.24.07.37.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 07:37:39 -0700 (PDT)
From:   Rui Salvaterra <rsalvaterra@gmail.com>
To:     pablo@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Rui Salvaterra <rsalvaterra@gmail.com>
Subject: [PATCH] netfilter: trivial: remove extraneous space from message
Date:   Wed, 24 Jul 2019 15:37:33 +0100
Message-Id: <20190724143733.17433-1-rsalvaterra@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pure ocd, but this one has been bugging me for a while.

Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
---
 net/netfilter/nf_conntrack_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 8d729e7c36ff..209123f35b4a 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -218,7 +218,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 			return NULL;
 		pr_info("nf_conntrack: default automatic helper assignment "
 			"has been turned off for security reasons and CT-based "
-			" firewall rule not found. Use the iptables CT target "
+			"firewall rule not found. Use the iptables CT target "
 			"to attach helpers instead.\n");
 		net->ct.auto_assign_helper_warned = 1;
 		return NULL;
-- 
2.22.0

