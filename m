Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2950546CE41
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbhLHHYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244480AbhLHHYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:24:11 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242A5C061574;
        Tue,  7 Dec 2021 23:20:40 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z5so5239356edd.3;
        Tue, 07 Dec 2021 23:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N065thw+k6mkW4uE7xptS5LtWJOlze4xFMWF9GLmge4=;
        b=XtlfEMAUeBeBTU6CPCBbk5pEywQnPXrtUAipvVLmnM2NVTmyssJpB7fbCqs63nR6e8
         YdyFitKenHJOt/CWR1C0WRRsvAkPWIbF3squ//JEZ1VtDKlHkgIoWoHCWCIFQ/B4Lxfm
         J/6/Ctkq4Ao6lpS3ltcuSn6PTpBwbiOinSxMUbnfO8kGmT/yPkiItFY7HY5c/wbOfIBT
         QW9/oMgRxYPIgoBwB/NeIZ3bOlMRzxTjrqI+WIcNiqMD+1gNufDItSBEYsyWxsIDETS+
         mM3uZ/2Xc7xD6B09qmodgbj1Js5P+EAxsBE4jhs8h2VtkZYFVaBn5W6FWffEn9Rl2mET
         CMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N065thw+k6mkW4uE7xptS5LtWJOlze4xFMWF9GLmge4=;
        b=fUov+ZIrYiN9jcToQ53wpYDZPJgA3aYgDgMaZgQwftOqyB2MxLxkVySh9yM64zpF+t
         k/xCi/h1hou+JBDLNsE8+iSCulU6HhNc/BgEmyt6ipAGPBopJ+tJ/jYKXqWyqqfokTqe
         flziGagqIwMmeRJvmfQx6ZhCV0DTl6Ynk/7iEh1+JCHcdB+RO1KBxwkcKMcSJstn6uqB
         pQstFTu7FLUbgL25SYAtuQsIPdIyQWFQ+ANaMd4wSsidCZdsODKkGgNIqtpd2K+eTM76
         I0kMoQfHETQLVczzZ2Fv2guXj5uzdmU509Dfb951AqrQtMSWveZYsKf/FePl4TCDu2if
         XZRg==
X-Gm-Message-State: AOAM531Ey+2Fy0XjFFqVMfXAhcaeS7tlEdMNohykjB7FeWTZkrmfdELd
        lPR/agHoYgkXGpvxY/KO0kU=
X-Google-Smtp-Source: ABdhPJxHq0wj88KXQxEd1vovIVY7VG9d4ES/lLupxPq3KbmbCa9CWUJM8UI9kR5GkCOAbpxlIacCCQ==
X-Received: by 2002:a17:907:9495:: with SMTP id dm21mr5279129ejc.478.1638948038678;
        Tue, 07 Dec 2021 23:20:38 -0800 (PST)
Received: from localhost ([81.17.18.62])
        by smtp.gmail.com with ESMTPSA id e4sm1016393ejs.13.2021.12.07.23.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 23:20:38 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: netfilter: fix code indentation
Date:   Wed,  8 Dec 2021 00:20:23 -0700
Message-Id: <20211208024732.142541-3-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Use tabs for inadequate number of spaces for code indentation.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 03df986217b7..c0df2dc71c81 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -130,8 +130,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		break;
 	}
 
-       if (!oif) {
-               found = FIB_RES_DEV(res);
+	if (!oif) {
+		found = FIB_RES_DEV(res);
 	} else {
 		if (!fib_info_nh_uses_dev(res.fi, oif))
 			return;
