Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE944FDCFE
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359514AbiDLKtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356873AbiDLKpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:45:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64FA813E84;
        Tue, 12 Apr 2022 02:42:54 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3C1D0608FA;
        Tue, 12 Apr 2022 11:38:49 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Tue, 12 Apr 2022 11:42:44 +0200
Message-Id: <20220412094246.448055-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix cgroupv2 from the input path, from Florian Westphal.

2) Fix incorrect return value of nft_parse_register(), from Antoine Tenart.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit e8a64bbaaad1f6548cec5508297bc6d45e8ab69e:

  net/sched: taprio: Check if socket flags are valid (2022-04-11 10:51:00 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 6c6f9f31ecd47dce1d0dafca4bec8805f9bc97cd:

  netfilter: nf_tables: nft_parse_register can return a negative value (2022-04-12 11:36:37 +0200)

----------------------------------------------------------------
Antoine Tenart (1):
      netfilter: nf_tables: nft_parse_register can return a negative value

Florian Westphal (1):
      netfilter: nft_socket: make cgroup match work in input too

 net/netfilter/nf_tables_api.c | 2 +-
 net/netfilter/nft_socket.c    | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)
