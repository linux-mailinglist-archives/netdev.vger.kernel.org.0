Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF78E2D003C
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 02:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgLFB4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 20:56:48 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9119 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgLFB4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 20:56:47 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CpTzq1f1tz15XSv;
        Sun,  6 Dec 2020 09:55:35 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sun, 6 Dec 2020
 09:55:58 +0800
Subject: Re: [PATCH net-next 3/3] net: hns3: refine the VLAN tag handle for
 port based VLAN
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        <huangdaode@huawei.com>, Guojia Liao <liaoguojia@huawei.com>
References: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
 <1606997936-22166-4-git-send-email-tanhuazhong@huawei.com>
 <20201204182212.602b6c03@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <ed153dca-768f-6c8a-f790-f35f9b07de66@huawei.com>
Date:   Sun, 6 Dec 2020 09:55:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201204182212.602b6c03@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/12/5 10:22, Jakub Kicinski wrote:
> On Thu, 3 Dec 2020 20:18:56 +0800 Huazhong Tan wrote:
>> tranmist
> 
> Please spell check the commit messages and comments.
> 

will fix spelling mistakes, thanks

> .
> 

