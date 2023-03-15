Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB2E6BC09F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjCOXE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjCOXE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:04:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98220763F3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C25561E91
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 23:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480B1C433D2;
        Wed, 15 Mar 2023 23:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921466;
        bh=ugXkUYeD0ajyC/z/U1Tbd+xw83jFVAkXur+3k7t8cAU=;
        h=From:To:Cc:Subject:Date:From;
        b=c2YMEJpbic/KaYifTcguL7x28uKrAO/kPHNJOrY7XndhRxMV2GaFJcf5PWmCgpgpw
         A41oxcMAaeLlyH21jKQhv5UQhztW6ZjL5ZHI0jteJZ8u36F57g43rEWBRxVI3Ia+U0
         2SPYA/0y63gXYPewcHBEn3+WVNkBzTMEk++imwQaVvEfYHB/kUoPEhr4blhif/5HG8
         Ae8gHaA/ikREBUXMr0Ya9yK+QNa4id+S8GXme+TWitjrK+NpMD9YzsZAHBWZdvotfY
         rmGZ6jszboTpASO6nLkhkLe36cngjSXoQxthPu2Zi/wwgsQYdSeojojPrS3+8sKjFT
         Uc+C+OWJQMhHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        chuck.lever@oracle.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] ynl: another license adjustment
Date:   Wed, 15 Mar 2023 16:03:48 -0700
Message-Id: <20230315230351.478320-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hopefully the last adjustment to the licensing of the specs.
I'm still the author so should be fine to do this.

Jakub Kicinski (3):
  tools: ynl: make definitions optional again
  ynl: broaden the license even more
  ynl: make the tooling check the license

 Documentation/netlink/genetlink-c.yaml        |  2 +-
 Documentation/netlink/genetlink-legacy.yaml   |  2 +-
 Documentation/netlink/genetlink.yaml          |  2 +-
 Documentation/netlink/specs/ethtool.yaml      |  2 +-
 Documentation/netlink/specs/fou.yaml          |  2 +-
 Documentation/netlink/specs/netdev.yaml       |  2 +-
 Documentation/userspace-api/netlink/specs.rst |  3 ++-
 include/uapi/linux/fou.h                      |  2 +-
 include/uapi/linux/netdev.h                   |  2 +-
 net/core/netdev-genl-gen.c                    |  2 +-
 net/core/netdev-genl-gen.h                    |  2 +-
 net/ipv4/fou_nl.c                             |  2 +-
 net/ipv4/fou_nl.h                             |  2 +-
 tools/include/uapi/linux/netdev.h             |  2 +-
 tools/net/ynl/lib/nlspec.py                   | 11 ++++++++++-
 tools/net/ynl/ynl-gen-c.py                    | 15 ++++++++-------
 16 files changed, 33 insertions(+), 22 deletions(-)

-- 
2.39.2

