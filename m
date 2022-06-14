Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFC554A885
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiFNFCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiFNFCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:02:31 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3131114D
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 22:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1655182950; x=1686718950;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=jrexPrOpAtGoJGLuIcwykPtjuMHwTxjOFCU2B3VD8KI=;
  b=emHPz/k8BeVe5b8G4gyRq74PODK1kLOOP0JiSAYcOY5BBv4t20hstUgZ
   aSzCniEhWIVTYR4wq1biRegrdTN/bFeBzmq7ENGqnyMspOFcaZnAiLEgu
   E9pjSA7eyvxQXtSDnlwN2fKcK4MD7rH52KZX6O7XBOm+kQdd5tUggP+83
   U=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 13 Jun 2022 22:02:29 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 22:02:29 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 13 Jun 2022 22:02:28 -0700
Received: from subashab-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 13 Jun 2022 22:02:27 -0700
From:   Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <sbrivio@redhat.com>
CC:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Subject: [PATCH net v2 0/2] net: ipv6: Update route MTU behavior
Date:   Mon, 13 Jun 2022 23:01:53 -0600
Message-ID: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up to the patch posted by Kaustubh
https://lore.kernel.org/netdev/1614011555-21951-1-git-send-email-kapandey@codeaurora.org/T/

This series addresses the comments from David Ahern to
update the exception route logic in the original patch and
add a new patch to update the IPv6 MTU tests.

Kaustubh Pandey (1):
  ipv6: Honor route mtu if it is within limit of dev mtu

Subash Abhinov Kasiviswanathan (1):
  tools: selftests: Update tests for new IPv6 route MTU behavior

 net/ipv6/route.c                    | 11 +----------
 tools/testing/selftests/net/pmtu.sh | 12 ++++++++----
 2 files changed, 9 insertions(+), 14 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

