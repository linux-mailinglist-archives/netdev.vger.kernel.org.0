Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B1F4FAE0
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 11:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfFWJNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 05:13:34 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:60519 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfFWJNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 05:13:33 -0400
Received: from smtp6.infomaniak.ch (smtp6.infomaniak.ch [83.166.132.19])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5N9DTnM010109
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jun 2019 11:13:29 +0200
Received: from [192.168.1.25] (lin67-1-82-227-56-158.fbx.proxad.net [82.227.56.158])
        (authenticated bits=0)
        by smtp6.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5N9DSRm036683
        (version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO);
        Sun, 23 Jun 2019 11:13:28 +0200
Subject: Re: [PATCH] sis900: increment revision number
To:     Joe Perches <joe@perches.com>,
        Sergej Benilov <sergej.benilov@googlemail.com>,
        netdev@vger.kernel.org
References: <20190623074707.6348-1-sergej.benilov@googlemail.com>
 <8eb161f4757cc55d7138bf5d30014e8fb8e38a0d.camel@perches.com>
From:   Daniele Venzano <venza@brownhat.org>
Message-ID: <7038d64e-0d3c-6b13-04fd-b614efbf5162@brownhat.org>
Date:   Sun, 23 Jun 2019 11:13:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8eb161f4757cc55d7138bf5d30014e8fb8e38a0d.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I think it is good to know just by looking at the sources that the 
driver is still kept up-to-date, so I am in favor of this patch.

Daniele

On 23/06/2019 11:10, Joe Perches wrote:
> On Sun, 2019-06-23 at 09:47 +0200, Sergej Benilov wrote:
>> Increment revision number to 1.08.11 (TX completion fix).
> Better not to bother as the last increment was in 2006.
> The driver version gets the kernel version in any case.
>
>> diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
> []
>> @@ -1,6 +1,6 @@
>>   /* sis900.c: A SiS 900/7016 PCI Fast Ethernet driver for Linux.
>>      Copyright 1999 Silicon Integrated System Corporation
>> -   Revision:	1.08.10 Apr. 2 2006
>> +   Revision:	1.08.11 Jun. 23 2019
> etc...
>
>
