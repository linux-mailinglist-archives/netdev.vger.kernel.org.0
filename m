Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671144E5BF3
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 00:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346003AbiCWXj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 19:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347111AbiCWXiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 19:38:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A807D814B7;
        Wed, 23 Mar 2022 16:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 455976184D;
        Wed, 23 Mar 2022 23:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A99C340E8;
        Wed, 23 Mar 2022 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648078640;
        bh=er9AJMEY3O9dL0EHJdJqvSVtAkeXSTt/kAh66khP7tk=;
        h=From:To:Cc:Subject:Date:From;
        b=dNmZ1GwDDw6+8bAsJU+z2xKi1v7F1nvBSV7vh8kH31qsr3Qr/YT22HjLC15kLHVZb
         B3LFYFt6bZEl2RQz9aBB+DHmJwsnxBKQsKogeOLBQyMlXHp3oWWt7pNmsCH0aelnVd
         Jg4ex1AFAfsBnT2INkxzXF+2hNjMjZAbEXwsUSk71w4c8UCZOyBhWPC8fgToHwbRJM
         35k42Irz+koOfzCKL1OAeqiseZxCBZRvLwYDy35taEcdOQIvRnPParZwXNYq2yIu2O
         81xAXJt9XxiQJ8nwhFndm+1Wdf0BPIunWTar245TlB/84NQaStOfFsuhk8zKI3f7cF
         +CkkLU+ByJYcA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 0/3] docs: document some aspects of struct sk_buff
Date:   Wed, 23 Mar 2022 16:37:12 -0700
Message-Id: <20220323233715.2104106-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I dusted off some old skb documentation patches I had in my tree.
This small set creates a place to render such documentation,
documents one random thing (data-only skbs) and converts the big
checksum comment to kdoc.

Jakub Kicinski (3):
  skbuff: add a basic intro doc
  skbuff: rewrite the doc for data-only skbs
  skbuff: render the checksum comment to documentation

 Documentation/networking/index.rst  |   1 +
 Documentation/networking/skbuff.rst |  37 ++++
 include/linux/skbuff.h              | 292 ++++++++++++++++++----------
 3 files changed, 224 insertions(+), 106 deletions(-)
 create mode 100644 Documentation/networking/skbuff.rst

-- 
2.34.1

