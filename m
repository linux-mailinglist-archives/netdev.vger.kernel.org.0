Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129BB204A0D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgFWGlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:41:12 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2529 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730540AbgFWGlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 02:41:12 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 42CEB7D1A30EFF123014;
        Tue, 23 Jun 2020 14:41:11 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 23 Jun 2020 14:41:10 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 23 Jun 2020 14:41:10 +0800
Subject: Re: [PATCH net-next v1 2/5] hinic: add support to set and get irq
 coalesce
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200620094258.13181-1-luobin9@huawei.com>
 <20200620094258.13181-3-luobin9@huawei.com>
 <20200622150843.5c0a94ff@kicinski-fedora-PC1C0HJN>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <28520c1c-80b6-e955-7c7c-207fb1599683@huawei.com>
Date:   Tue, 23 Jun 2020 14:41:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200622150843.5c0a94ff@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/23 6:08, Jakub Kicinski wrote:
>> +	if (coal->tx_max_coalesced_frames > COALESCE_MAX_PENDING_LIMIT) {
>> +		netif_err(nic_dev, drv, netdev,
>> +			  "Tx_max_coalesced_frames out of range[%d-%d]\n", 0,
>> +			  COALESCE_MAX_PENDING_LIMIT);
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	return 0;
>> +}
> I think ERANGE is a more appropriate error code in these?
Will fix. Thanks for your review.
