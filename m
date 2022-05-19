Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D777952DF1D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243854AbiESVV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiESVV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:21:57 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E92ED726
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:21:55 -0700 (PDT)
Received: (qmail 8841 invoked by uid 89); 19 May 2022 21:21:54 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 19 May 2022 21:21:54 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 00/10] ptp: ocp: various updates
Date:   Thu, 19 May 2022 14:21:43 -0700
Message-Id: <20220519212153.450437-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Collection of cleanups and updates to the timecard.

v3->v4
 Remove #ifdefs around PCI IDS
 Clarify wording in debugfs patch

v2->v3
 Remove inline keyword from function wrappers
 checkpatch style changes

v1->v2
 Fix clang compilation error

Jonathan Lemon (8):
  ptp: ocp: 32-bit fixups for pci start address
  ptp: ocp: Remove #ifdefs around PCI IDs
  ptp: ocp: revise firmware display
  ptp: ocp: parameterize input/output sma selectors
  ptp: ocp: constify selectors
  ptp: ocp: vectorize the sma accessor functions
  ptp: ocp: add .init function for sma_op vector
  ptp: ocp: fix PPS source selector debugfs reporting

Vadim Fedorenko (2):
  ptp: ocp: add Celestica timecard PCI ids
  ptp: ocp: Add firmware header checks

 drivers/ptp/ptp_ocp.c | 677 +++++++++++++++++++++++++-----------------
 1 file changed, 407 insertions(+), 270 deletions(-)

-- 
2.31.1
