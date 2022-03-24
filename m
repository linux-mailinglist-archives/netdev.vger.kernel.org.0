Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE304E6B0F
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355664AbiCXXO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355655AbiCXXOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:14:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D5E24BF6;
        Thu, 24 Mar 2022 16:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD5D2B82485;
        Thu, 24 Mar 2022 23:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AACC340EC;
        Thu, 24 Mar 2022 23:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648163597;
        bh=7DA9eVgXr7JdebMF0OqQLCnaWNjq95dePMXwJYu6rvA=;
        h=From:To:Cc:Subject:Date:From;
        b=uHIxHVnJxM5c0Pc5XkNPP+3dLuT1Gvu64SOp2GlV+N1ZkqPv4K2buKd2qTLWOUv0D
         L/5auMk+P/pYRWi8njyGulLrWJu0xwXQbjFkPmx5VpAhM86Vnw0rwQBSLjF9ceoE3T
         Mg2ZI1A2ovCSTcAzhYQ4qSRTpPgwvpibIuWp1xAyAcFXHQs54Cua3Vo1+YHYHimlri
         Y0iYt7wCtOoksomrTe04jO9NwOfV4FiRSJrrZ6TO+Ayz0yj5rk51jZ/MTAm4M+964T
         UTXnBPX0rlF1ISAlwo5yI00TYOf8LDWsozAiwLr43+pawwVQrINXdLvLP4h8uqBvCG
         y7NZnBUYcsviA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC v2 0/3] docs: document some aspects of struct sk_buff
Date:   Thu, 24 Mar 2022 16:13:09 -0700
Message-Id: <20220324231312.2241166-1-kuba@kernel.org>
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

This small set creates a place to render sk_buff documentation,
documents one random thing (data-only skbs) and converts the big
checksum comment to kdoc.

v2:
 - fix type reference in patch 1
 - use "payload" and "data" more consistently
 - add snippet with calls

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
2.34.1

