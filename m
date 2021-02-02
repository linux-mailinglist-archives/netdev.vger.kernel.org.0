Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D3830C804
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbhBBRiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:38:14 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:31365 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237182AbhBBRey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1612287059;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
        From:Subject:Sender;
        bh=d6c9JvZ+ULTnF0wVQPp9B2N8i/b5AB3i6LLcChZtVrg=;
        b=ikN5N6c1pbjCxVBx0jlO26IOvUsfie7lCbYukAoGojCuRdLbAQKyj8aQHh6FbGJZeC
        4Z8eTz2RwOF6XLd7gHfjEIy1kheTRkokj9mVTSgA8FO07zQe2yZTB7W2WXmVFw1hS/Hr
        MZBvbJEPBOqG6Q83uBoMDr2oRTuTE2DXtMc1e63yWLCnRT5gDzsJLA+drBToZrkgE/64
        DDutcNK8EyggjJU+AQX4OKRJJA5l6UNUPicqg+RjsvNIPln+m2CDwKDcgy/yrVTjJOa8
        IuOZ6/w9BplVHO1Ug0lrR20U2yR17bSsS+WPYByZrG7fhrBhvj19lrDQxdq4GDH2ZAsl
        Mnrw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJV8h6kk/I"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.16.0 DYNA|AUTH)
        with ESMTPSA id w076a1x12HUvI3B
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 2 Feb 2021 18:30:57 +0100 (CET)
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20210125104055.79882-1-socketcan@hartkopp.net>
 <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
 <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
 <586c2310-17ee-328e-189c-f03aae1735e9@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <fe697032-88f2-c1f1-8afc-f4469a5f3bd5@hartkopp.net>
Date:   Tue, 2 Feb 2021 18:30:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <586c2310-17ee-328e-189c-f03aae1735e9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.02.21 16:35, David Ahern wrote:
> On 2/2/21 3:48 AM, Oliver Hartkopp wrote:
>>
>> Are you sure this patch is correctly assigned to iproute2-next?
>>
>> IMO it has to be applied to iproute2 as the functionality is already in
>> v5.11 which is in rc6 right now.
>>
> 
> new features land in iproute2-next just as they do for the kernel with
> net-next.
> 
> Patches adding support for kernel features should be sent in the same
> development window if you want the iproute2 support to match kernel version.
> 

Oh, I followed the commits from iproute2 until the new include files 
from (in this case) 5.11 pre rc1 had been updated (on 2020-12-24):

https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2953235e61eb672bbdd2de84eb5b91c388f9a9b5

I thought the uapi updates in iproute2 are *always* pulled from the 
kernel and not from iprout2-next which was new to me.

Do you expect patches for iproute2-next when the relevant changes become 
available in linux-next then?

Even though I did not know about iproute2-next the patch is needed for 
the 5.11 kernel (as written in the subject).

Regards,
Oliver

