Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86A4EA6D7
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiC2FKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiC2FK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D002D115B;
        Mon, 28 Mar 2022 22:08:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764CC61457;
        Tue, 29 Mar 2022 05:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C644C34110;
        Tue, 29 Mar 2022 05:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530524;
        bh=SQPfqsNvIbtB/mPXmku6u4/+/U4nHoOxy19MUhP3/U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ox5xLf/wAZ+7mr9+R4dDUesDYPCtrwcyd9Y5Erc1aYZrMlLj7ODNijea70qrq/Kts
         OnLZ88vGv7148Ztx+BQJjTN2dqlYyxBaGkSBtUFGyOxhElzzsKZ3W3A1qzn2nyHr4/
         IKh2t9BJbFadGpFugv9HHxMP3MM/bjFMZIPnxKf5inoho7QzS+nNVgoqIrm4IKBkaf
         /DePvJI5IEC3Np6yWqjGikq9ro2BmYLLNgEXEdJPAFx7mXnt0jfwSJdZRV5VgoJZgo
         OS+Tm5AIjJLogHCW43Dlh/6spS0LLLfiqfMbkDqTnN91qhwPkSC1areLBumlI781EB
         1EbVzlADclsnw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 01/14] docs: netdev: replace references to old archives
Date:   Mon, 28 Mar 2022 22:08:17 -0700
Message-Id: <20220329050830.2755213-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329050830.2755213-1-kuba@kernel.org>
References: <20220329050830.2755213-1-kuba@kernel.org>
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

Most people use (or should use) lore at this point.
Replace the pointers to older archiving systems.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index e26532f49760..25b8a7de737c 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -16,10 +16,8 @@ Note that some subsystems (e.g. wireless drivers) which have a high
 volume of traffic have their own specific mailing lists.
 
 The netdev list is managed (like many other Linux mailing lists) through
-VGER (http://vger.kernel.org/) and archives can be found below:
-
--  http://marc.info/?l=linux-netdev
--  http://www.spinics.net/lists/netdev/
+VGER (http://vger.kernel.org/) with archives available at
+https://lore.kernel.org/netdev/
 
 Aside from subsystems like that mentioned above, all network-related
 Linux development (i.e. RFC, review, comments, etc.) takes place on
-- 
2.34.1

