Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D1B3E5085
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 03:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhHJBJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 21:09:20 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8385 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbhHJBJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 21:09:19 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GkF9S4TYMz85nH;
        Tue, 10 Aug 2021 09:05:00 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 10 Aug 2021 09:08:56 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 10
 Aug 2021 09:08:56 +0800
Subject: Re: [PATCH net-next 4/4] net: hns3: add support ethtool extended link
 state
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>
References: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
 <1628520642-30839-5-git-send-email-huangguangbin2@huawei.com>
 <20210809135456.397129f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <15810974-d1da-2a43-7a69-45dffff653a2@huawei.com>
Date:   Tue, 10 Aug 2021 09:08:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210809135456.397129f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/10 4:54, Jakub Kicinski wrote:
> On Mon, 9 Aug 2021 22:50:42 +0800 Guangbin Huang wrote:
>> +	if (!h->ae_algo->ops->get_link_diagnosis_info)
>> +		return -EOPNOTSUP;
> 
> Missing a P at the end here, this patch does not build.
> .
> 
I am very sorry, I will modify this fault and pay attentiaon to it later.
