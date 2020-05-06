Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3169D1C7B82
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgEFUuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:50:05 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42162 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgEFUuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:50:05 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046Ko065019224;
        Wed, 6 May 2020 15:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588798200;
        bh=zErIkOUM2V+IZlTNObn2JOcGVqfwdR/ECG6kTD0muCA=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=SL/bek490xdqD/M2ZDGeb5RZF8zinHEuWGw1+eJa2pe9FBqXeK9fh6I9J129xxnVI
         2HKW74y8HGdOJBbTi/yTPOgjDmny1zHVC2wePQWbgX8daJsJAcMLhHyEsmDZUtj3QM
         RHikTU9Qi/OC1rtAskqfPcI0dtUJbVaU5FFhJ2XY=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046Ko0ee012025
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 15:50:00 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 15:50:00 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 15:50:00 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046KnxDe038789;
        Wed, 6 May 2020 15:49:59 -0500
Subject: Re: [net-next PATCH] net: hsr: fix incorrect type usage for protocol
 variable
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200506154107.575-1-m-karicheri2@ti.com>
 <87368dufx9.fsf@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <5c820a16-9c5f-1536-c4ea-6cd7658178c1@ti.com>
Date:   Wed, 6 May 2020 16:49:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87368dufx9.fsf@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 5/6/20 1:33 PM, Vinicius Costa Gomes wrote:
> Hi Murali,
> 
> Murali Karicheri <m-karicheri2@ti.com> writes:
> 
>> Fix following sparse checker warning:-
>>
>> net/hsr/hsr_slave.c:38:18: warning: incorrect type in assignment (different base types)
>> net/hsr/hsr_slave.c:38:18:    expected unsigned short [unsigned] [usertype] protocol
>> net/hsr/hsr_slave.c:38:18:    got restricted __be16 [usertype] h_proto
>> net/hsr/hsr_slave.c:39:25: warning: restricted __be16 degrades to integer
>> net/hsr/hsr_slave.c:39:57: warning: restricted __be16 degrades to integer
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
> 
> I think this patch should go via the net tree, as it is a warning fix.
> Anyway...
> 
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 
> 
Thanks. I will re-send it with net prefix and you ack. I thought since
this is just a warning, it is not that serious to include in net tree.

-- 
Murali Karicheri
Texas Instruments
