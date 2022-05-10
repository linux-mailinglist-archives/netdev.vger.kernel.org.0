Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BCB5212B1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbiEJKx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240290AbiEJKx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:53:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE2A2AC0D4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AC5EB81CBD
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD77C385CB;
        Tue, 10 May 2022 10:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652179757;
        bh=Imekts7NADaq2I6t5Dpk8EkQ6dDB+2OFln8e4CrvQMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn65dioqyKJoovG+rSjuK7By/FuXu3nHuplcEViAUGadSdwjX8lsMSX57jZm1/k6z
         87xJxT97hpepa+5FscsEKfTBlvZq0puHTOsWisHmrJ8cFy/yplPa0m9kfiLD9vQ74U
         MNgrBbDL0HUMHxQzVqpmHwZPNGXbYeTNPG+kOnA6NQ/VRz5isTIZYNMniFIP8xZ+NV
         gtjlQJaYQsLZ+xv61KzTGxlXmnnr+9khMH1s5g+ekN2E5AxnL4fqw0hj/ZCCNxEFv5
         D9Ii/DbaKsCBz8jttCnraU6Cy1mxbfK/WeVoqgaZAhRS1PVOfdvuVp4pAHb8/u0V1P
         p3tN+TgnlKAYA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH iproute2-next 1/4] Update kernel headers
Date:   Tue, 10 May 2022 13:49:05 +0300
Message-Id: <b35d8c19515eebb254617d18016422519ddf0ceb.1652179360.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1652179360.git.leonro@nvidia.com>
References: <cover.1652179360.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/uapi/linux/xfrm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 06ad9afb..1541e47b 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -519,6 +519,7 @@ struct xfrm_user_offload {
  */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
+#define XFRM_OFFLOAD_FULL       4
 
 struct xfrm_userpolicy_default {
 #define XFRM_USERPOLICY_UNSPEC	0
-- 
2.35.1

