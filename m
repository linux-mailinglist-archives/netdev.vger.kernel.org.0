Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7050F249A78
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 12:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHSKhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 06:37:12 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55188 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgHSKhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 06:37:11 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 66BC56007D;
        Wed, 19 Aug 2020 10:37:10 +0000 (UTC)
Received: from us4-mdac16-31.ut7.mdlocal (unknown [10.7.66.142])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6423D8009B;
        Wed, 19 Aug 2020 10:37:10 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4AE428004D;
        Wed, 19 Aug 2020 10:37:09 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7850A1C007D;
        Wed, 19 Aug 2020 10:37:09 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Aug
 2020 11:37:04 +0100
Subject: Re: ethernet/sfc/ warnings with 32-bit dma_addr_t
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Michael Brown <mbrown@fensystems.co.uk>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>
References: <f8f07f47-4ba9-4fd6-1d22-9559e150bc2e@infradead.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <79f8e049-e5b3-5b42-a600-b3025ad51adc@solarflare.com>
Date:   Wed, 19 Aug 2020 11:37:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f8f07f47-4ba9-4fd6-1d22-9559e150bc2e@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25612.005
X-TM-AS-Result: No-3.834700-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/mLzc6AOD8DfHkpkyUphL9iRPU6vvejXJjLp8Cm8vwFwoe
        RRhCZWIByf4UUiPmFLpHBaYvF0hxKAOPKROgEivfg97SgFVEXOoGiajimoogud9RlPzeVuQQyqa
        t6b4pc93/bv2oZynN5hI8r75u7sxMESTBymy6GdYjCTunWqnclu6jyigxCo6ym7r74KWWSPnHdV
        eV+rtkthxTd/aq2eqhWzKDMQ9mrUFkffinb4LGEhbwCXv1ucAPPFYmvSWBwkBQmhcK24nKviswW
        B4d9sE3uhoDEhVVTzhftuJwrFEhTY2j49Ftap9ExlblqLlYqXLLl4mN1zPYGxDfwdeid5t62KWh
        uuHosRn9eo8OXsNOlqMJAypIdldPsGXXGa7TnN+glh5sp9q4zAraCIaNda80kUg/Se63/mWFcgJ
        c+QNMwu8bJovJYm8FYupx0XjSQPLDOFVmKqGJ4WptqaeO5a/g
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.834700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25612.005
X-MDID: 1597833430-ix0kwY47Kg4J
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2020 01:28, Randy Dunlap wrote:
> Hi,
>
> Does the drivers/net/ethernet/sfc/sfc driver require (expect)
> dma_addr_t to be 64 bits (as opposed to 32 bits)?
>
> I see that several #defines in ef100_regs.h are 64...
>
> When used with DMA_BIT_MASK(64), does the value just need to be
> truncated to 32 bits?  Will that work?
As far as I can tell, truncation to 32 bits is harmless — the
 called function (efx_init_io) already tries every mask from the
 passed one down to 32 bits in case of PCIe hardware limitations.

The ef10 and siena versions also truncate like this (their
 #defines are 48 and 46 respectively), but because they are
 handled indirectly through efx_nic_type, the compiler isn't able
 to determine this statically as it can with ef100.
> When I build this driver on i386 with 32-bit dma_addr_t, I see
> the following build warnings:
Could you test whether explicitly casting to dma_addr_t suppresses
 the warnings?  I.e.

    efx_init_io(efx, bar,
                (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
                pci_resource_len(efx->pci_dev, bar));

-ed
