Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C9B16F88A
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgBZH3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:29:09 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:35062 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgBZH3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:29:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1582702144;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=GeFe3a8JpWxYZMcgUT1mR4P3oZ/w0g5pxvqje8POyXo=;
        b=BwLHplVzJpJUbdtTqgQoYHsThH9CYAvp8HDrdsWtJnhYuuNLCeGrdm7dNOen5INt4Y
        r0lp5EH3QaR0i1HJvfnII5WFP+caWO2rHDTW09qlnwAvCjlnTSrJUyWAnhllL0drJq0T
        moDHke/OBxMs828LB//xHbuiIjSTaLJTfZHTl0tFIa3CbT6FqbufRqETd2hFMawDCvh9
        LO38VkZPOs+zZF6itesQ+w5wYQ0yuiTSfw4dbTiq2hchXbTax+phpNMq3/4JpF7W3EGz
        0T4Fzkh3mCmgmHQKa/oEU+OgP/l20jjPnQp0HICSor1+hSOLg9AHUUytQiGIC2BxkAsu
        85sA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGUMh7lCA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id g084e8w1Q7SxDz6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 26 Feb 2020 08:28:59 +0100 (CET)
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in slip_open
To:     David Miller <davem@davemloft.net>, yangerkun@huawei.com
Cc:     netdev@vger.kernel.org, maowenan@huawei.com
References: <5f3e0e02-c900-1956-9628-e25babad2dd9@huawei.com>
 <20200225.103927.302026645880403716.davem@davemloft.net>
 <38005566-2319-9a13-00d9-5a4f88d4bc46@huawei.com>
 <20200225.193043.522116649502857666.davem@davemloft.net>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <8654b2ef-1951-7f10-c09d-8f42beee9cd4@hartkopp.net>
Date:   Wed, 26 Feb 2020 08:28:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225.193043.522116649502857666.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/02/2020 04.30, David Miller wrote:
> From: yangerkun <yangerkun@huawei.com>
> Date: Wed, 26 Feb 2020 09:35:38 +0800
> 
>>
>>
>> On 2020/2/26 2:39, David Miller wrote:
>>> From: yangerkun <yangerkun@huawei.com>
>>> Date: Tue, 25 Feb 2020 16:57:16 +0800
>>>
>>>> Ping. And anyone can give some advise about this patch?
>>> You've pinged us 5 or 6 times already.
>> Hi,
>>
>> Thanks for your reply!
>>
>> I am so sorry for the frequently ping which can make some
>> noise. Wont't happen again after this...
> 
> Ok.  But please repost your patch without the RFC tag.
> 

In fact the comment

/* do not call free_netdev before rtnl_unlock */

is also obsolete and can be omitted as you describe the change in the 
commit message.

In similar code snipets in the kernel there are also no comments for this.

Thanks,
Oliver
