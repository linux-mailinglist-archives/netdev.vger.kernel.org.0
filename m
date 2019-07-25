Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF1F74FAD
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbfGYNhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:37:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2488 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387959AbfGYNhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 09:37:53 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 5CB8B7FCA28AA3ECAB45;
        Thu, 25 Jul 2019 21:37:50 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jul 2019 21:37:49 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 25
 Jul 2019 21:37:49 +0800
Subject: Re: [PATCH net] net: hns: fix LED configuration for marvell phy
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <shiju.jose@huawei.com>
References: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
 <20190722.181906.2225538844348045066.davem@davemloft.net>
 <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
 <20190725042829.GB14276@lunn.ch>
 <8017d9ff-2991-f94f-e611-4d1bac12e93b@huawei.com>
 <20190725130807.GB21952@lunn.ch>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <908373a2-68cd-51c4-df11-499c49d80ae3@huawei.com>
Date:   Thu, 25 Jul 2019 21:37:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190725130807.GB21952@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/25 21:08, Andrew Lunn wrote:
>> You are discussing about the DT configuration, is Matthias Kaehlcke's work
>> also provide a generic way to configure PHY LEDS using ACPI?
> 
> In general, you should be able to use the same properties in ACPI as
> DT. If the device_property_read_X() API is used, it will try both ACPI
> and OF to get the property.
> 
>     Andrew
> 
> .
> 

OK, thanks very much!

