Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3970E661E89
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 07:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjAIGAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 01:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjAIGAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 01:00:35 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BE5E003
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 22:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673244034; x=1704780034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ay8fDA3vkLdd1THsiMpVxoF/tUS+irAz+8dTGXTD+y8=;
  b=MqPJqQ8Gy9AJCUIB0kg2NVYgL6eIyBekfgMkLT428jJ/5HBxdbb45Z1V
   5IX2Oe1pa/HixP66ufBDDETAjYVgxCMH60ODSAKVCZMQqdhrKKdksNMMM
   aVwXCyHBmjqpXeePK60nHPP/jHd8S4kYS7vFDalaLLzZVdAl5AqUN6fB1
   E=;
X-IronPort-AV: E=Sophos;i="5.96,311,1665446400"; 
   d="scan'208";a="298094965"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 06:00:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id 4BF80A2DCE;
        Mon,  9 Jan 2023 06:00:29 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 9 Jan 2023 06:00:28 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.114) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Mon, 9 Jan 2023 06:00:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <darinzon@amazon.com>
CC:     <akiyano@amazon.com>, <alisaidi@amazon.com>, <davem@davemloft.net>,
        <itzko@amazon.com>, <kuba@kernel.org>, <matua@amazon.com>,
        <nafea@amazon.com>, <ndagan@amazon.com>, <netdev@vger.kernel.org>,
        <osamaabb@amazon.com>, <saeedb@amazon.com>, <shayagr@amazon.com>,
        <zorik@amazon.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH V1 net-next 5/5] net: ena: Add devlink documentation
Date:   Mon, 9 Jan 2023 15:00:15 +0900
Message-ID: <20230109060015.30921-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230108103533.10104-6-darinzon@amazon.com>
References: <20230108103533.10104-6-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D32UWB003.ant.amazon.com (10.43.161.220) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   David Arinzon <darinzon@amazon.com>
Date:   Sun, 8 Jan 2023 10:35:33 +0000
> Update the documentation with a devlink section, the
> added files, as well as large LLQ enablement.
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> Signed-off-by: David Arinzon <darinzon@amazon.com>
> ---
>  .../device_drivers/ethernet/amazon/ena.rst    | 30 +++++++++++++++++++

Each driver's devlink doc exists under Documentation/networking/devlink/ and
linked from index.html there.

We should duplicate this doc under Documentation/networking/devlink/ or link from
the index.html ?


>  1 file changed, 30 insertions(+)
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> index 8bcb173e0353..1229732a8c91 100644
> --- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> +++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> @@ -53,6 +53,7 @@ ena_common_defs.h   Common definitions for ena_com layer.
>  ena_regs_defs.h     Definition of ENA PCI memory-mapped (MMIO) registers.
>  ena_netdev.[ch]     Main Linux kernel driver.
>  ena_ethtool.c       ethtool callbacks.
> +ena_devlink.[ch]    devlink files (see `devlink support`_ for more info)
>  ena_pci_id_tbl.h    Supported device IDs.
>  =================   ======================================================
>  
> @@ -253,6 +254,35 @@ RSS
>  - The user can provide a hash key, hash function, and configure the
>    indirection table through `ethtool(8)`.
>  
> +.. _`devlink support`:
> +DEVLINK SUPPORT
> +===============
> +.. _`devlink`: https://www.kernel.org/doc/html/latest/networking/devlink/index.html
> +
> +`devlink`_ supports toggling LLQ entry size between the default 128 bytes and 256
> +bytes.
> +A 128 bytes entry size allows for a maximum of 96 bytes of packet header size
> +which sometimes is not enough (e.g. when using tunneling).
> +Increasing LLQ entry size to 256 bytes, allows a maximum header size of 224
> +bytes. This comes with the penalty of reducing the number of LLQ entries in the
> +TX queue by 2 (i.e. from 1024 to 512).
> +
> +The entry size can be toggled by enabling/disabling the large_llq_header devlink
> +param and reloading the driver to make it take effect, e.g.
> +
> +.. code-block:: shell
> +
> +  sudo devlink dev param set pci/0000:00:06.0 name large_llq_header value true cmode driverinit
> +  sudo devlink dev reload pci/0000:00:06.0
> +
> +One way to verify that the TX queue entry size has indeed increased is to check
> +that the maximum TX queue depth is 512. This can be checked, for example, by
> +using:
> +
> +.. code-block:: shell
> +
> +  ethtool -g [interface]
> +
>  DATA PATH
>  =========
>  
> -- 
> 2.38.1
