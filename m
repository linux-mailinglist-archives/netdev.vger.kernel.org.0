Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DCE2F1DC5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390024AbhAKSPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:15:45 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15466 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbhAKSPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:15:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc95a80000>; Mon, 11 Jan 2021 10:15:04 -0800
Received: from [172.27.13.253] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 18:15:01 +0000
Subject: Re: [PATCH net-next v2 0/2] Dissect PTP L2 packet header
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>
References: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
 <X/xzgP/eJ1Edm79j@lunn.ch>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <275b5a1d-7f6a-7f35-0447-3c92dee85a53@nvidia.com>
Date:   Mon, 11 Jan 2021 20:14:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/xzgP/eJ1Edm79j@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610388904; bh=d+EVRLcNyGg2KanTYCKKvPxiGirrPhe+BUAx1L2jmMk=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=pfZHSxe5S1A3/jQCHYh3e/wxMO3hwXoEuZ2dTK+OHnIVPFoH6LyymaEoMXxlAy6/j
         P1O2UbPCMLvukookqlfE/OE07fB0mpVCfmZDvDQ0ymzqR7y/SIaPD+6TGS79pXI6ja
         AMUWf66RdDdfFdZJ0XZhKzvHvFyfFbW5Z2VErKghpO+w6wknO5TL3OeCFLwVOBxFku
         3gBVMdV9BPHti6CTmp5/lJHuuTVC1URAZDON1muTmxw977jMFJwIgY8UTbIq8FsB3R
         oZw6shT6vljWPHEn5KA7EL9oBBO1bGeQGpiv+ed+iQO7ZZXAOf0U15shGoXsgMrHAa
         PfK+Sd5DFzXKA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/2021 5:49 PM, Andrew Lunn wrote:
> On Mon, Jan 11, 2021 at 11:46:50AM +0200, Eran Ben Elisha wrote:
>> Hi Jakub, Dave,
>>
>> This series adds support for dissecting PTP L2 packet
>> header (EtherType 0x88F7).
>>
>> For packet header dissecting, skb->protocol is needed. Add protocol
>> parsing operation to vlan ops, to guarantee skb->protocol is set,
>> as EtherType 0x88F7 occasionally follows a vlan header.
>>
>> Changelog:
>> v2:
>> - Add more people to CC list.
> 
> Hi Eran
> 
> How about adding the PTP maintainer to the CC: list?
> 
>      Andrew
> 
No problem, will repost again soon.
