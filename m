Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826365204D2
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbiEITCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240329AbiEITCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:02:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DC22016F9
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 11:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652122688; x=1683658688;
  h=from:to:subject:date:message-id:mime-version;
  bh=mXOM2EENcqFJvUKzSMblEp79JCGkOG/Qnj95kVeBgtc=;
  b=k6UlBqa6tXg/fr9W2Kh2nMOxkPZ0vhNRFwuX9NpIJwd42jI3R7mM5erW
   5DFmRMgx9WY7Xg7mrEIkvXfGtBjdqUcruNMyG8TD+CktXS0wp44B/KTVV
   UDG+wxXRJigbd9Ubny0Jvc9XBAPc/oCENz4rjtLeO1vj7QaUIqbcMCor0
   E5CK8DX3HGnfAllhpS9s55R+kp7pewiStvGIVLX3644SOfHQHgFUnto20
   uP+Yfes4OCwvBli3cENJFva3ALc+BqF+YLOd/0fYhLP+JqZob6KgvubKz
   ucK9HEMxrnnwAMsUSVfDS8UJMGb9j2mVZNQIa8OuWnyd/6Y1yd7ABv2yh
   w==;
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="172560100"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2022 11:58:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 9 May 2022 11:58:06 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 9 May 2022 11:58:06 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>
Subject: [PATCH net-next 0/2] net: phy: add comments for LAN8742 phy support
Date:   Mon, 9 May 2022 11:58:02 -0700
Message-ID: <20220509185804.7147-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add comments for 0xfffffff2 phy ID mask for the LAN8742 and the LAN88xx, explaining that they can coexist and allow future hardware revisions.
Also add one missing tab in smsc.c.

Yuiko Oshino (2):
  net: phy: microchip: add comments for the modified LAN88xx phy ID
    mask.
  net: phy: smsc: add comments for the LAN8742 phy ID mask.

 drivers/net/phy/microchip.c | 4 ++++
 drivers/net/phy/smsc.c      | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.25.1

