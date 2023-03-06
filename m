Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E885F6ACDE4
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCFTUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCFTUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:20:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6CB460AE
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 11:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369486108F
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 19:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67587C4339B;
        Mon,  6 Mar 2023 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678130421;
        bh=p8xn0s230MCYTfH1SVhWPuoSaC08mE0XGxAbcWmFUrs=;
        h=From:To:Cc:Subject:Date:From;
        b=FExVJmX7nOB/L2nuaLZlYRsQUUbv6DO8u910qEz0H/0YJgl8A0BFrq2lhaobibJVf
         /PYGEmXsF91pvEkiBr4pQO5ih9uUTcB09kQM7trv3hUXCgDIx5/fkO56xIJ3zxzSh4
         4ZUekWxNruEQ3ygDBGfCzsOlQX/DQorGCKR9xZW1I7UlB/plRLefoI3Z7NpPbHIqyC
         +aLpFLthtbedIi/DY7oTXtsVyfqBOOvQhxjUdFiryizT6EsibkVeAM4xoFF+UDZthY
         tfr58ZDc8NmJs8W94b1Eym4TzqoSm4Vmj6pJ8EZ32axMSyq40BXEIXp+2FB7oGRgaF
         +r40GIzrEirqw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, maxtram95@gmail.com
Subject: [PATCH net] mailmap: add entry for Maxim Mikityanskiy
Date:   Mon,  6 Mar 2023 11:20:18 -0800
Message-Id: <20230306192018.3894988-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Map Maxim's old corporate addresses to his personal one.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: maxtram95@gmail.com
---
 .mailmap | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.mailmap b/.mailmap
index a872c9683958..04bd44774ad0 100644
--- a/.mailmap
+++ b/.mailmap
@@ -304,6 +304,8 @@ Mauro Carvalho Chehab <mchehab@kernel.org> <mchehab@osg.samsung.com>
 Mauro Carvalho Chehab <mchehab@kernel.org> <mchehab@redhat.com>
 Mauro Carvalho Chehab <mchehab@kernel.org> <m.chehab@samsung.com>
 Mauro Carvalho Chehab <mchehab@kernel.org> <mchehab@s-opensource.com>
+Maxim Mikityanskiy <maxtram95@gmail.com> <maximmi@mellanox.com>
+Maxim Mikityanskiy <maxtram95@gmail.com> <maximmi@nvidia.com>
 Maxime Ripard <mripard@kernel.org> <maxime.ripard@bootlin.com>
 Maxime Ripard <mripard@kernel.org> <maxime.ripard@free-electrons.com>
 Mayuresh Janorkar <mayur@ti.com>
-- 
2.39.2

