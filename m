Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452A0189811
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCRJld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:41:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:49836 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgCRJld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:41:33 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEVCd-0002xu-Dx; Wed, 18 Mar 2020 10:41:31 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEVCd-000G0w-6m; Wed, 18 Mar 2020 10:41:31 +0100
Subject: Re: [PATCH net-next] netfilter: revert introduction of egress hook
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
References: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
 <20200318093649.sn3hsi7nkd3j34lj@salvia>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <97a81974-5063-ed3d-8ad4-9f7ff3aa0908@iogearbox.net>
Date:   Wed, 18 Mar 2020 10:41:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200318093649.sn3hsi7nkd3j34lj@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/20 10:36 AM, Pablo Neira Ayuso wrote:
> On Wed, Mar 18, 2020 at 10:33:22AM +0100, Daniel Borkmann wrote:
>> This reverts the following commits:
>>
>>    8537f78647c0 ("netfilter: Introduce egress hook")
>>    5418d3881e1f ("netfilter: Generalize ingress hook")
>>    b030f194aed2 ("netfilter: Rename ingress hook include file")
>>
>>  From the discussion in [0], the author's main motivation to add a hook
>> in fast path is for an out of tree kernel module, which is a red flag
>> to begin with. Other mentioned potential use cases like NAT{64,46}
>> is on future extensions w/o concrete code in the tree yet. Revert as
>> suggested [1] given the weak justification to add more hooks to critical
>> fast-path.
>>
>>    [0] https://lore.kernel.org/netdev/cover.1583927267.git.lukas@wunner.de/
>>    [1] https://lore.kernel.org/netdev/20200318.011152.72770718915606186.davem@davemloft.net/
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> Nacked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Daniel, you must be really worried about achieving your goals if you
> have to do politics to block stuff.

Looks like this is your only rationale technical argument you can come
up with?

Thanks,
Daniel
