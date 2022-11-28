Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8240D63B221
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiK1TWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiK1TWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:22:04 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 11:22:03 PST
Received: from EX-PRD-EDGE02.vmware.com (ex-prd-edge02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16981176;
        Mon, 28 Nov 2022 11:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=aQHJW6uc6OUbY/E0XGjjFgNwNikyHvetw3x19HKYP2I=;
    b=ewDl8ks8Hixx0UN0M70DzlRKovhqnkxWiJmVtC671I6nHVoHdCXAmFmJLBVZRj
      yAFdT/w+/enhS2UDcWa9gu0GEzn7lJvh6GT9pxZhTHaoNRjVHqUk6br48HRscl
      YyR4ZH+jw+7rCKj1uSTqU0nDlz+51w7vftinCMd9L+7Rmuw=
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 28 Nov 2022 11:19:43 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 161BE20262;
        Mon, 28 Nov 2022 11:19:57 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 0DD8CAE1A6; Mon, 28 Nov 2022 11:19:57 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/2] vmxnet3: couple of fixes
Date:   Mon, 28 Nov 2022 11:19:53 -0800
Message-ID: <20221128191955.2556-1-doshir@vmware.com>
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


Ronak Doshi (2):
  vmxnet3: correctly report encapsulated LRO packet
  vmxnet3: use correct intrConf reference when using extended queues

 drivers/net/vmxnet3/vmxnet3_drv.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

-- 
2.11.0

