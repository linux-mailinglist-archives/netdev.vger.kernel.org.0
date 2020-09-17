Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383FA26E6CC
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgIQUds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgIQUdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:33:47 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10DC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:33:47 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f1so1723000plo.13
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DnqP5nXd7jTFW1DizrHNjR5FPGXNAaMH67222dqiFpM=;
        b=DcX3b77eSephmhFRmbWwp3tW8U2ULTJQghHjcfS8TWCFlBd6a9qOqYOP3RTWcnVE2F
         Kjwvm9Sa4lyXjm/b+bsiipIF7fFe11ZC09mlL1cuHIrdqdO0NbKzh+22GtxR2CoyC35S
         enk0mh5Th3yDZ27SYaSykclFLrQwOyJHfPZDkY7RkzT82pB4MOLUd3gyVspr5RqxnNqk
         6F3TKUZwuhkvbdKWNCrPp6lIUtxaF5p1gKpxUg3zZLvKaiT+biOEhPxlAkYPRqCH2ibH
         kC3k0Eznwl+9lU8pS77uc34I1ckO4NJ1R7TVWzKbzD4RKD4zty5kdbsKgXbl+MoIVXyr
         IaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DnqP5nXd7jTFW1DizrHNjR5FPGXNAaMH67222dqiFpM=;
        b=ZZab5o2QriIKm5SU8NM/LNJVMfGxgVF/U88S9m9FIkTI8tdsxjr8KydZWpgToWPFmV
         nrydNwS4s6ds410wP1lwZ8g6olfZOaYLssRXGYBlEEvj6SsVcgTcaaOcQ3esvod+cjSZ
         RVbjOz3Se1c9Sm59rT45Rx8jLsJZW+WuEMcyeSZOeT7Y0Vh+sWAlG3S/ecomAB6JuC1x
         KSXnaslGzNi+hTbeM8rCx0bXLrw5re+FeznwRkpDdjDtYBuGScH5NJjudMS/+Gwt4R9w
         3DfpR5iTc3Pt9EvH80+2pt0Bee5bshiOJ300omAj5exBJCAkmLs9hbz5LoX/F0goCOn4
         JV4Q==
X-Gm-Message-State: AOAM530DCFA2BjO2jSLBcyafhxlurIMxremBHud1ChpFNZ00h8kaK0oP
        2y40ya5cIBqb/GG344FTT0PqpGdiCSWdXA==
X-Google-Smtp-Source: ABdhPJzDHFX5gkn3W46CDAjj5Hvzqc+4Sljb3EaWjAOGgLbQ6WvRKoznfWfSry0GmhD3iifaMoD1aQ==
X-Received: by 2002:a17:902:b218:b029:d1:e5e7:be0f with SMTP id t24-20020a170902b218b02900d1e5e7be0fmr12760052plr.66.1600374827077;
        Thu, 17 Sep 2020 13:33:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t12sm509018pfh.73.2020.09.17.13.33.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:33:46 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next] ionic: add DIMLIB to Kconfig
Date:   Thu, 17 Sep 2020 13:33:35 -0700
Message-Id: <20200917203335.23924-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> ld.lld: error: undefined symbol: net_dim_get_rx_moderation
   >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/ionic/ionic_lif.c:52)
   >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in archive drivers/built-in.a

>> ld.lld: error: undefined symbol: net_dim
   >>> referenced by ionic_txrx.c:456 (drivers/net/ethernet/pensando/ionic/ionic_txrx.c:456)
   >>> net/ethernet/pensando/ionic/ionic_txrx.o:(ionic_dim_update) in archive drivers/built-in.a

v2: removed sketchy dashes in commit message

Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index 76f8cc502bf9..5f8b0bb3af6e 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -21,6 +21,7 @@ config IONIC
 	tristate "Pensando Ethernet IONIC Support"
 	depends on 64BIT && PCI
 	select NET_DEVLINK
+	select DIMLIB
 	help
 	  This enables the support for the Pensando family of Ethernet
 	  adapters.  More specific information on this driver can be
-- 
2.17.1

