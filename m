Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5394917A43F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 12:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCEL3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 06:29:18 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:56445 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgCEL3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 06:29:18 -0500
Received: from [10.193.187.27] (localhost.asicdesigners.com [10.193.187.27] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 025BT6uD016108;
        Thu, 5 Mar 2020 03:29:07 -0800
Subject: Re: [PATCH net-next v3 6/6] cxgb4/chcr: Add ipv6 support and
 statistics
To:     Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, kuba@kernel.org
References: <20200229012426.30981-1-rohitm@chelsio.com>
 <20200229012426.30981-7-rohitm@chelsio.com>
 <8164bb64-3446-02ab-2dc9-68e995047229@mellanox.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <ed17e70d-464f-445f-5d27-157988f7dee1@chelsio.com>
Date:   Thu, 5 Mar 2020 16:59:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <8164bb64-3446-02ab-2dc9-68e995047229@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris,

On 04/03/20 10:35 PM, Boris Pismenny wrote:
>
> On 29/02/2020 3:24, Rohit Maheshwari wrote:
>> Adding ipv6 support and ktls related statistics.
>>
>> v1->v2:
>> - aaded blank lines at 2 places.
>>
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>> ---
> ...
>
>> +	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
>> +	seq_printf(seq, "KTLS connection opened:                  %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_connection_open));
>> +	seq_printf(seq, "KTLS connection failed:                  %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_connection_fail));
>> +	seq_printf(seq, "KTLS connection closed:                  %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_connection_close));
>> +	seq_printf(seq, "KTLS Tx pkt received from stack:         %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_pkts_received));
>> +	seq_printf(seq, "KTLS tx records send:                    %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_send_records));
>> +	seq_printf(seq, "KTLS tx partial start of records:        %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_start_pkts));
>> +	seq_printf(seq, "KTLS tx partial middle of records:       %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_middle_pkts));
>> +	seq_printf(seq, "KTLS tx partial end of record:           %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_end_pkts));
>> +	seq_printf(seq, "KTLS tx complete records:                %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_complete_pkts));
>> +	seq_printf(seq, "KTLS tx trim pkts :                      %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_trimmed_pkts));
>> +	seq_printf(seq, "KTLS tx retransmit packets:              %10u\n",
>> +		   atomic_read(&adap->chcr_stats.ktls_tx_retransmit_pkts));
>> +#endif
> Please confirm to TLS offload documentation or update it if you think it
> is necessary.

I'll take care of it in v4 patch.

