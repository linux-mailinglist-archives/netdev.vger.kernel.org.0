Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96EC51E276
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444704AbiEFWTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444698AbiEFWTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:19:18 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB8B30F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:15:33 -0700 (PDT)
Received: (qmail 73395 invoked by uid 89); 6 May 2022 22:15:32 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 6 May 2022 22:15:32 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v2 00/10] ptp: ocp: various updates
Date:   Fri,  6 May 2022 15:15:21 -0700
Message-Id: <20220506221531.1308-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Collection of cleanups and updates to the timecard.

v1->v2
 Fix clang compilation error

Jonathan Lemon (8):
  ptp: ocp: 32-bit fixups for pci start address
  ptp: ocp: revise firmware display
  ptp: ocp: parameterize input/output sma selectors
  ptp: ocp: constify selectors
  ptp: ocp: vectorize the sma accessor functions
  ptp: ocp: add .init function for sma_op vector
  ptp: ocp: fix PPS source selector reporting
  ptp: ocp: change sysfs attr group handling

Vadim Fedorenko (2):
  ptp: ocp: add Celestica timecard PCI ids
  ptp: ocp: Add firmware header checks

 drivers/ptp/ptp_ocp.c | 713 ++++++++++++++++++++++++++----------------
 1 file changed, 449 insertions(+), 264 deletions(-)

-- 
2.31.1
