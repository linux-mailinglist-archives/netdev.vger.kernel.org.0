Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47683180D3E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgCKBKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:10:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54869 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbgCKBJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id n8so282065wmc.4;
        Tue, 10 Mar 2020 18:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RuNOtjoIJ0PnueFmG34tyRMkYyJp/CS0kq/rmnLgTB8=;
        b=Ky5RLIT1Z12v+Tdj/SdmCF8yw8/esVe5wN2flSN6DvbtJiYTMcBZoKa8hjbCs/bABz
         dVkGsVx54HA62EKm6qRRC6fj5KrntxmxmLoSmTDHVN972WG02Pen5xBHVFzQnuSfMU2V
         x7Ya3EYfSOe4yxQfIBFPKfL4TtTzK3JxbGNHDf6he0YAHSD8YflAJ7j1+cjS42ti1QRb
         aUFiKBScPT4iy9+l0qY0Kah97UmvwP2sMgs4R6pfzhZ8aERSdxLz2trLB6ly3ozvc3Ys
         RlX3d6Moqp6pUOvX0Dh9Ctbk0R84djgtsCwsk3uEB4yqGsJ2ngqQYVqf+YGxAxw7jXR8
         Q1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RuNOtjoIJ0PnueFmG34tyRMkYyJp/CS0kq/rmnLgTB8=;
        b=swWPofLKhMIXhvf4tAiemiRGNn+1gtteFsLdD+xLtE13653MYqVC4wf+ZbLjPV37gu
         ztVvSiWDfS4az4CqFtLJVUo/ohnSdKPbJSg1xP8VRnnhEzqstLiPNSIsFSDGqX0eDPPl
         Vd0uBIc/4KzBnI7E0A3GGCIYKdd6qVMW+lV3GZSXdRhxeoTDEYZ7QJ+pTFD17Td9ITl/
         IrA+6XhZS1DWWyGTfl2R8YwbYHh2yKgkOHbbFS+fUYzGW2iQCquZf5z5m/OkdEdDm2rc
         /BCBOuUsXTly2mffbBqqwyg7mmw/R7wAk8QTKqiG+KsnKM0yKB7GuzARKKa2+6gob733
         gQJw==
X-Gm-Message-State: ANhLgQ0Qt8wIg/ec8tSusWzx1IiWdM1MnEf6cIFP85wrEKZyZqdELW6c
        3oUBWQ7YoHodV46Tja8uHQ==
X-Google-Smtp-Source: ADFU+vstobGIfUQ6tm+MOVwHT3BG0QrGLRFILKpE5LfNWrPT2WL1JG1k54PECBlvcaTJ+wBoJRZF5Q==
X-Received: by 2002:a1c:1fc7:: with SMTP id f190mr441997wmf.2.1583888969521;
        Tue, 10 Mar 2020 18:09:29 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:29 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH 4/8] netfilter: Add missing annotation for ctnetlink_parse_nat_setup()
Date:   Wed, 11 Mar 2020 01:09:04 +0000
Message-Id: <20200311010908.42366-5-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311010908.42366-1-jbi.octave@gmail.com>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at ctnetlink_parse_nat_setup()

warning: context imbalance in ctnetlink_parse_nat_setup()
	- unexpected unlock

The root cause is the missing annotation at ctnetlink_parse_nat_setup()
Add the missing __must_hold(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6a1c8f1f6171..eb190206cd12 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1533,6 +1533,7 @@ static int
 ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			  enum nf_nat_manip_type manip,
 			  const struct nlattr *attr)
+	__must_hold(RCU)
 {
 	struct nf_nat_hook *nat_hook;
 	int err;
-- 
2.24.1

