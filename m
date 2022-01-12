Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB13848BDAC
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 04:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350115AbiALDc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 22:32:28 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:53471 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236491AbiALDc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 22:32:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1cRT9h_1641958345;
Received: from 30.225.24.63(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1cRT9h_1641958345)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 12 Jan 2022 11:32:25 +0800
Message-ID: <c9cd9be8-9982-0f95-e862-7f54f8c3b886@linux.alibaba.com>
Date:   Wed, 12 Jan 2022 11:32:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after clcsock
 released
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
 <20220111101417.04402570@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220111101417.04402570@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/12 2:14 am, Jakub Kicinski wrote:
> On Mon, 10 Jan 2022 17:38:25 +0800 Wen Gu wrote:
>> -	return smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
>> +	rc = smc->clcsock->ops->getsockopt(smc->clcsock, level, optname,
>>   					     optval, optlen);
> 
> Please do realign the continuation line when moving the opening bracket.

Thanks for pointing this out. Will fix it.

Thanks,
Wen Gu
