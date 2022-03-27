Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB0F4E851F
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiC0C4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiC0Czv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976831A83D;
        Sat, 26 Mar 2022 19:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 346A460EC7;
        Sun, 27 Mar 2022 02:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E915C34110;
        Sun, 27 Mar 2022 02:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349651;
        bh=8Gr2ykwZHxxNvxxe9SPSkIkwJsIUTmIr0sfhiehF5YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kR4FMObqmT31XzZWfgEvYmc+eLqxPgj2Z8KEeHQSnWefBlW5IYdSIxxwnZbfuZAGb
         Xr0YZNsQXPhoPw6Rxc9yzHQzo3EnTRWp3Ua5Ejyg8gqWXPabA3Ua1hjPAZUj86f/mh
         CvXMO93W4O4b0BbP8EsV63Rt/Ox0NIgQm4jLuI4Sn56uEpYxyQHdwksNefp+kPECRw
         uifnSlIrwkabeH9ppVGxuRF5xsXqZxLUAvCanTk7FgmMyTJcjyn6xgN7kkGfkjpoym
         6k0l0vEf7jImOgAvvtnrNIgSQr8SgtxBvmdZqDMq8gL0Mru5ssUry43ItF429hkrXC
         8SCX4L17uYWjA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 07/13] docs: netdev: rephrase the 'should I update patchwork' question
Date:   Sat, 26 Mar 2022 19:53:54 -0700
Message-Id: <20220327025400.2481365-8-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220327025400.2481365-1-kuba@kernel.org>
References: <20220327025400.2481365-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the question shorter and adjust the start of the answer accordingly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 5f7b1e6fb249..d2ad55db7d8a 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -125,9 +125,11 @@ Asking the maintainer for status updates on your
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
-I submitted multiple versions of the patch series. Should I directly update patchwork for the previous versions of these patch series?
---------------------------------------------------------------------------------------------------------------------------------------
-No, please don't interfere with the patch status on patchwork, leave
+Should I directly update patchwork state of my own patches?
+-----------------------------------------------------------
+It may be tempting to help the maintainers and update the state of your
+own patches when you post a new version or spot a bug. Please do not do that.
+Interfering with the patch status on patchwork will only cause confusion. Leave
 it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
-- 
2.34.1

