Return-Path: <netdev+bounces-170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8016F5974
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06B862815FF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC5910785;
	Wed,  3 May 2023 14:01:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC884A11
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 14:01:03 +0000 (UTC)
Received: from mail-m11876.qiye.163.com (mail-m11876.qiye.163.com [115.236.118.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5555C5597;
	Wed,  3 May 2023 07:00:59 -0700 (PDT)
Received: from [IPV6:240e:3b7:327f:5c30:3c7d:9d61:755a:9449] (unknown [IPV6:240e:3b7:327f:5c30:3c7d:9d61:755a:9449])
	by mail-m11876.qiye.163.com (Hmail) with ESMTPA id DD8973C0341;
	Wed,  3 May 2023 22:00:49 +0800 (CST)
Message-ID: <d2351c0f-0bfe-9422-f6f3-f0a0db58c729@sangfor.com.cn>
Date: Wed, 3 May 2023 22:00:49 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
From: Ding Hui <dinghui@sangfor.com.cn>
Subject: Re: [PATCH net v4 2/2] iavf: Fix out-of-bounds when setting channels
 on remove
To: Leon Romanovsky <leon@kernel.org>
Cc: dinghui@sangfor.com.cn, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 keescook@chromium.org, grzegorzx.szczurek@intel.com,
 mateusz.palczewski@intel.com, mitch.a.williams@intel.com,
 gregory.v.rose@intel.com, jeffrey.t.kirsher@intel.com,
 michal.kubiak@intel.com, simon.horman@corigine.com, madhu.chittim@intel.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org, pengdonglin@sangfor.com.cn,
 huangcun@sangfor.com.cn
References: <20230503031541.27855-1-dinghui@sangfor.com.cn>
 <20230503031541.27855-3-dinghui@sangfor.com.cn>
 <20230503082458.GH525452@unreal>
Content-Language: en-US
In-Reply-To: <20230503082458.GH525452@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZH0MeVksZS05LGh0eHUpLSlUTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTB1BThhIS0FIGEwfQUIfTUpBTE5OGkFCT09CWVdZFhoPEhUdFF
	lBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a87e1ea708f2eb2kusndd8973c0341
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ORg6Qzo4Lj0TIzkvPjdCTR0Q
	Cx4aCwpVSlVKTUNISklJT05LQkxIVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUwdQU4YSEtBSBhMH0FCH01KQUxOThpBQk9PQllXWQgBWUFPQ09NNwY+
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/3 4:24 下午, Leon Romanovsky wrote:
> On Wed, May 03, 2023 at 11:15:41AM +0800, Ding Hui wrote:

>>
>> If we detected removing is in processing, we can avoid unnecessary
>> waiting and return error faster.
>>
>> On the other hand in timeout handling, we should keep the original
>> num_active_queues and reset num_req_queues to 0.
>>
>> Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
>> Cc: Huang Cun <huangcun@sangfor.com.cn>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
>> ---
>> v3 to v4:
>>    - nothing changed
>>
>> v2 to v3:
>>    - fix review tag
>>
>> v1 to v2:
>>    - add reproduction script
>>
>> ---
>>   drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>> index 6f171d1d85b7..d8a3c0cfedd0 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>> @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
>>   	/* wait for the reset is done */
>>   	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
>>   		msleep(IAVF_RESET_WAIT_MS);
>> +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
>> +			return -EOPNOTSUPP;
> 
> This makes no sense without locking as change to __IAVF_IN_REMOVE_TASK
> can happen any time.
> 

The state doesn't need to be that precise here, it is optimized only for
the fast path. During the lifecycle of the adapter, the __IAVF_IN_REMOVE_TASK
state will only be set and not cleared.

If we didn't detect the "removing" state, we also can fallback to timeout
handling.

So I don't think the locking is necessary here, what do the maintainers
at Intel think?

> Thanks
> 
>>   		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
>>   			continue;
>>   		break;
>>   	}
>>   	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
>>   		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
>> -		adapter->num_active_queues = num_req;
>> +		adapter->num_req_queues = 0;
>>   		return -EOPNOTSUPP;
>>   	}
>>   
>> -- 
>> 2.17.1
>>
>>
> 

-- 
Thanks,
-dinghui


