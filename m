Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAE7134801
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgAHQcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:32:03 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39638 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726922AbgAHQcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:32:03 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5FFAB140086;
        Wed,  8 Jan 2020 16:32:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 8 Jan 2020
 16:31:56 +0000
Subject: Re: [PATCH net-next 00/14] sfc: code refactoring
To:     "Alex Maftei (amaftei)" <amaftei@solarflare.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5c991450-92e2-2079-0640-567ab2f23ab5@solarflare.com>
Date:   Wed, 8 Jan 2020 16:31:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-4.581000-8.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/vmLzc6AOD8DfHkpkyUphL9Dvc/j9oMIgUda1Vk3RqxOGUs
        fNazqaz0f1xSt/ApHHOQ5EOn6ZDjFULkU2wqeSg+LjsmuOashGIwjY20D2quYuLsQIDmr3S5OnR
        FDX9soFzCyfYnAuBEjiTBtovU3QAzHeBa8ICDvU4+NrfDUTEXxAX/tYZf6r/w0SxMhOhuA0QeXV
        AMcD8vucW9Hv1VMZJ6kZOl7WKIImrvXOvQVlExsJaWKijZlsbB2bNx1HEv7HAqtq5d3cxkNaCHa
        LMe2Keufmp1SLZra7G1xr06MiogProcLw2MzQgUkuHNQorA8fJt1xsvcDs8LMvXWbxxTZBaAygn
        JjHdWqpyzAn8+bE2OyvPG8GHaeWzBsRAh8WmTAcG2WAWHb2qekrMHC7kmmSWWgpFdCbsUfc=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.581000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578501122-eIkTbauItJKT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/01/2020 16:06, Alex Maftei (amaftei) wrote:
> Splitting some of the driver code into different files, which will
> later be used in another driver for a new product.
>
> Alexandru-Mihai Maftei (14):
>   sfc: add new headers in preparation for code split
>   sfc: further preparation for code split
>   sfc: move reset workqueue code
>   sfc: move mac configuration and status functions
>   sfc: move datapath management code
>   sfc: move some device reset code
>   sfc: move struct init and fini code
>   sfc: move some channel-related code
>   sfc: move channel start/stop code
>   sfc: move channel alloc/removal code
>   sfc: move channel interrupt management code
>   sfc: move event queue management code
>   sfc: move common rx code
>   sfc: move common tx code
For the series:
Reviewed-by: Edward Cree <ecree@solarflare.com>
