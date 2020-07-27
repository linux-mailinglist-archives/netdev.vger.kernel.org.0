Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9E622EB1B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgG0LWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:22:32 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:42094 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgG0LWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:22:32 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06RBMQ9D020074;
        Mon, 27 Jul 2020 06:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595848946;
        bh=cjOHNqbos8U9QHHdm8NoFhXloyp3FqlATA9mWNMvqIg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=N4VVSDl1shxZ5LVEH2OP072sDDbtFnOt8bxEszU8isU+UtOJyhNOokNJnr69vEF52
         x5F6EFWED5WrqfpkqwOnthum9hH2SWwTJ+cjmRFGQ5EOrZ2coNx0fIMoTzIgqGDJqY
         1Ssk6oh+oZvq+EiXnadHkZ47+IucHwkHuBEOatJQ=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06RBMQdf064228
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 06:22:26 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 27
 Jul 2020 06:22:26 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 27 Jul 2020 06:22:26 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06RBMQqf092859;
        Mon, 27 Jul 2020 06:22:26 -0500
Subject: Re: [net-next v5 PATCH 0/7] Add PRP driver
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200722144022.15746-1-m-karicheri2@ti.com>
 <7133d5ca-e72b-b406-feb2-21429085c96a@ti.com>
 <20200724.152136.239820662240192829.davem@davemloft.net>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <d2305d25-eeb9-1377-2209-d89bc10710b8@ti.com>
Date:   Mon, 27 Jul 2020 07:22:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724.152136.239820662240192829.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave,

On 7/24/20 6:21 PM, David Miller wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> Date: Fri, 24 Jul 2020 08:27:01 -0400
> 
>> If there are no more comments, can we consider merging this to
>> net-next? I could re-base and repost if there is any conflict.
> 
> I can't apply them until I next merge net into net-next, and I don't
> know exactly when that will happen yet.
> 
> It'd also be nice to get some review and ACK's on this series
> meanwhile.
> 
OK. Thanks.
-- 
Murali Karicheri
Texas Instruments
