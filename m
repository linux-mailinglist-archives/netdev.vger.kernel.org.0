Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612305212AC
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiEJKxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbiEJKx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2DE2AD74F
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A87B81C24
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85A3C385A6;
        Tue, 10 May 2022 10:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652179753;
        bh=NC9Y281A9E8MtsKCsSgVVznAIcb0dmCVQR7qh/TmpPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=CD4SmRh+j11ddUzii/Zp8IBPcbdXntxHO1E2pjZDntwF32kwU46w4LeDMxE5PqTTh
         tQFvdpUsHZiDovUAF8kH0F30mxJgTCUsqmNtCjzh3SpBQxFtzRjh2pwWuiBbuaiojC
         CB9n2eAdQq7Ld87HtXhrrs++pT2twLUngvkVqdZ4byyArbsoIJu6/ThVKL+bV/lIfA
         aYxZgUh5WquKDGgaShhJUvrza8hjRURTi21o8Ci3RpaaUVN579jXGI7Vb74GXsJ99G
         Epm57j93owC8cmyDtawV+veiY7KgD2Pv77maxnCPLnjvGP7xyK94YIh/aTUUEcOck+
         c1XIqevk9TJ1g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH iproute2=next 0/4] Add new IPsec offload type
Date:   Tue, 10 May 2022 13:49:04 +0300
Message-Id: <cover.1652179360.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
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

Extend ip tool to support new IPsec offload mode.
Followup of the recently sent series to XFRM core.
https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com

Leon Romanovsky (4):
  Update kernel headers
  xfrm: prepare state offload logic to set mode
  xfrm: add full offload mode to xfrm state
  xfrm: add an interface to offload policy

 include/uapi/linux/xfrm.h |  1 +
 ip/ipxfrm.c               | 16 +++++++++----
 ip/xfrm.h                 |  4 ++--
 ip/xfrm_monitor.c         |  2 +-
 ip/xfrm_policy.c          | 26 +++++++++++++++++++++
 ip/xfrm_state.c           | 49 +++++++++++++++++++++++++--------------
 man/man8/ip-xfrm.8        | 14 +++++++++++
 7 files changed, 87 insertions(+), 25 deletions(-)

-- 
2.35.1

