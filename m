Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0323F3A76FC
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFOGX7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 02:23:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4781 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFOGX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:23:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3yl84fffzXg43;
        Tue, 15 Jun 2021 14:16:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:21:52 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:21:52 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2176.012;
 Tue, 15 Jun 2021 14:21:52 +0800
From:   liweihang <liweihang@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        liangwenpeng <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 3/8] net: phy: delete repeated word of block
 comments
Thread-Topic: [PATCH net-next 3/8] net: phy: delete repeated word of block
 comments
Thread-Index: AQHXXoyiV8JepZszkUmSW3Y3nxL8sg==
Date:   Tue, 15 Jun 2021 06:21:52 +0000
Message-ID: <8d3ef499d1964b23a0f3ee3cf55e57ec@huawei.com>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-4-git-send-email-liweihang@huawei.com>
 <YMN1hjqpAJWDhLDI@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.100.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/11 22:39, Andrew Lunn wrote:
> On Fri, Jun 11, 2021 at 02:36:54PM +0800, Weihang Li wrote:
>> From: Wenpeng Liang <liangwenpeng@huawei.com>
>>
>> Fix syntax errors in block comments.
> 
> I supposed double words could be considered syntax errors, but it is
> pushing the definition a bit.
> 
> 	Andrew
> 

OK, I will use more appropriate words.

Thanks
Weihang
