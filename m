Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48450AC432
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 05:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390254AbfIGDOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 23:14:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44800 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726940AbfIGDOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 23:14:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F1938C2C61551D3F70D4;
        Sat,  7 Sep 2019 11:14:05 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Sat, 7 Sep 2019
 11:14:01 +0800
Message-ID: <5D732078.6080902@huawei.com>
Date:   Sat, 7 Sep 2019 11:14:00 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kstewart@linuxfoundation.org>,
        <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ethernet: micrel: Use DIV_ROUND_CLOSEST directly to make
 it readable
References: <1567698828-26825-1-git-send-email-zhongjiang@huawei.com> <20190906194050.GB2339@lunn.ch>
In-Reply-To: <20190906194050.GB2339@lunn.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/7 3:40, Andrew Lunn wrote:
> On Thu, Sep 05, 2019 at 11:53:48PM +0800, zhong jiang wrote:
>> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
>> but is perhaps more readable.
> Hi Zhong
>
> Did you find this by hand, or did you use a tool. If a tool is used,
> it is normal to give some credit to the tool.
With the following help of Coccinelle. 
-(((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)

Sometimes, I will add the information in the description. Sometimes, I desn't do that.

I will certainly add the description when I send an series of patches to modify the case.

Thanks,
zhong jiang

> Thanks
> 	Andrew
>
> .
>


