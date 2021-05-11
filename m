Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDB5379BE1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 03:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhEKBMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 21:12:42 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2049 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhEKBMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 21:12:36 -0400
Received: from dggeml715-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FfKX32sySzWhV5;
        Tue, 11 May 2021 09:07:15 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeml715-chm.china.huawei.com (10.3.17.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 11 May 2021 09:11:28 +0800
Received: from [127.0.0.1] (10.174.177.72) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 11 May
 2021 09:11:28 +0800
Subject: Re: [PATCH 1/1] b43: phy_n: Delete some useless empty code
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
References: <20210510145117.4066-1-thunder.leizhen@huawei.com>
 <YJmRUQwPPDE+hWiN@lunn.ch>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <1890aa92-ddf2-78f7-51e7-bdc3a58a04c6@huawei.com>
Date:   Tue, 11 May 2021 09:11:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YJmRUQwPPDE+hWiN@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/11 4:02, Andrew Lunn wrote:
> On Mon, May 10, 2021 at 10:51:17PM +0800, Zhen Lei wrote:
>> These TODO empty code are added by
>> commit 9442e5b58edb ("b43: N-PHY: partly implement SPUR workaround"). It's
>> been more than a decade now. I don't think anyone who wants to perfect
>> this workaround can follow this TODO tip exactly. Instead, it limits them
>> to new thinking. Remove it will be better.
>>
>> No functional change.
> 
> No function change, apart from the new warning?
> 
> Does your bot to compile the change and look for new warnings/errors?

Sorry, I have compiled it. I guess it's probably separated by macros, which I didn't notice. I will check it.

> 
>      Andrew
> 
> .
> 

