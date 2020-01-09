Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710F71350E9
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgAIBO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:14:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8245 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727770AbgAIBO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 20:14:26 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 131E76EE3DEA34F1B8A4;
        Thu,  9 Jan 2020 09:14:24 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 9 Jan 2020
 09:14:18 +0800
Subject: Re: [PATCH V2] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
To:     Matthew Wilcox <willy@infradead.org>,
        David Miller <davem@davemloft.net>
CC:     <klassert@kernel.org>, <hkallweit1@gmail.com>,
        <jakub.kicinski@netronome.com>, <hslester96@gmail.com>,
        <mst@redhat.com>, <yang.wei9@zte.com.cn>, <netdev@vger.kernel.org>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
References: <20200106125337.40297-1-yukuai3@huawei.com>
 <20200108.124021.2097001545081493183.davem@davemloft.net>
 <20200108215929.GM6788@bombadil.infradead.org>
 <20200108.150549.1889209588136221613.davem@davemloft.net>
 <20200109010344.GN6788@bombadil.infradead.org>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <b5dacc18-b93f-3760-966a-c36d058139e3@huawei.com>
Date:   Thu, 9 Jan 2020 09:14:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200109010344.GN6788@bombadil.infradead.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/1/9 9:03, Matthew Wilcox wrote:

> v2:
> -               mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
> 
> v3:
> -               mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
> +               mdio_read(dev, vp->phys[0], MII_BMSR);

Yes, V2 was a mistaken, my bad.
Please apply v3 instead.

Thanks!
Yu Kuai

