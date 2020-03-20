Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A224718C551
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgCTCdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:33:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33404 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbgCTCdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 22:33:21 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BAFFA24877BE96986CAF;
        Fri, 20 Mar 2020 10:33:14 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.234) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 10:33:13 +0800
Subject: Re: [PATCH bpf-next] bpf: tcp: Fix unused function warnings
To:     Jakub Sitnicki <jakub@cloudflare.com>
References: <20200319124631.58432-1-yuehaibing@huawei.com>
 <87fte4xot3.fsf@cloudflare.com>
CC:     <lmb@cloudflare.com>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <f27ae22a-e5e4-2873-1e00-bb59979e92ff@huawei.com>
Date:   Fri, 20 Mar 2020 10:33:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87fte4xot3.fsf@cloudflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/3/20 1:00, Jakub Sitnicki wrote:
> On Thu, Mar 19, 2020 at 01:46 PM CET, YueHaibing wrote:
>> If BPF_STREAM_PARSER is not set, gcc warns:
>>
>> net/ipv4/tcp_bpf.c:483:12: warning: 'tcp_bpf_sendpage' defined but not used [-Wunused-function]
>> net/ipv4/tcp_bpf.c:395:12: warning: 'tcp_bpf_sendmsg' defined but not used [-Wunused-function]
>> net/ipv4/tcp_bpf.c:13:13: warning: 'tcp_bpf_stream_read' defined but not used [-Wunused-function]
>>
>> Moves the unused functions into the #ifdef
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
> 
> In addition to this fix, looks like tcp_bpf_recvmsg can be static and
> also conditional on CONFIG_BPF_STREAM_PARSER.

Thanks, will do this in next version.

> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> .
> 

