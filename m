Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FF64CCA1F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 00:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbiCCXi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 18:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbiCCXix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 18:38:53 -0500
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9D45370E
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 15:38:05 -0800 (PST)
Received: (qmail 33324 invoked by uid 89); 3 Mar 2022 23:38:04 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 3 Mar 2022 23:38:04 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 0/2] ptp: ocp: update devlink information
Date:   Thu,  3 Mar 2022 15:37:59 -0800
Message-Id: <20220303233801.242870-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303233801.242870-1-jonathan.lemon@gmail.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
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

Jonathan Lemon (2):
  ptp: ocp: add nvmem interface for accessing eeprom
  ptp: ocp: Update devlink firmware display path.

 drivers/ptp/ptp_ocp.c | 242 ++++++++++++++++++++++++++----------------
 1 file changed, 149 insertions(+), 93 deletions(-)

-- 
2.31.1

