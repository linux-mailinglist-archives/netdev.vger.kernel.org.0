Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938BB42BED8
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 13:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhJML0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 07:26:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:39130 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhJML0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 07:26:05 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1macMU-000BvP-GT; Wed, 13 Oct 2021 13:23:54 +0200
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1macMU-000VvV-8W; Wed, 13 Oct 2021 13:23:54 +0200
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        dsahern@kernel.org, m@lambda.lt, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net> <YWW4alF5eSUS0QVK@shredder>
 <959fd23f-27ad-8b5b-930f-1eca1a9d8fcc@iogearbox.net>
 <YWauH/k8tfuLzsU5@shredder>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <62dd9515-968a-451c-2da6-da0f03082ad2@iogearbox.net>
Date:   Wed, 13 Oct 2021 13:23:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YWauH/k8tfuLzsU5@shredder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26321/Wed Oct 13 10:21:20 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 11:59 AM, Ido Schimmel wrote:
> On Wed, Oct 13, 2021 at 11:26:50AM +0200, Daniel Borkmann wrote:
>> On 10/12/21 6:31 PM, Ido Schimmel wrote:
>>> In our HW the nexthop table is squashed together with the neighbour
>>> table, so that it provides {netdev, MAC} and not {netdev, IP} with which
>>> the kernel performs another lookup in its neighbour table. We want to
>>> avoid situations where we perform multipathing between valid and failed
>>> nexthop (basically, fib_multipath_use_neigh=1), so we only program valid
>>> nexthop. But it means that nothing will trigger the resolution of the
>>> failed nexthops, thus the need to probe the neighbours.
>>
>> Makes sense. Given you have the setup/HW, if you have a chance to consolidate
>> the mlxsw logic with the new NTF_MANAGED entries, that would be awesome!
> 
> Yes, I will take care of that

Perfect, thanks a lot!
