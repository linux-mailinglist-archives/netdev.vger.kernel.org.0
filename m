Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D681E63B24A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiK1TbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiK1TbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:31:21 -0500
Received: from EX-PRD-EDGE02.vmware.com (ex-prd-edge02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A082CDC8;
        Mon, 28 Nov 2022 11:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=Lcc6s1T/+aDI4Sgf9WAzVhV+k36S+uzvhPZgwKc9VcA=;
    b=OnV3fw6mcLi7MDVCusBv32jome7THkR6DbE+7PgVtJd5mxxP8/u3S5kOYjZnm7
      hQamFh93j8GSIqUla9Szp2A2Qv8hzFVAvA2nEiDL0zP5gS3u8esGs7ePyfI1hR
      i8xCwsJfqvCgH+Xxg0wM7aUPiCtr1uOHs7aKJOdrmVdzsi8=
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 28 Nov 2022 11:30:51 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id D6132200A9;
        Mon, 28 Nov 2022 11:31:05 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id CD0EEAE1B0; Mon, 28 Nov 2022 11:31:05 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <doshir@vmware.com>
CC:     VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:VMWARE VMXNET3 ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net  0/2] vmxnet3: couple of fixes
Date:   Mon, 28 Nov 2022 11:31:01 -0800
Message-ID: <20221128193103.3742-1-doshir@vmware.com>
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

Changes in v2:
- declare generic descriptor to be used

Ronak Doshi (2):
  vmxnet3: correctly report encapsulated LRO packet
  vmxnet3: use correct intrConf reference when using extended queues

 drivers/net/vmxnet3/vmxnet3_drv.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

-- 
2.11.0

