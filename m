Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEF84D0C6C
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbiCHAGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiCHAGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:06:33 -0500
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4024D13FBD
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:05:38 -0800 (PST)
Received: (qmail 98289 invoked by uid 89); 8 Mar 2022 00:05:37 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 8 Mar 2022 00:05:37 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v2 0/2] ptp: ocp: update devlink information
Date:   Mon,  7 Mar 2022 16:05:33 -0800
Message-Id: <20220308000536.2278-1-jonathan.lemon@gmail.com>
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

Both of these patches update the information displayed via devlink.

v1 -> v2: remove board.manufacture information

Jonathan Lemon (2):
  ptp: ocp: add nvmem interface for accessing eeprom
  ptp: ocp: Update devlink firmware display path.

 drivers/ptp/ptp_ocp.c | 233 +++++++++++++++++++++++++-----------------
 1 file changed, 140 insertions(+), 93 deletions(-)

-- 
2.31.1

