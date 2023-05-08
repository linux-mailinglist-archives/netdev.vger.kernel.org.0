Return-Path: <netdev+bounces-851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 657016FB01F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21B34280F8B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245AE19B;
	Mon,  8 May 2023 12:35:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B77193
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:35:10 +0000 (UTC)
Received: from mail-m127104.qiye.163.com (mail-m127104.qiye.163.com [115.236.127.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C199B4C16
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:35:08 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m127104.qiye.163.com (Hmail) with ESMTPA id 1D106A40483;
	Mon,  8 May 2023 20:34:48 +0800 (CST)
Message-ID: <8c243d68-583f-aeea-3d8f-e608746dd9e7@sangfor.com.cn>
Date: Mon, 8 May 2023 20:34:43 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net v4 2/2] iavf: Fix out-of-bounds when setting channels
 on remove
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>,
 "Chittim, Madhu" <madhu.chittim@intel.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 keescook@chromium.org, grzegorzx.szczurek@intel.com,
 mateusz.palczewski@intel.com, mitch.a.williams@intel.com,
 gregory.v.rose@intel.com, jeffrey.t.kirsher@intel.com,
 michal.kubiak@intel.com, simon.horman@corigine.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
References: <20230503031541.27855-1-dinghui@sangfor.com.cn>
 <20230503031541.27855-3-dinghui@sangfor.com.cn>
 <20230503082458.GH525452@unreal>
 <d2351c0f-0bfe-9422-f6f3-f0a0db58c729@sangfor.com.cn>
 <20230503162932.GN525452@unreal>
 <941ad3cc-22d6-3459-dfbc-36bc47a8a22a@intel.com>
 <20230504075709.GS525452@unreal>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <20230504075709.GS525452@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDQ05CVk5JQh5DTEIYTBpMT1UTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a87fb5ba364b282kuuu1d106a40483
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mgw6PDo5AT0JKzYLEDUvLVYR
	DxkKFEhVSlVKTUNITk9CSEtLT09NVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFNSk1PNwY+
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/4 15:57, Leon Romanovsky wrote:
> On Wed, May 03, 2023 at 12:22:00PM -0700, Chittim, Madhu wrote:
>>
>>
>> On 5/3/2023 9:29 AM, Leon Romanovsky wrote:
>>> On Wed, May 03, 2023 at 10:00:49PM +0800, Ding Hui wrote:
>>>> On 2023/5/3 4:24 下午, Leon Romanovsky wrote:
>>>>> On Wed, May 03, 2023 at 11:15:41AM +0800, Ding Hui wrote:
>>>>
>>>>>>
>>>>>> If we detected removing is in processing, we can avoid unnecessary
>>>>>> waiting and return error faster.
>>>>>>
>>>>>> On the other hand in timeout handling, we should keep the original
>>>>>> num_active_queues and reset num_req_queues to 0.
>>>>>>
>>>>>> Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
>>>>>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>>>>>> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
>>>>>> Cc: Huang Cun <huangcun@sangfor.com.cn>
>>>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>>>> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
>>>>>> ---
>>>>>> v3 to v4:
>>>>>>      - nothing changed
>>>>>>
>>>>>> v2 to v3:
>>>>>>      - fix review tag
>>>>>>
>>>>>> v1 to v2:
>>>>>>      - add reproduction script
>>>>>>
>>>>>> ---
>>>>>>     drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
>>>>>>     1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>>>>>> index 6f171d1d85b7..d8a3c0cfedd0 100644
>>>>>> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>>>>>> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>>>>>> @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
>>>>>>     	/* wait for the reset is done */
>>>>>>     	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
>>>>>>     		msleep(IAVF_RESET_WAIT_MS);
>>>>>> +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
>>>>>> +			return -EOPNOTSUPP;
>>>>>
>>>>> This makes no sense without locking as change to __IAVF_IN_REMOVE_TASK
>>>>> can happen any time.
>>>>>
>>>>
>>>> The state doesn't need to be that precise here, it is optimized only for
>>>> the fast path. During the lifecycle of the adapter, the __IAVF_IN_REMOVE_TASK
>>>> state will only be set and not cleared.
>>>>
>>>> If we didn't detect the "removing" state, we also can fallback to timeout
>>>> handling.
>>>>
>>>> So I don't think the locking is necessary here, what do the maintainers
>>>> at Intel think?
>>>
>>> I'm not Intel maintainer, but your change, explanation and the following
>>> line from your commit message aren't really aligned.
>>>
>>> [ 3510.400799] ==================================================================
>>> [ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]
>>>
>>>
>>
>> __IAVF_IN_REMOVE_TASK is being set only in iavf_remove() and the above
>> change is ok in terms of coming out of setting channels early enough while
>> remove is in progress.
> 
> It is not, __IAVF_IN_REMOVE_TASK, set bit can be changed any time during
> iavf_set_channels() and if it is not, I would expect test_bit(..) placed
> at the beginning of iavf_set_channels() or even earlier.
> 

Since we have a little dispute on __IAVF_IN_REMOVE_TASK, I'll remove the
test_bit() in v5, and remove Reviewed-by: tags of 2/2 to review again.

-- 
Thanks,
- Ding Hui


