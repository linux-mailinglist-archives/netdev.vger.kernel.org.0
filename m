Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA946A0F80
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 19:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjBWScC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 13:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBWSb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 13:31:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A87C55C34
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 10:31:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32588B81ACA
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 18:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A07C433D2;
        Thu, 23 Feb 2023 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677177112;
        bh=kmZ/BfLbqpmMlEuf4OtqwovdE2hv0Bq2C2WrYZ2U03k=;
        h=From:To:Cc:Subject:Date:From;
        b=RYwT8Vr1M2iCsY7kvz+8nBTKcdTyZWkwRhtTidpk5dJSzadmZ16fw0ubtc/o+RKok
         eHJydEO2Deb0AA0gNGIvcX+dvVQ9PYvDM60SUqpkGJXfZ5g3vA3TubAqCBQycC2vzj
         im/bxdHZD3qbSYeb6ZpfF8VdLI58luIzPcIr1fE0fd5VOO0BZydJlwtCrMpcMLLhZ1
         Yyxgjwq6VKHLXDbq498YW2SHIu2izBg9cx5usomi8eZcYTCCrHLJJ+AWfrgr3jHLo3
         vXfT17tJ2LN1uosuEcvnULirYESyNU41oJmcYwsmUaODEkuIEPLJeBNU4P+S9uTxKI
         22vDIDwCYUIyQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] tools: ynl-gen: fix glitches found by Chuck
Date:   Thu, 23 Feb 2023 10:31:38 -0800
Message-Id: <20230223183141.1422857-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A handful of fixes Chuck run into while trying to define the family
for crypto handshakes.

Jakub Kicinski (3):
  tools: ynl-gen: fix single attribute structs with attr 0 only
  tools: ynl-gen: re-raise the exception instead of printing
  tools: net: add __pycache__ to gitignore

 tools/net/ynl/lib/.gitignore | 1 +
 tools/net/ynl/lib/nlspec.py  | 4 +---
 tools/net/ynl/ynl-gen-c.py   | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)
 create mode 100644 tools/net/ynl/lib/.gitignore

-- 
2.39.2

