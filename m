Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45A8228001
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 14:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgGUMef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 08:34:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49670 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728557AbgGUMee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 08:34:34 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E8E19B16BE2F347E0C0B;
        Tue, 21 Jul 2020 20:34:30 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.238) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Jul 2020
 20:34:22 +0800
Subject: Re: [PATCH v2] net: neterion: vxge: reduce stack usage in
 VXGE_COMPLETE_VPATH_TX
To:     David Miller <davem@davemloft.net>
CC:     <stephen@networkplumber.org>, <kuba@kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <christophe.jaillet@wanadoo.fr>, <john.wanghui@huawei.com>
References: <20200716173247.78912-1-cuibixuan@huawei.com>
 <20200719100522.220a6f5a@hermes.lan>
 <866b4a34-cd4e-0120-904f-13669257a765@huawei.com>
 <20200720.183849.626605331445628040.davem@davemloft.net>
From:   Bixuan Cui <cuibixuan@huawei.com>
Message-ID: <16aa9f4a-583e-2fd1-c14f-a3b2a6228436@huawei.com>
Date:   Tue, 21 Jul 2020 20:34:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200720.183849.626605331445628040.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.238]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/21 9:38, David Miller wrote:
> From: Bixuan Cui <cuibixuan@huawei.com>
> Date: Mon, 20 Jul 2020 09:58:39 +0800
> 
>> Fix the warning: [-Werror=-Wframe-larger-than=]
>>
>> drivers/net/ethernet/neterion/vxge/vxge-main.c:
>> In function'VXGE_COMPLETE_VPATH_TX.isra.37':
>> drivers/net/ethernet/neterion/vxge/vxge-main.c:119:1:
>> warning: the frame size of 1056 bytes is larger than 1024 bytes
>>
>> Dropping the NR_SKB_COMPLETED to 16 is appropriate that won't
>> have much impact on performance and functionality.
>>
>> Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
>> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
>> ---
>> v2: Dropping the NR_SKB_COMPLETED to 16.
> Applied.
thanks.

