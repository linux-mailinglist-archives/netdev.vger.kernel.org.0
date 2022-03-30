Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9625A4EB991
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbiC3E1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242523AbiC3E1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454F5DF58;
        Tue, 29 Mar 2022 21:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1410B81B38;
        Wed, 30 Mar 2022 04:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451F7C340F2;
        Wed, 30 Mar 2022 04:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614313;
        bh=xUrwySdk8pPWDD17ccX90NEP3D7DzJVSGSGlzNVJ3lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlC1kSJ2BPl5WFsAK9ywdoWnCJn+RRBLY1/V9H40+EtFDIIvOaCN7LRH0ZL/q/t1n
         HXjddKaAcu/lqtc2A5L3lG34RhstkQeHW6nEalmAM+nIYj+KL3OZN89+/jaYay8rD3
         BSwQ4cVAvJ7XqSvcDE6AMZYMhx7jasxcKGPMiicxL0fz9tvCgv3CBdFy4sJYl3rRuY
         b89OcyyUR1W6LwNyroJsfoD5uheOGAfCmQMaH/0QyHIkArN1hVycZU5RnQ0BVtw9HR
         PgZ8PCO/Va4PVrJ2XjiRpEx1/Q7ZqsvEv2JQ/RED1mnzNyuNKbMi2zmG+es07Rgt1/
         2R2P0R0RRJEqA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 04/14] docs: netdev: turn the net-next closed into a Warning
Date:   Tue, 29 Mar 2022 21:24:55 -0700
Message-Id: <20220330042505.2902770-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
References: <20220330042505.2902770-1-kuba@kernel.org>
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

Use the sphinx Warning box to make the net-next being closed
stand out more.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index fd5f5a1a0846..041993258dda 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -70,8 +70,9 @@ relating to vX.Y
 An announcement indicating when ``net-next`` has been closed is usually
 sent to netdev, but knowing the above, you can predict that in advance.
 
-IMPORTANT: Do not send new ``net-next`` content to netdev during the
-period during which ``net-next`` tree is closed.
+.. warning::
+  Do not send new ``net-next`` content to netdev during the
+  period during which ``net-next`` tree is closed.
 
 Shortly after the two weeks have passed (and vX.Y-rc1 is released), the
 tree for ``net-next`` reopens to collect content for the next (vX.Y+1)
-- 
2.34.1

