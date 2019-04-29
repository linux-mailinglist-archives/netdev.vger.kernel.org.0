Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30467E47F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfD2OR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:17:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7708 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728258AbfD2ORy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 10:17:54 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3D3799B46EFC098ABCCE;
        Mon, 29 Apr 2019 22:17:50 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 29 Apr 2019
 22:17:49 +0800
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: Fix inconsistent IS_ERR
 and PTR_ERR in cpsw_probe()
To:     Andrew Lunn <andrew@lunn.ch>
References: <20190429135650.72794-1-yuehaibing@huawei.com>
 <20190429135603.GI10772@lunn.ch>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <f3b8d542-9ba6-d867-4979-530b53a395d5@huawei.com>
Date:   Mon, 29 Apr 2019 22:17:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190429135603.GI10772@lunn.ch>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/4/29 21:56, Andrew Lunn wrote:
> On Mon, Apr 29, 2019 at 01:56:50PM +0000, YueHaibing wrote:
>> Change the call to PTR_ERR to access the value just tested by IS_ERR.
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Please could you add a Fixes: tag.
> 

Ok, will sendv2, thanks!

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
> 
> .
> 

