Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A31186394
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 04:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgCPDOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 23:14:16 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:16761 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729655AbgCPDOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 23:14:16 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A244541AE0;
        Mon, 16 Mar 2020 11:14:07 +0800 (CST)
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
 <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
 <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
 <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
 <62c3d7ec655b0209d2f5d573070e484ac561033c.camel@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <02ad5abe-8a1c-8e39-3c8e-e78c3186ef79@ucloud.cn>
Date:   Mon, 16 Mar 2020 11:14:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <62c3d7ec655b0209d2f5d573070e484ac561033c.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkpNS0tLT0pIQ0JPTU5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OEk6Aww*ATgxGh0sDDwPPDwS
        FzkwCxBVSlVKTkNPSElDT05JSklLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSEtJTDcG
X-HM-Tid: 0a70e15597d82086kuqya244541ae0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/18/2019 3:54 AM, Saeed Mahameed wrote:
> On Wed, 2019-12-11 at 10:41 +0800, wenxu wrote:
>> On 12/10/2019 7:44 PM, Paul Blakey wrote:
>>> On 12/10/2019 12:08 PM, wenxu@ucloud.cn wrote:
>>>> From: wenxu <wenxu@ucloud.cn>
>>>>
>>>> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
>>>> in FT mode.
>>>>
>>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>>> ---
> [...]
>
>>> +cc Saeed
>>>
>>>
>>> This looks good to me, but it should be on top of a patch that
>>> will 
>>> actual allows the indirect BIND if the nft
>>>
>>> table device is a tunnel device. Is that upstream? If so which
>>> patch?
>>>
>>>
>>> Currently (5.5.0-rc1+), nft_register_flowtable_net_hooks calls 
>>> nf_flow_table_offload_setup which will see
>>>
>>> that the tunnel device doesn't have ndo_setup_tc and return 
>>> -EOPNOTSUPPORTED.
>> The related patch  http://patchwork.ozlabs.org/patch/1206935/
>>
>> is waiting for upstream
>>
> The netfilter patch is still under-review, once accepted i will apply
> this series.
>
> Thanks,
> Saeed.
>
Hi Saeed,


Sorry for so long time to update. The netfilter patch is already accepted.  This series is also

not out of date and can apply to net-next.  If you feel ok  please apply it thanks.


The netfilter patch:

http://patchwork.ozlabs.org/patch/1242815/

BR

wenxu

