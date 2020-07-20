Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEDB2260A2
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgGTNTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:19:38 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:37746 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTNTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:19:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06KDJXt2105006;
        Mon, 20 Jul 2020 08:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595251173;
        bh=lQkmrXkxmjgvdDGKUkqI+tRS+w+c5jgpkKk07Nq2HRI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=AbJ0kI+TCQee61e3e6pY9QSWfXUCY9+i+Zc1llG4XnVxSYXZ3RE4u0ONjsNWLqpH5
         47CDUzDjlYqkh0X+XmoQN3TK7SOUV/abBeLXbuFoxFW/IGvnU0Qd2KFXMuJJAutZcU
         ye3eVwpy98iH/IdlcDGhr2T4cjgg1hAY2ndgLxEg=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06KDJXHI061226
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 08:19:33 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 20
 Jul 2020 08:19:33 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 20 Jul 2020 08:19:33 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06KDJWNR014210;
        Mon, 20 Jul 2020 08:19:32 -0500
Subject: Re: [net-next PATCH v3 1/7] hsr: enhance netlink socket interface to
 support PRP
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200717151511.329-1-m-karicheri2@ti.com>
 <20200717151511.329-2-m-karicheri2@ti.com>
 <20200717.185611.1278374862685166021.davem@davemloft.net>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <fac7f266-98e5-2750-7230-d4e6bc94b4d4@ti.com>
Date:   Mon, 20 Jul 2020 09:19:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717.185611.1278374862685166021.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/20 9:56 PM, David Miller wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> Date: Fri, 17 Jul 2020 11:15:05 -0400
> 
>> @@ -32,7 +33,9 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
>>   		       struct netlink_ext_ack *extack)
>>   {
>>   	struct net_device *link[2];
>> -	unsigned char multicast_spec, hsr_version;
>> +	unsigned char multicast_spec;
>> +	enum hsr_version proto_version;
>> +	u8 proto = HSR_PROTOCOL_HSR;
> 
> Please use reverse christmas tree ordering for local variables.
> 
Ok.
> Thank you.
> 

-- 
Murali Karicheri
Texas Instruments
