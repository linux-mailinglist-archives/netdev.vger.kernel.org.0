Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6B27D286
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbgI2PPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:15:53 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:49138 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729069AbgI2PPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:15:52 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0F2E36007A;
        Tue, 29 Sep 2020 15:15:52 +0000 (UTC)
Received: from us4-mdac16-60.ut7.mdlocal (unknown [10.7.66.51])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 09435800B0;
        Tue, 29 Sep 2020 15:15:52 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7503E80058;
        Tue, 29 Sep 2020 15:15:51 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2AD85700084;
        Tue, 29 Sep 2020 15:15:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 16:15:43 +0100
Subject: Re: [RFC PATCH net-next] sfc: replace in_interrupt() usage
To:     Thomas Gleixner <tglx@linutronix.de>,
        <linux-net-drivers@solarflare.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <168a1f9e-cba4-69a8-9b29-5c121295e960@solarflare.com>
 <e45d9556-2759-6f33-01a0-d1739ce5760d@solarflare.com>
 <87k0wdk5t2.fsf@nanos.tec.linutronix.de>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d098eea1-6390-3900-b819-0c03e1872609@solarflare.com>
Date:   Tue, 29 Sep 2020 16:15:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <87k0wdk5t2.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25674.003
X-TM-AS-Result: No-3.520100-8.000000-10
X-TMASE-MatchedRID: 9zTThWtzImvoSitJVour/fHkpkyUphL9SeIjeghh/zNPQiQvzFiGeI3E
        a5VcsfoBkUx/UvKOwM2dwbgSqOKjW+kfPO9/GUD1SJA7ysb1rf4K+4pGZZRa9JHQtNioyyYF+CC
        Bfq8pKQrZpqB/bcVZI9MzaqAqqM3Scgthx7QzyPq5kFk6DtF9f02ImrcnCMc2myiLZetSf8nJ4y
        0wP1A6AAYnglAWdCYbFdA//ep4QUPdB/CxWTRRu+rAZ8KTspSzqRtRJdv3tn/+RkRCYiqBnVM6t
        BgxcXQ8G6vRBJBVxNSw7vJErt5g6AbEQIfFpkwHBtlgFh29qnpKzBwu5JpklnOUuoTXM7r4Qwym
        txuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.520100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25674.003
X-MDID: 1601392551-Q3SzIycjGKHr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Sep 28 2020 at 21:05, Edward Cree wrote:
>> Only compile-tested so far, because I'm waiting for my kernel to
>>  finish rebuilding with CONFIG_DEBUG_ATOMIC_SLEEP

I've now tested and confirmed that the might_sleep warning goes
 away with this patch.

Thomas, do you want to pull it into v2 of your series, or should
 I submit it separately to David?

-ed
