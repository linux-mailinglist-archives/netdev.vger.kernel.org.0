Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B36C445D44
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhKEB2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKEB2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:28:31 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA4AC061714;
        Thu,  4 Nov 2021 18:25:52 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x10so5505140qta.6;
        Thu, 04 Nov 2021 18:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JIcavUGP4LX3iq02e1UoWxtJ4o+tAE5fkSJl7yePIz0=;
        b=R6hJnuvlbXx0XS1bcjH34e66Ya+2OkHnAx42UALo0LkEIezlCqV6Et9n+7+ur9Bj7M
         kxPm3dlxEOrHRdf1wv+WMfDVfwRElj1MHgv4lgHzl9Ji4GY7JKWOEd2a9pgeZaqIfvbH
         eeiWi/npn8L/69r4u8+0O35dp5VG8KtPrqeSSwlVW1CEplaNvHeZSpmVEQTIxhEw4ZF1
         9dkCR/YYrO1iGNhwY/+AcPCIbKHny+lwKw9ul1WLoTIFDFkmh9aUxh3nlItl2+X0wN3I
         nIO9NFNaPyKWKDCuiLNLL+pSoZODcq0hAN4TGtYuONDvmqp8DzOWT2jxR2mC12WibDY4
         1+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JIcavUGP4LX3iq02e1UoWxtJ4o+tAE5fkSJl7yePIz0=;
        b=rYzRQoc0HlWpbCJGrNCVeGr04GGWZlmYSmgD87mo40nl7SkIl3OpYae7LlpmCjDxmk
         eBQPqAjXhTOuNhDsR32+GejMKbAcezbbjBjPpfKURca/dy1ha60hjQhEJ4+o043CipkT
         LxBYbEooAakWskNcYZdsqq3khaxllFXYmJRuPuUmk+SVag/fVC6xpWmVzI7LE626tI7G
         GGY8E8iMGwyhOjuZOOBkh0iQ5+g3NcWFvHjlhf01Qw9jZolUOU6s93H2Dd4haDVy9BUF
         Z6jNiNCn81bw2yN1+q73KCDyk5wxj4Eql8ElnxfnYRXV0hA3z2l/6iByO/CNZB5NCwlf
         Usew==
X-Gm-Message-State: AOAM530oqdSIWFPbAoSs7edm0rZzh1AwC9huzCVFK8BhfEPb9Hg1EypN
        8hghEbvSxC+oPYYvZnCR5r9G5s+RVyQ=
X-Google-Smtp-Source: ABdhPJy1swxiWI9BSEErgoM7m6XXHq/7a21tJgquoyGzDAFlm9Dun4CdCCkRw6sTk3wxh8SMvKwrGw==
X-Received: by 2002:a05:622a:414:: with SMTP id n20mr37804753qtx.249.1636075551444;
        Thu, 04 Nov 2021 18:25:51 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id w22sm4785140qto.15.2021.11.04.18.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:25:50 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] netfilter: nft_payload: remove duplicate include in nft_payload.c
Date:   Fri,  5 Nov 2021 01:25:41 +0000
Message-Id: <20211105012541.74005-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

'linux/ip.h' included in 'net/netfilter/nft_payload.c' is duplicated.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
---
 net/netfilter/nft_payload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cbfe4e4a4ad7..bd689938a2e0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -22,7 +22,6 @@
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <linux/ip.h>
 #include <net/sctp/checksum.h>
 
 static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
-- 
2.25.1

