Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE254506B1B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346821AbiDSLof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352300AbiDSLnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:43:09 -0400
X-Greylist: delayed 97 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Apr 2022 04:39:51 PDT
Received: from mail1.wrs.com (unknown-3-146.windriver.com [147.11.3.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39E72DF5;
        Tue, 19 Apr 2022 04:39:49 -0700 (PDT)
Received: from mail.windriver.com (mail.wrs.com [147.11.1.11])
        by mail1.wrs.com (8.15.2/8.15.2) with ESMTPS id 23JBdZV3005115
        (version=TLSv1.1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Tue, 19 Apr 2022 04:39:36 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.corp.ad.wrs.com [147.11.82.252])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 23JBdYg3000737
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Apr 2022 04:39:34 -0700 (PDT)
Received: from otp-dpanait-l2.corp.ad.wrs.com (128.224.125.182) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Apr 2022 04:39:31 -0700
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     <stable@vger.kernel.org>
CC:     <dragos.panait@windriver.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <davem@davemloft.net>,
        <paskripkin@gmail.com>, <gregkh@linuxfoundation.org>,
        <hbh25y@gmail.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.14 0/1] can: usb_8dev: backport fix for CVE-2022-28388
Date:   Tue, 19 Apr 2022 14:38:33 +0300
Message-ID: <20220419113834.3116927-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [128.224.125.182]
X-ClientProxiedBy: ala-exchng01.corp.ad.wrs.com (147.11.82.252) To
 ala-exchng01.corp.ad.wrs.com (147.11.82.252)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit is needed to fix CVE-2022-28388:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d3925ff6433f98992685a9679613a2cc97f3ce2

Hangyu Hua (1):
  can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in
    error path

 drivers/net/can/usb/usb_8dev.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)


base-commit: 74766a973637a02c32c04c1c6496e114e4855239
-- 
2.17.1

