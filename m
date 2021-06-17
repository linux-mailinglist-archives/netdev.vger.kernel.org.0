Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE463AAC7F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 08:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhFQGjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 02:39:54 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7342 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhFQGjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 02:39:53 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G5C1j1SjZz6y7y;
        Thu, 17 Jun 2021 14:33:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 14:37:45 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 17 Jun
 2021 14:37:45 +0800
To:     <davem@davemloft.net>, <kuba@kernel.org>
From:   "shenjian (K)" <shenjian15@huawei.com>
Subject: questions about netdevice->features
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Message-ID: <dfbfb1bd-7d2c-a09d-44b4-08cb0a13e94a@huawei.com>
Date:   Thu, 17 Jun 2021 14:37:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I noticed that the enum NETIF_F_XXX_BIT has already used 64 bits since

NETIF_F_HW_HSR_DUP_BIT being added, while the prototype of 
netdev_features_t

is u64.   So there is no useable bit for new feature if I understand 
correct.


Is there any solution or plan for it ?



Thanks,

shen jian

