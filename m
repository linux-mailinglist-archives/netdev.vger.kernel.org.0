Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255213AC037
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 02:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhFRArd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 20:47:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7478 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbhFRArc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 20:47:32 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5g9s5XV1zZhKb;
        Fri, 18 Jun 2021 08:42:25 +0800 (CST)
Received: from [10.67.100.138] (10.67.100.138) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 08:45:22 +0800
Subject: Re: [PATCH net-next 5/6] net: hostess_sv11: fix the comments style
 issue
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <huangguangbin2@huawei.com>
References: <1623941615-26966-1-git-send-email-lipeng321@huawei.com>
 <1623941615-26966-6-git-send-email-lipeng321@huawei.com>
 <YMt4ZMuPfjeesnRK@lunn.ch>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <2ea3967f-b4e4-323b-bf65-aac108c6d27f@huawei.com>
Date:   Fri, 18 Jun 2021 08:45:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <YMt4ZMuPfjeesnRK@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.100.138]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/18 0:29, Andrew Lunn 写道:
>> @@ -152,12 +146,12 @@ static int hostess_close(struct net_device *d)
>>   static int hostess_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
>>   {
>>   	/* struct z8530_dev *sv11=dev_to_sv(d);
>> -	   z8530_ioctl(d,&sv11->chanA,ifr,cmd) */
>> +	 * z8530_ioctl(d,&sv11->chanA,ifr,cmd)
>> +	 */
>>   	return hdlc_ioctl(d, ifr, cmd);
>>   }
> That looks more like dead code than anything else. I would suggest you
> do a git blame to see if there is anything interesting about this, and
> if not, remove it.
>
>     Andrew
> .

Hi,  Andrew

It's  dead code,  will remove it.

Thanks for your advice.

         Peng Li



