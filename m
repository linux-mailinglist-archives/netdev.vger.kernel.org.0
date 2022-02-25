Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8185B4C44D2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbiBYMoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiBYMoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:44:02 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97837199D5F
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:43:30 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id b9so9237233lfv.7
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-disposition;
        bh=bKov9XinTzO4AOxcZCRsYD7kXnBgg+wd6I74ic8hwl8=;
        b=Adp4TF0/xzHxESXNg05j2A8g5pHwOV8JeYgnKA7vtXaMIEwPAgIstQ//LpDMJLiktR
         xf4hso/7gr+i3rPO2moNJsowwcHpLkv9x9qtyHAhxXnqOvaFVisJe8rIG/sDfsCdMQZ1
         3tRCAwQ5LCZApYP9GCydv97NGVZCJm1Rdfapqq6iJiNIRkE4Cz8MDxV+yctwIpJQmE3d
         ERTnXaxW6pj+/iIvh5ycuF76b9YncyyPvE1ej1PJDBH7k/8myiYqLjDAUeH/kQvAPAst
         8I2I8CshQsCGf1i7Oh3P4wNDB2tnGVi7Jgj/czgPpX6H/Z2EAx4FZtVkDkLUPNqPAAvO
         dfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-disposition;
        bh=bKov9XinTzO4AOxcZCRsYD7kXnBgg+wd6I74ic8hwl8=;
        b=oTye0le6oTrUxpNaX5TlwSB7vyYcThKQbi8NmhNx3ZXp3dMRD4Hs9EzG+4TwgbwT6/
         kMIHT50eVg5XChzo9EXQ3mph1OBKEsaiB6Bcb0VwDrhqFzQJfOIOeUHODEZkE8EFxBun
         Uj2wjbe98c1AV1nYJRYGJbhtPpeWA6Mo6l9zl0Mr91q3Px+UoF6/EHmGe1gRzllzPARn
         r1EvGQl/nPkECshWJ6J4EPWF0Kl83Ur7JVK4mr6UJk/yOs+n3P5Th2NPQA1rUOhxaw9W
         DyHLQpRIfziGlzROjlnMVTKpEFvki3/YKgPG3RweBHgLSSlPKG6TPPFt7MVcZHy3/2IN
         4atg==
X-Gm-Message-State: AOAM530z4Lj5T3Va74G6nyqqJZ+dhYOVlg7Vb0ngoGJlwOra7/WVAZYz
        3p48YkFYswAIin1tqXb7lrc=
X-Google-Smtp-Source: ABdhPJxc4lVmMVOlavlAG5RyHViaPd0FeH7Hnuzl1C4NbZ4dgV3epTDH7e8HgfqLSs7e11ZlcsKOsw==
X-Received: by 2002:a19:761a:0:b0:43c:79ae:6aef with SMTP id c26-20020a19761a000000b0043c79ae6aefmr5014255lff.630.1645793008776;
        Fri, 25 Feb 2022 04:43:28 -0800 (PST)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x5-20020a19f605000000b00443136b07f5sm196294lfe.63.2022.02.25.04.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 04:43:28 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:43:27 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net: sparx5: Add #include to remove warning
Message-ID: <20220225124327.ef4uzmeo3imnxrvv@wse-c0155>
Organization: Westermo Network Technologies AB
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

main.h uses NUM_TARGETS from main_regs.h, but
the missing include never causes any errors
because everywhere main.h is (currently)
included, main_regs.h is included before.
But since it is dependent on main_regs.h
it should always be included.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Joacim Zetterling <joacim.zetterling@westermo.com>
---
Should I perhaps remove all additional 
#include "sparx5_main_regs.h" 
since it now comes with main.h?

I didn't include a Fixes tag since this
does not affect any functionality.

 drivers/net/ethernet/microchip/sparx5/sparx5_main.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index a1acc9b461f2..d40e18ce3293 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -16,6 +16,8 @@
 #include <linux/phylink.h>
 #include <linux/hrtimer.h>
 
+#include "sparx5_main_regs.h"
+
 /* Target chip type */
 enum spx5_target_chiptype {
 	SPX5_TARGET_CT_7546    = 0x7546,  /* SparX-5-64  Enterprise */
-- 
2.30.2

