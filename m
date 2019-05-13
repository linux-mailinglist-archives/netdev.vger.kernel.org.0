Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98C91B51F
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 13:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfEMLix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 07:38:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7632 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728566AbfEMLiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 07:38:52 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DBD484AAB01C23B5EE89;
        Mon, 13 May 2019 19:38:50 +0800 (CST)
Received: from [127.0.0.1] (10.177.216.125) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 May 2019
 19:38:48 +0800
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
References: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
 <20190513074928.GC22349@unicorn.suse.cz>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
From:   Weilong Chen <chenweilong@huawei.com>
Message-ID: <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
Date:   Mon, 13 May 2019 19:38:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <20190513074928.GC22349@unicorn.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.216.125]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/13 15:49, Michal Kubecek wrote:
> On Mon, May 13, 2019 at 09:33:13AM +0800, Weilong Chen wrote:
>> The remote host answers to an ICMP timestamp request.
>> This allows an attacker to know the time and date on your host.
>
> Why is that a problem? If it is, does it also mean that it is a security
> problem to have your time in sync (because then the attacker doesn't
> even need ICMP timestamps to know the time and date on your host)?
>
It's a low risk vulnerability(CVE-1999-0524). TCP has 
net.ipv4.tcp_timestamps = 0 to disable it.

>> This path is an another way contrast to iptables rules:
>> iptables -A input -p icmp --icmp-type timestamp-request -j DROP
>> iptables -A output -p icmp --icmp-type timestamp-reply -j DROP
>>
>> Default is disabled to improve security.
>
> If we need a sysctl for this (and I'm not convinced we do), I would
> prefer preserving current behaviour by default.
>
Firewall is not applied to all scenarios.

> Michal Kubecek
>
> .
>

thanks.

