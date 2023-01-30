Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC582680A3B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbjA3J6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbjA3J6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:58:05 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956A52A990;
        Mon, 30 Jan 2023 01:57:24 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d7411771ca887222dece182b.dip0.t-ipconnect.de [IPv6:2003:e9:d741:1771:ca88:7222:dece:182b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 40BC3C01A9;
        Mon, 30 Jan 2023 10:56:52 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2023-01-30
Date:   Mon, 30 Jan 2023 10:56:46 +0100
Message-Id: <20230130095646.301448-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree:

Only one fix this time around.

Miquel Raynal fixed a potential double free spotted by Dan Carpenter.

regards
Stefan Schmidt

The following changes since commit 9cd3fd2054c3b3055163accbf2f31a4426f10317:

  net_sched: reject TCF_EM_SIMPLE case for complex ematch module (2022-12-19 09:43:18 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2023-01-30

for you to fetch changes up to 71a06f1034b91e15d3ba6b5539c7d3a2d7f13030:

  mac802154: Fix possible double free upon parsing error (2022-12-19 11:38:12 +0100)

----------------------------------------------------------------
Miquel Raynal (1):
      mac802154: Fix possible double free upon parsing error

 net/mac802154/rx.c | 1 -
 1 file changed, 1 deletion(-)
