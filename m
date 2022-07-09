Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129C056C612
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiGICxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiGICxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:53:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C147AB18
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 19:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B3E0CE2E5E
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 02:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5644C341C0;
        Sat,  9 Jul 2022 02:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657335183;
        bh=0oSKdYOBZIev0qnsn5rD11W1hmyPUlKHFW0mbG9Urzo=;
        h=From:To:Cc:Subject:Date:From;
        b=newUZiXp1CSX+RBBlZKofXcv2oHaRh5So3DFlPfnufQIVSK7dpUISy8HsjH6lzxh3
         TKHzZSmymsdS01aE5WdR14iplWgz8N3QR0o4r+DjhdCbJQhgwTxEnr7Wcz88iuHftT
         rH/kgkjQbbmxkY0y+6CbxZP98y6LjMDIfp6y4+Lb+df8COF1RCmXcdXwghx5541Wbj
         x4xfBKpQzSNuNYI0AzOMFMAJvx3lYgbwb1uCNbp/3t9WBZwlIJ42ZpLxPBVgM14JG3
         CN63EKUCd3+Fe2lEyWAF6SJFFi2FCQfElHVuYC+GtK+t3/WOxuGMGbpXb+RINR8Zuv
         +xS50D7qqOeGA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] tls: rx: follow-ups to NoPad
Date:   Fri,  8 Jul 2022 19:52:51 -0700
Message-Id: <20220709025255.323864-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few fixes for issues spotted by Maxim.

Jakub Kicinski (4):
  tls: fix spelling of MIB
  tls: rx: add counter for NoPad violations
  tls: rx: fix the NoPad getsockopt
  selftests: tls: add test for NoPad getsockopt

 Documentation/networking/tls.rst  |  4 +++
 include/uapi/linux/snmp.h         |  3 +-
 net/tls/tls_main.c                |  9 +++---
 net/tls/tls_proc.c                |  3 +-
 net/tls/tls_sw.c                  |  4 ++-
 tools/testing/selftests/net/tls.c | 51 +++++++++++++++++++++++++++++++
 6 files changed, 66 insertions(+), 8 deletions(-)

-- 
2.36.1

