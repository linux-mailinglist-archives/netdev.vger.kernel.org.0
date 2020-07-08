Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9D7219047
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgGHTQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:16:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:41182 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbgGHTQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:16:38 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 965A2600EA;
        Wed,  8 Jul 2020 19:16:37 +0000 (UTC)
Received: from us4-mdac16-47.ut7.mdlocal (unknown [10.7.66.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 94CDD800B2;
        Wed,  8 Jul 2020 19:16:37 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1AFF180055;
        Wed,  8 Jul 2020 19:16:37 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A0F55B40057;
        Wed,  8 Jul 2020 19:16:36 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jul 2020
 20:16:30 +0100
Subject: Re: [PATCH net-next 03/15] sfc_ef100: skeleton EF100 PF driver
To:     kernel test robot <lkp@intel.com>,
        <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kbuild-all@lists.01.org>, <netdev@vger.kernel.org>
References: <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
 <202007040146.fUpx7pAv%lkp@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5d39573d-ec51-8a35-041b-54afdbe1cb66@solarflare.com>
Date:   Wed, 8 Jul 2020 20:16:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202007040146.fUpx7pAv%lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25526.003
X-TM-AS-Result: No-2.850700-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8heczwUwXNyhwjVUc/h8Ki+CABYRpyLYSPrk1kyQDpEj8Cj5
        3aEB5qDLVStMHu3908YYrUjx2W5WfqH2g9syPs888Kg68su2wyFJaD67iKvY0+D3XFrJfgvzVec
        uP7D5Pj++T7QN/C2SRUhq/uY6sXKj9+5WkBOeNwcMOWxRtywg+ox4V49TS24wS8QrgUwl2irRWy
        uf87iSVOfOVcxjDhcwPcCXjNqUmkVYF3qW3Je6+6qrBcEWUamg9ynixNcasXAHzpvxx4jsjNtSP
        XYmY4lTa6PycAZcdMquzAZ0dm+CrOWccEKDlNotB6hZ7k6FCvoVMjx+KaOYtvAdfn5DyOPDXC6u
        Jnc/p0SsglkltB8xdGpozkualSTDO6clcnPxfVB+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.850700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25526.003
X-MDID: 1594235797-8KVt88lLXzTN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/07/2020 18:46, kernel test robot wrote:
>    In file included from include/linux/skbuff.h:31,
>                     from include/linux/if_ether.h:19,
>                     from include/uapi/linux/ethtool.h:19,
>                     from include/linux/ethtool.h:18,
>                     from include/linux/netdevice.h:37,
>                     from drivers/net/ethernet/sfc/net_driver.h:13,
>                     from drivers/net/ethernet/sfc/ef100.c:12:
>    drivers/net/ethernet/sfc/ef100.c: In function 'ef100_pci_parse_continue_entry':
>>> include/linux/dma-mapping.h:139:25: warning: conversion from 'long long unsigned int' to 'dma_addr_t' {aka 'unsigned int'} changes value from '18446744073709551615' to '4294967295' [-Woverflow]
>      139 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/ethernet/sfc/ef100.c:144:6: note: in expansion of macro 'DMA_BIT_MASK'
>      144 |      DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
>          |      ^~~~~~~~~~~~
I think this is spurious?  DMA_BIT_MASK() looks likeit's intended to
 return a dma_addr_t, and the conversion does the right thing (truncate
 to 32 bits), so maybe all that's needed is some suitable annotation to
 make the compiler happy.  Would casting explicitly to dma_addr_t do it?

-ed
