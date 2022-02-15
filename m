Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2128D4B67A4
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 10:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiBOJcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 04:32:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiBOJca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 04:32:30 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3973DA94E6;
        Tue, 15 Feb 2022 01:32:20 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d7187a6e0343b5c7bb719883.dip0.t-ipconnect.de [IPv6:2003:e9:d718:7a6e:343:b5c7:bb71:9883])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 88520C0391;
        Tue, 15 Feb 2022 10:32:17 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2022-02-15
Date:   Tue, 15 Feb 2022 10:32:14 +0100
Message-Id: <20220215093214.3709686-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

Only a single fix this time.
Miquel Raynal fixed the lifs/sifs periods in the ca82010 to take the actual
symbol duration time into account.

regards
Stefan Schmidt

The following changes since commit c86d86131ab75696fc52d98571148842e067d620:

  Partially revert "net/smc: Add netlink net namespace support" (2022-02-02 07:42:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2022-02-15

for you to fetch changes up to bdc120a2bcd834e571ce4115aaddf71ab34495de:

  net: ieee802154: ca8210: Fix lifs/sifs periods (2022-02-02 18:04:50 +0100)

----------------------------------------------------------------
Miquel Raynal (1):
      net: ieee802154: ca8210: Fix lifs/sifs periods

 drivers/net/ieee802154/ca8210.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
