Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF364CB15C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbiCBVfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiCBVfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:35:46 -0500
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EE243ECE
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:35:01 -0800 (PST)
Received: (qmail 77609 invoked by uid 89); 2 Mar 2022 21:35:00 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 2 Mar 2022 21:35:00 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 0/5] ptp: ocp: TOD and monitoring updates
Date:   Wed,  2 Mar 2022 13:34:54 -0800
Message-Id: <20220302213459.6565-1-jonathan.lemon@gmail.com>
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

Add a series of patches for monitoring the status of the
driver and adjusting TOD handling, especially around leap seconds.

Add documentation for the new sysfs nodes.

Jonathan Lemon (1):
  docs: ABI: Document new timecard sysfs nodes.

Vadim Fedorenko (4):
  ptp: ocp: add TOD debug information
  ptp: ocp: Expose clock status drift and offset
  ptp: ocp: add tod_correction attribute
  ptp: ocp: adjust utc_tai_offset to TOD info

 Documentation/ABI/testing/sysfs-timecard |  22 +++
 drivers/ptp/ptp_ocp.c                    | 232 +++++++++++++++++------
 2 files changed, 198 insertions(+), 56 deletions(-)

-- 
2.31.1

