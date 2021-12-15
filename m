Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78794755E8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbhLOKLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:11:07 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16815 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhLOKLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:11:07 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JDWG46RtLz91lG;
        Wed, 15 Dec 2021 18:10:20 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 18:11:04 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 18:11:04 +0800
To:     <xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
Subject: Re: [PATCH v9 00/17] Introduce VDUSE - vDPA Device in Userspace
CC:     "Fangyi (Eric)" <eric.fangyi@huawei.com>, <kvm@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mst@redhat.com>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <61B9BF2C.6070703@huawei.com>
Date:   Wed, 15 Dec 2021 18:10:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, yongji.

In vduse patches serial[1], you said "The support for other device types
can be added after the security issue of corresponding device driver
is clarified or fixed in the future."

What does this "security issue" mean?

[1]https://lore.kernel.org/all/20210831103634.33-1-xieyongji@bytedance.com/

Do you mean that vduse device is untrusted, so we should check config or 
data transferred
from vduse to virtio module? Or something others?
Because I found you added some validation in virtio module just like 
this patch[2].

[2]https://lore.kernel.org/lkml/20210531135852.113-1-xieyongji@bytedance.com/

Thanks!
Xiangdong Liu

