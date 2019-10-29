Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 726A5E8497
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731531AbfJ2JlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:41:08 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35478 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728575AbfJ2JlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 05:41:07 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D4786B40075;
        Tue, 29 Oct 2019 09:41:05 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 29 Oct 2019 09:40:57 +0000
Subject: Re: [PATCH net-next v2 0/6] sfc: Add XDP support
To:     David Ahern <dsahern@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <74c15338-c13e-5b7b-9cc5-844cd9262be3@solarflare.com>
 <8af30fef-6998-ed20-ba7c-982c9a4d263a@gmail.com>
From:   Charles McLachlan <cmclachlan@solarflare.com>
Message-ID: <add2ae6c-14cd-59c7-02aa-43d83f0a07a6@solarflare.com>
Date:   Tue, 29 Oct 2019 09:40:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8af30fef-6998-ed20-ba7c-982c9a4d263a@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25008.003
X-TM-AS-Result: No-3.017600-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9TkUH66TwzU50FoS1aixTNeey
        WMLRVf2LTPkqidFNTAV1S4DqawMuWrT0jVEXWzBwMiMrbc70Pfem3yCZiGA94J+4ziUPq4LxqRF
        iyZgRFsSt2gtuWr1Lmn/RPVYI5XEWvfz3vfVTDjUo7b5tLxYZrR5FmvZzFEQuy5JfHvVu9IviB6
        i8hqdc130tCKdnhB58vqq8s2MNhPCXxkCsDPSYDMIs1+7Tk9qQC24oEZ6SpSk6XEE7Yhw4Fnus9
        2ZdPpqR7fI59DQdemL83BedG+JmKwav/jmmHNL5Da5hPzvP8qY0P7G54/cycrLqMhfbZwUJTSXx
        jH1QGXOImdR/5ZBoKeL59MzH0po2K2yzo9Rrj9wPoYC35RuihKPUI7hfQSp53zHerOgw3HE=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.017600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25008.003
X-MDID: 1572342066-M3ISl81XhNbd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/10/2019 22:03, David Ahern wrote:
> On 10/28/19 7:56 AM, Charles McLachlan wrote:
>> Supply the XDP callbacks in netdevice ops that enable lower level processing
>> of XDP frames.
> 
> Hi:
> 
> I was hoping to try out this patch set, but when I rebooted the server
> with these applied I hit the BUG_ON in efx_ef10_link_piobufs:
> 
> 	if (tx_queue->queue == nic_data->pio_write_vi_base) {
> 		BUG_ON(index != 0);
> 		...

Interesting. 

Let's take this off the mailing list as I'd like to get you to collect some logs.
