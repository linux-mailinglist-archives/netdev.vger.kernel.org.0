Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C8A502F0E
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348963AbiDOTL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348542AbiDOTLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9FADB2CB;
        Fri, 15 Apr 2022 12:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0CAE61BB8;
        Fri, 15 Apr 2022 19:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA50C385A5;
        Fri, 15 Apr 2022 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650049720;
        bh=QNhkR5f2VwsmRJLjyIIeuyQ3Ro0/ZTlpiHVGueu8khw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzXW0JUf3FmmvjCkNLPg6xeSiQ00FCdgqtRjSiv750sCreQXBhr+haJGO3gaKecxK
         Ut63sQ0/8xIkmtE1di1uclIYjE3djP8GM/NAZvEmiQ50vNroamDnR8EJhVyHC90mAX
         DCjvBvyeNWljHEVX3CqMYuSlRG8rajCE4XkjMSePx9n1RQV1NZMCyYIazZvPVRo+0I
         GHgXCH+MAp6nGOF2EU4Ezu3OBddS8QZSxKM+2+OKfJ2EOMkezjpNIdTE3XnvMI4AIT
         BkT+aUHhioeRJQGiWGOXv1o/Fi2wCjLqpTFlNLS+zZ+1bOC9ECLuRExRrZ8wlP2c6J
         beDpycOtgITAA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Chas Williams <3chas3@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5/7] powerpc: Remove unused SLOW_DOWN_IO definition
Date:   Fri, 15 Apr 2022 14:08:15 -0500
Message-Id: <20220415190817.842864-6-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415190817.842864-1-helgaas@kernel.org>
References: <20220415190817.842864-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Remove unused SLOW_DOWN_IO definition.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/powerpc/include/asm/io.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index fee979d3a1aa..c5a5f7c9b231 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -38,8 +38,6 @@ extern struct pci_dev *isa_bridge_pcidev;
 #define SIO_CONFIG_RA	0x398
 #define SIO_CONFIG_RD	0x399
 
-#define SLOW_DOWN_IO
-
 /* 32 bits uses slightly different variables for the various IO
  * bases. Most of this file only uses _IO_BASE though which we
  * define properly based on the platform
-- 
2.25.1

