Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907307A54E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfG3J7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:59:12 -0400
Received: from mx-relay27-hz1.antispameurope.com ([94.100.133.203]:54401 "EHLO
        mx-relay27-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfG3J7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:59:11 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay27-hz1.antispameurope.com;
 Tue, 30 Jul 2019 11:59:09 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Tue, 30 Jul
 2019 11:58:56 +0200
Subject: Re: DSA Rate Limiting in 88E6390
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <5a632696-946d-504b-1077-f7eb6d31ec19@eks-engel.de>
 <20190729150158.GE4110@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <fd08b6b3-3170-bf44-2f05-a0dd92ea868d@eks-engel.de>
Date:   Tue, 30 Jul 2019 11:58:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729150158.GE4110@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay27-hz1.antispameurope.com with 0DCE5BE0255
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.6943
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Hi all,
>> is there a possibility to set the rate limiting for the 6390 with linux tools?
>> I've seen that the driver will init all to zero, so rate limiting is disabled, 
>> but there is no solution for it in the ip tool?
>>
>> The only thing I found for rate limiting is the tc tool, but I guess this is 
>> only a software solution?
> Hi Benjamin
>
> In Linux, we accelerate the software solution by offloading it to the
> hardware. So TC is what you need here.
>  
>> Furthermore, does exist a table or a tutorial which functions DSA supports?
>> The background is that we are using the DSDT driver (in future maybe the UMSD
>> driver) but we would like to switch to the in kernel DSA entirely. And our
>> software is using some of the DSDT functions, so I have to find an 
>> alternative to these functions.
> The DSA framework supports offloading TC. There was some patches a
> while back adding ingress rate limiting to one of the DSA drivers, via
> TC. I forget which, and i don't think they have been merged yet. If
> you can find the patchset, it should give you a good idea how you can
> implement support in the mv88e6xxx driver.
>
> 	  Andrew

Hi Andrew,
I've searched the netdev mailing list for DSA and traffic, but can't find anything
about rate limiting till 2016. Do you have a hint, how I can find it?

Do you know if the patchset was for Marvell or maybe for another company?

Cheers,
Benjamin

