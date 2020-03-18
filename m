Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0D4189578
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 06:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgCRFtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 01:49:24 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:48855 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCRFtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 01:49:24 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 734B541ADE;
        Wed, 18 Mar 2020 13:49:17 +0800 (CST)
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
 <02ad5abe-8a1c-8e39-3c8e-e78c3186ef79@ucloud.cn>
 <94f07fd5a39e22ced54162d77b1089f46544030d.camel@mellanox.com>
 <bbfe6e031a0b70c5143f759469154a0714af0dd5.camel@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d88202e9-830e-47c2-e960-9e2d311b0ee5@ucloud.cn>
Date:   Wed, 18 Mar 2020 13:49:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bbfe6e031a0b70c5143f759469154a0714af0dd5.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENNS0tLS0hMSkJISFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kwg6NTo*ETg*Sx1IDhAdLBcT
        SRIwChRVSlVKTkNPTkpLTk5DQkpPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0xLTjcG
X-HM-Tid: 0a70ec305da52086kuqy734b541ade
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/18/2020 12:05 PM, Saeed Mahameed wrote:
> On Tue, 2020-03-17 at 20:58 -0700, Saeed Mahameed wrote:
>> On Mon, 2020-03-16 at 11:14 +0800, wenxu wrote:
>>> On 12/18/2019 3:54 AM, Saeed Mahameed wrote:
>>>> On Wed, 2019-12-11 at 10:41 +0800, wenxu wrote:
>>>>> On 12/10/2019 7:44 PM, Paul Blakey wrote:
>>>>>> On 12/10/2019 12:08 PM, wenxu@ucloud.cn wrote:
>>>>>>> From: wenxu <wenxu@ucloud.cn>
>>>>>>>
>>>>>>> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
>>>>>>> in FT mode.
>>>>>>>
>>>>>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>>>>>> ---
>>>> [...]
>>>>
>>>>>> +cc Saeed
>>>>>>
>>>>>>
>>>>>> This looks good to me, but it should be on top of a patch
>>>>>> that
>>>>>> will 
>>>>>> actual allows the indirect BIND if the nft
>>>>>>
>>>>>> table device is a tunnel device. Is that upstream? If so
>>>>>> which
>>>>>> patch?
>>>>>>
>>>>>>
>>>>>> Currently (5.5.0-rc1+), nft_register_flowtable_net_hooks
>>>>>> calls 
>>>>>> nf_flow_table_offload_setup which will see
>>>>>>
>>>>>> that the tunnel device doesn't have ndo_setup_tc and return 
>>>>>> -EOPNOTSUPPORTED.
>>>>> The related patch  http://patchwork.ozlabs.org/patch/1206935/
>>>>>
>>>>> is waiting for upstream
>>>>>
>>>> The netfilter patch is still under-review, once accepted i will
>>>> apply
>>>> this series.
>>>>
>>>> Thanks,
>>>> Saeed.
>>>>
>>> Hi Saeed,
>>>
>>>
>>> Sorry for so long time to update. The netfilter patch is already
>>> accepted.  This series is also
>>>
>>> not out of date and can apply to net-next.  If you feel ok  please
>>> apply it thanks.
>>>
>>>
>>> The netfilter patch:
>>>
>>> http://patchwork.ozlabs.org/patch/1242815/
>>>
>>> BR
>>>
>>> wenxu
>>>
>> Applied to net-next-mlx5,  doing some build testing now, and will
>> make
>> this run in regression for a couple of days until my next pull
>> request
>> to net-next.
>>
> hmmm, i was too optimistic, patches got blocked by CI, apparently some
> changes in mlx5 eswitch API are causing the following failure, most
> likely due to the introduction of eswitch_chains API.
>
> 05:57:47 make -s -j 96 CC=/usr/llvm/bin/clang
> drivers/net/ethernet/mellanox/mlx5/core/
> 05:58:14 error: drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:752:8:
> error: implicit declaration of function 'mlx5_eswitch_prios_supported'
> [-Werror,-Wimplicit-function-declaration]
> 05:58:14 error: drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:752:8:
> note: did you mean 'mlx5_esw_chains_prios_supported'?
> 05:58:14 
>
>
> Please rebase and re-test, I can help you with more details if you
> need.
Will do.
> Thanks,
> Saeed.
>
>> Thanks,
>> saeed.
