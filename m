Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9080F2C3E48
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 11:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgKYKki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:40:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7549 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgKYKki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:40:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe34a60001>; Wed, 25 Nov 2020 02:40:38 -0800
Received: from [10.26.75.210] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 10:40:25 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <20201124011459.GD2031446@lunn.ch>
 <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
Date:   Wed, 25 Nov 2020 12:40:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606300838; bh=NBCEtjvx6MeFA5VB2jQn2+RxtLv0A3XacQzoi3ISbUg=;
        h=From:Subject:To:CC:References:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=QdwR84/Ds4AJpWQl9oEQu5/SHse4GZ3gWg8grWTZmMAfGPPqjDOgXScNtQdjInd9N
         K1VTD6Wv6MgS97InPzmcvep1PtfwH09IR2SJQh5Z8QIX5WYK/CJfVudaKsgGWWZW6u
         FKOR+vJNIDVR+Xf/ICL+gporip7LumM7sepzmS+q+jxeipVS//mV68tbk9hpEifAyj
         PlArUKwuInsQ0xGqeG5kG7iCnIgemv0N8f9cuoeYpvAs1EAchrM8DR4ko6k2Ztb5Vx
         wagfYRYVZvDcFeyRDz9nIAI61D4KrJBVjb8uh2LUhwG2jWJFsuekDBKpq3soqxRtnn
         kJcAwyGlpJIBA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/24/2020 11:16 PM, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 02:14:59 +0100 Andrew Lunn wrote:
>> On Mon, Nov 23, 2020 at 11:19:56AM +0200, Moshe Shemesh wrote:
>>> Add support for new cable module type DSFP (Dual Small Form-Factor Pluggable
>>> transceiver). DSFP EEPROM memory layout is compatible with CMIS 4.0 spec. Add
>>> CMIS 4.0 module type to UAPI and implement DSFP EEPROM dump in mlx5.
>> So the patches themselves look O.K.
>>
>> But we are yet again kicking the can down the road and not fixing the
>> underlying inflexibility of the API.
>>
>> Do we want to keep kicking the can, or is now the time to do the work
>> on this API?
> This is hardly rocket science. Let's do it right.

OK, we will add API options to select bank and page to read any specific 
page the user selects. So advanced user will use it get the optional 
pages he needs, but what about non advanced user who wants to use the 
current API with a current script for DSFP EEPROM. Isn't it better that 
he will get the 5 mandatory pages then keep it not supported ?

