Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAED568EF8
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiGFQVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiGFQVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:21:20 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EC901117A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:21:15 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 34F97320166;
        Wed,  6 Jul 2022 17:21:13 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o97ls-0001iI-Oo;
        Wed, 06 Jul 2022 17:21:00 +0100
Subject: [PATCH net-next 0/2] sfc: Add EF100 BAR config support
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 06 Jul 2022 17:21:00 +0100
Message-ID: <165712441387.6549.4915238154843073311.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The EF100 NICs allow for different register layouts of a PCI memory BAR.
This series provides the framework to switch this layout at runtime.

Subsequent patch series will use this to add support for vDPA.
---

Martin Habets (2):
      sfc: Add EF100 BAR config support
      sfc: Implement change of BAR configuration


 drivers/net/ethernet/sfc/ef100_nic.c |   80 ++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |    6 +++
 2 files changed, 86 insertions(+)

--
Martin Habets <habetsm.xilinx@gmail.com>

