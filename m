Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2B0484209
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiADNEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:04:38 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47446 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230512AbiADNEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:04:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V0xwDYx_1641301475;
Received: from 30.225.28.71(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V0xwDYx_1641301475)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Jan 2022 21:04:36 +0800
Message-ID: <68e62015-9cba-f29e-b75a-d16561f446e5@linux.alibaba.com>
Date:   Tue, 4 Jan 2022 21:04:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net/smc: Reduce overflow of smc clcsock listen
 queue
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1641293930-110897-1-git-send-email-alibuda@linux.alibaba.com>
 <YdRFD8bY897LbUxr@TonyMac-Alibaba>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <YdRFD8bY897LbUxr@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Got it, i'll fix it soon.

Thanks.



在 2022/1/4 下午9:01, Tony Lu 写道:
> On Tue, Jan 04, 2022 at 06:58:50PM +0800, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> In nginx/wrk multithread and 10K connections benchmark, the
>> backend TCP connection established very slowly, and lots of TCP
>> connections stay in SYN_SENT state.
> <snip>
>
>> +struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work*/
> 												missing a space here ^
>>   struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
>>   struct workqueue_struct	*smc_close_wq;	/* wq for close work */
> <snip>
>
>>   	return (struct smc_sock *)sk;
>>   }
>>   
>> +extern struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work*/
> 												        missing a space here ^
>
> There are missing two spaces in comments. Besides that, this patch looks
> good to me, thanks.
>
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
>
> Thanks.
> Tony Lu
