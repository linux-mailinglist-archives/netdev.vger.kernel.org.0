Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CCB60556D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiJTCTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJTCTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:19:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8691D4428
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:19:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 603676171C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76701C433C1;
        Thu, 20 Oct 2022 02:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666232356;
        bh=cK1BuUsQm8SV6eEUkEaqw8HkpkTDuDpDgja4OcCdoMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Q7SBNxs6M+8qP8q5VcDUfNhL72Ds/09VFgwZVIMQSC2r3I7+LqXAb5s11Q0snbJTv
         S3B1L+dD/py+vm7ewij04f5i5IcUqE6kU+VUBkhh+Cee+l1hY13QExq9yqFpTT/QWo
         9aPkSjauT5aZMctJbewAzZjlaADyn7rHo9EQzC8i0y6rvuWWWamaDToYuomhz3lDnF
         WwlLWuAZi7uqabiqoLiKyObYnOH38O6eiT9QX7zrbk4kucLhxmb0ViAYoIdnSYDVVK
         6NU5LJcaNxMtSj8CigNFO4c1Uz2j15XrGbOdnHmESVBOViFdGBAsVsKH0hXCeZkFKt
         s76h9B8RANU/A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: add keyword match on PTP
Date:   Wed, 19 Oct 2022 19:19:13 -0700
Message-Id: <20221020021913.1203867-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of PTP drivers live under ethernet and we have to keep
telling people to CC the PTP maintainers. Let's try a keyword
match, we can refine as we go if it causes false positives.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c6ce094e55e..ba8ed738494f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16673,6 +16673,7 @@ F:	Documentation/driver-api/ptp.rst
 F:	drivers/net/phy/dp83640*
 F:	drivers/ptp/*
 F:	include/linux/ptp_cl*
+K:	(?:\b|_)ptp(?:\b|_)
 
 PTP VIRTUAL CLOCK SUPPORT
 M:	Yangbo Lu <yangbo.lu@nxp.com>
-- 
2.37.3

