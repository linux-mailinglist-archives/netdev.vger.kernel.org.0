Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73276E7981
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjDSMT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjDSMTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:19:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8853CA25D;
        Wed, 19 Apr 2023 05:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 220D163323;
        Wed, 19 Apr 2023 12:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B65C433D2;
        Wed, 19 Apr 2023 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681906763;
        bh=h2Ce2bU58KO2qx3JaxnOdBFvUtb/DWqjoKWNyIszAIw=;
        h=From:To:Cc:Subject:Date:From;
        b=u3Jo4jlJ+fff+uqJBBM05hVrGMLCdyWeIV+krddZm02XmmzQxvYufrKu/oSO+0F7r
         e+1VkY50hA0eZ246oczyC4yS6iHeoTJSK9Aioitj2SB9axjGXUkIfcwOfe6DKa23Ti
         6ugCcqMqN99IJlPFDnPg10J7uhUTsUFeTpX/Lo0m0l6LYQKmeykkQsE6oVQj1gQ/MI
         NxJ4LhIz8RhDWhdC7cK5Aq1wHirrkad3jPoNMLDUK4fz5U1LOD2TCmOXFE/6aiF9Sd
         0o0yyGE6UEIiLFQW7qYR0r4wqx/89lq/kJTgItFwnt36DCKKNs7eDIBP9Vl0fBsiei
         iakn2PPmsiF8A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm 0/2] Couple of error unwind fixes to packet offload
Date:   Wed, 19 Apr 2023 15:19:06 +0300
Message-Id: <cover.1681906552.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi Steffen,

There are two straightforward fixes to XFRM.

Thanks

Leon Romanovsky (2):
  xfrm: release all offloaded policy memory
  xfrm: Fix leak of dev tracker

 net/xfrm/xfrm_device.c | 2 +-
 net/xfrm/xfrm_user.c   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.40.0

