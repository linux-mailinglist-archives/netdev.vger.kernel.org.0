Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D3151CCED
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 01:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386940AbiEEXxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 19:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386937AbiEEXxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 19:53:04 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E551D606FA
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:49:23 -0700 (PDT)
Received: (qmail 30333 invoked by uid 89); 5 May 2022 23:49:22 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 5 May 2022 23:49:22 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH net-next v1 00/10] ptp: ocp: various updates
Date:   Thu,  5 May 2022 16:49:11 -0700
Message-Id: <20220505234921.3728-1-jonathan.lemon@gmail.com>
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

 drivers/ptp/ptp_ocp.c | 568 ++++++++++++++++++++++++++++--------------
 1 file changed, 377 insertions(+), 191 deletions(-)

-- 
2.31.1

