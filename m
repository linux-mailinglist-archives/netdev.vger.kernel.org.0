Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753005482D6
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbiFMJM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240621AbiFMJMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:12:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E53DBE6
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 02:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655111542; x=1686647542;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HfgnvqiIlmHwqvUYE2qqlcBZql1muXwFMi46vdyv/X0=;
  b=ucybqDm4CaNXboB0tIDqPN3F6ANwcWtYcuN1xoJJUV2eiFKmy+fvWq6y
   7+7JqIGaLL5E62jr+ORxAJN78nnTHmjvuxztTWNFfhAskD7lWlvo8fC2H
   T3xWG43cAmSqFT3msk2/mqL2HPGk/uBSXVCvT3cFro1KJ9yPojguK63nV
   olehVzrMnF/qJXJO8xCxLGM7T07ddXV4/hHbbDapJ/qXFwFC8CCfq+gS6
   +JwxmD+fYQv2QsoqRgy6svPHG+LJWEzNIbfRKYTN8Od5BJz1zViGyPJiQ
   YpgdHrDrXo4MPzLRNYgXQBI7l+esa2MohVz8BqFBgk1ysn0jOeCPCIv7e
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="168157866"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jun 2022 02:12:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Jun 2022 02:12:20 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Jun 2022 02:12:17 -0700
From:   Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Jan.Huber@microchip.com>,
        Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 0/1] Add driver support for Microchip EVB-LAN8670-USB
Date:   Mon, 13 Jun 2022 14:42:06 +0530
Message-ID: <20220613091207.17374-1-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds driver support for Microchip's EVB-LAN8670-USB 10BASE-T1S
Ethernet device.

Changes in v1:
- Added driver support for Microchip's EVB-LAN8670-USB 10BASE-T1S Ethernet
  device.

Parthiban Veerasooran (1):
  net: smsc95xx: add support for Microchip EVB-LAN8670-USB

 drivers/net/usb/smsc95xx.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.25.1

