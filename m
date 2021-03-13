Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779F4339CF2
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 09:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhCMIhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 03:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhCMIg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 03:36:56 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F59C061574;
        Sat, 13 Mar 2021 00:36:56 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so11865668pjq.5;
        Sat, 13 Mar 2021 00:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=pw13xvwbpJthPfgMcnDcuZFFJIMbiCHbvYOTzm2l74M=;
        b=Mcdhxjx0gjbncyzOWAP7or1V0v/BpKOXms0V5Ogh177vCNqFuIacRJzpTMAj//N2hN
         PoWamqZccSZE+xhn+9JyjVpwENW0odIx3FACJpzr/ni5AjraiHNr6rg/NZxw6YoxMq5/
         BZOoINfbaDdaFQPDgJPqHVmPlHPA4cC3fzZLM8ebdJhpjP5kUmViqqbkt158cSm6c4O+
         1JB7BKaFCvtwNh4JdP0nzse9FX7Q7uo1lVeGDvk9k18CnKn0c7axprtLlf2u7bqtBI5O
         6It3RYTZtL05Oiko+2AJjPokYAaqZHaJhb/20hkaH3hatW/hIHbrqHvKK+sbgMMdZdEo
         ahAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=pw13xvwbpJthPfgMcnDcuZFFJIMbiCHbvYOTzm2l74M=;
        b=Rz/01lyzqTCBSn4/z4xhGwODF41sduwz0CWZMhekTuoaWSS9mHZ4Dz0ksiXEl/Z3wU
         PT3Ca3RkSowXteeH/pCj3qGs8Oh2MzMd8pgf24s+qPGhD7+VIfyUXwolcezwZrcuslil
         4rwxmcW+gH/UKPWXB0nyPUA7GaM3KbAAa77Rsgi7EX6PV+MbA6uM8fs5opIocUdmD4D9
         UUiYvQ9d/bs2ZMPF3mbjH6s49m3zxvGsxb0vpbFvdmCcKI3T1RraVn2Y9FZJQudgvTrJ
         qCE28hLO7jKMHrLcuGlb3u4ZTCLRNlQuQD+RL5L/8iW2n33717N9TbAooilRX+PeUNVu
         m0iA==
X-Gm-Message-State: AOAM530WmYehtfps35JJbZud3l3XTeISQwIBa2y7hh4q/wrhr5KBHOZO
        dUFuMF9ZjaAsdSZzalNPOw8BPOUl19UvvGOm
X-Google-Smtp-Source: ABdhPJyTf+tcwPOFfE3UUBqLP73lDNkOb0sSM95mXOfq4+idXr4bfYPBfS0/rS3g81e4diT7TrV35A==
X-Received: by 2002:a17:90a:86c9:: with SMTP id y9mr2554042pjv.205.1615624615579;
        Sat, 13 Mar 2021 00:36:55 -0800 (PST)
Received: from localhost ([115.99.139.115])
        by smtp.gmail.com with ESMTPSA id j188sm2187933pfd.64.2021.03.13.00.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 00:36:55 -0800 (PST)
Date:   Sat, 13 Mar 2021 14:06:49 +0530
From:   Sanjana Srinidhi <sanjanasrinidhi1810@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Subject: [PATCH] drivers: net: vxlan.c: Fix declaration issue
Message-ID: <20210313083649.2scdqxdcozfpoana@sanjana-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added a blank line after structure declaration.
This is done to maintain code uniformity.

Signed-off-by: Sanjana Srinidhi <sanjanasrinidhi1810@gmail.com>
---
 drivers/net/vxlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 666dd201c3d5..7665817f3cb6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3703,6 +3703,7 @@ static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
 #if IS_ENABLED(CONFIG_IPV6)
 		if (use_ipv6) {
 			struct inet6_dev *idev = __in6_dev_get(lowerdev);
+
 			if (idev && idev->cnf.disable_ipv6) {
 				NL_SET_ERR_MSG(extack,
 					       "IPv6 support disabled by administrator");
-- 
2.25.1

