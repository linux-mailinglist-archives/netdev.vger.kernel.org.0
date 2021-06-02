Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83122397F50
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 05:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhFBDHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 23:07:20 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2838 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhFBDHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 23:07:19 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fvv111sk3zWqjJ;
        Wed,  2 Jun 2021 11:00:53 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 11:05:35 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 2 Jun
 2021 11:05:35 +0800
Subject: Re: [PATCH net-next 1/2] net: hns3: add support for PTP
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>
References: <1622547265-48051-1-git-send-email-huangguangbin2@huawei.com>
 <1622547265-48051-2-git-send-email-huangguangbin2@huawei.com>
 <20210601145837.7b457748@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <f0cd8e4c-cb76-111c-8794-18bc805530ea@huawei.com>
Date:   Wed, 2 Jun 2021 11:05:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210601145837.7b457748@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/2 5:58, Jakub Kicinski wrote:
> On Tue, 1 Jun 2021 19:34:24 +0800 Guangbin Huang wrote:
>> From: Huazhong Tan <tanhuazhong@huawei.com>
>>
>> Adds PTP support for HNS3 ethernet driver.
> 
> Please repost CCing Richard Cochran, the PTP maintainer.
> .
> 
Ok.
