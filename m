Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3194D3D00
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiCIWdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbiCIWdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:33:40 -0500
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E323BCF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:32:39 -0800 (PST)
Received: (qmail 24278 invoked by uid 89); 9 Mar 2022 22:32:38 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 9 Mar 2022 22:32:38 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v1 00/10] ptp: ocp: support for new firmware 
Date:   Wed,  9 Mar 2022 14:32:27 -0800
Message-Id: <20220309223237.34507-1-jonathan.lemon@gmail.com>
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

This series contains support for new firmware features for
the timecard.

Jonathan Lemon (10):
  ptp: ocp: Add support for selectable SMA directions.
  ptp: ocp: Add ability to disable input selectors.
  ptp: ocp: Rename output selector 'GNSS' to 'GNSS1'
  ptp: ocp: Add GND and VCC output selectors
  ptp: ocp: Add firmware capability bits for feature gating
  ptp: ocp: Add signal generators and update sysfs nodes
  ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT
  ptp: ocp: Add 4 frequency counters
  ptp: ocp: Add 2 more timestampers
  docs: ABI: Document new timecard sysfs nodes.

 Documentation/ABI/testing/sysfs-timecard |   94 +-
 drivers/ptp/ptp_ocp.c                    | 1210 +++++++++++++++++++---
 2 files changed, 1145 insertions(+), 159 deletions(-)

-- 
2.31.1

