Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1DF63B288
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiK1Tuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiK1Tus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:50:48 -0500
Received: from EX-PRD-EDGE02.vmware.com (ex-prd-edge02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E503027CC0;
        Mon, 28 Nov 2022 11:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=056KJHal9o+qA1dCf50ItXnIh7X4pPQymwj/n9fbiwE=;
    b=VhGij+L3ayViVaV9Ziy1a3uxA6n3fGt6/sN55wqvNOylwpon+qh+O9lF2RR6vD
      vztyCsTzew1G8HDyya5KigSb1QLgD2+QIFeQCzO+URvlBLPeCPftJBY1iQViN0
      k89MiTLFXW7CpW6IayN5YamL4i12A/vDCYl1KZSpqmTIeOE=
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 28 Nov 2022 11:50:33 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 9EE6A20266;
        Mon, 28 Nov 2022 11:50:47 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 97B8BAE1AE; Mon, 28 Nov 2022 11:50:47 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net  0/2] vmxnet3: couple of fixes
Date:   Mon, 28 Nov 2022 11:50:42 -0800
Message-ID: <20221128195043.3914-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes following issues:

Patch 1:
  This patch provides a fix to correctly report encapsulated LRO'ed
  packet.

Patch 2:
  This patch provides a fix to use correct intrConf reference.

Changes in v1:
- declare generic descriptor to be used

Ronak Doshi (2):
  vmxnet3: correctly report encapsulated LRO packet
  vmxnet3: use correct intrConf reference when using extended queues

 drivers/net/vmxnet3/vmxnet3_drv.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

-- 
2.11.0

