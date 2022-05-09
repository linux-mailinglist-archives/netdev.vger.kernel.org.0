Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686C85201E8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbiEIQJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238800AbiEIQJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:09:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379E5253A98;
        Mon,  9 May 2022 09:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98830B81761;
        Mon,  9 May 2022 16:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD71C385AE;
        Mon,  9 May 2022 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652112304;
        bh=+vBONpWCk4u1dZrmvGXnFM97wN6NNBp/8qozqHNZdx4=;
        h=From:To:Cc:Subject:Date:From;
        b=aNIBXW89AFHhJRGFfph+/PXwvvIVrIhcUf9Iscc8BZeB7HNrtBI0WQv46gffKVhU/
         f+uYpQ66VZwvikK4/ydh7nCke8evY3PoYI5FrTqWdnmO6RsQuleYrUBFzA0GyPqCVe
         dkgRPb4/XYJobJq28+SPJyJ6X+WOAhcTMLp73O4ublUlvJ8lsd1IP3EieuSyS6ACA0
         UZiqRv9NscsglE7qQuI1Kk60zrHHdMrvJSzGqmx3v0gTwgDMKPbI8nm9ebASo5exYf
         1Yh32LJ7vYsKUsgH8dgkSaTaVcMUwkHsKeyR5Jk4G/s9HX4Hr4CFXS5CNCb0d2+X8u
         9JcJJPx3znCdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, imagedong@tencent.com,
        dsahern@gmail.com, talalahmad@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] docs: document some aspects of struct sk_buff
Date:   Mon,  9 May 2022 09:04:53 -0700
Message-Id: <20220509160456.1058940-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
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

This small set creates a place to render sk_buff documentation,
documents one random thing (data-only skbs) and converts the big
checksum comment to kdoc.

RFC v2 (no changes since then):
 - fix type reference in patch 1
 - use "payload" and "data" more consistently
 - add snippet with calls
https://lore.kernel.org/r/20220324231312.2241166-1-kuba@kernel.org/

RFC v1:
https://lore.kernel.org/all/20220323233715.2104106-1-kuba@kernel.org/

Jakub Kicinski (3):
  skbuff: add a basic intro doc
  skbuff: rewrite the doc for data-only skbs
  skbuff: render the checksum comment to documentation

 Documentation/networking/index.rst  |   1 +
 Documentation/networking/skbuff.rst |  37 ++++
 include/linux/skbuff.h              | 301 ++++++++++++++++++----------
 3 files changed, 232 insertions(+), 107 deletions(-)
 create mode 100644 Documentation/networking/skbuff.rst

-- 
2.34.3

