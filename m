Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C013AC815
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhFRJ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:56:43 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:50138 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhFRJ4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:56:42 -0400
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@kot-begemot.co.uk>)
        id 1luBCq-0006om-MS; Fri, 18 Jun 2021 09:54:32 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@kot-begemot.co.uk>)
        id 1luBCo-0004tf-Dq; Fri, 18 Jun 2021 10:54:32 +0100
Subject: Re: NULL pointer dereference in libbpf
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
References: <6f6476fb-4b02-e543-6dad-aca3f9b5881c@kot-begemot.co.uk>
 <87a6nnv82d.fsf@toke.dk>
From:   Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Message-ID: <ca30a5d9-3ea7-ca1a-3cb6-bc01fbdb4805@kot-begemot.co.uk>
Date:   Fri, 18 Jun 2021 10:54:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87a6nnv82d.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/06/2021 10:24, Toke Høiland-Jørgensen wrote:
> Anton Ivanov <anton.ivanov@kot-begemot.co.uk> writes:
> 
>> https://elixir.bootlin.com/linux/latest/source/tools/lib/bpf/bpf.c#L91
>>
>> A string is copied to a pointer destination which has been memset to
>> zero a few lines above.
> 
> No, it isn't. attr.map_name is an array...

Apologies, looking at the wrong struct definition (bpf_create_map_attr instead of bpf_attr).

Best Regards,

> 
> -Toke
> 
> 

-- 
Anton R. Ivanov
https://www.kot-begemot.co.uk/
