Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF571E73BD
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 05:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436944AbgE2DlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 23:41:04 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:55148 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436711AbgE2DlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 23:41:02 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BBC4641EAC;
        Fri, 29 May 2020 11:40:58 +0800 (CST)
Subject: Re: [PATCH net-next 0/2] net/mlx5e: add nat support in ct_metadata
To:     Edward Cree <ecree@solarflare.com>, paulb@mellanox.com,
        saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
References: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
 <c9b94b29-5a1a-8812-f9fa-b921a7a9e7c7@solarflare.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <362e8fff-3410-3a1f-d2fb-487c96a881a1@ucloud.cn>
Date:   Fri, 29 May 2020 11:40:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <c9b94b29-5a1a-8812-f9fa-b921a7a9e7c7@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEpJS0tLSk5OT09DQkpZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw*IyINLTATNTkeHUk2CTocVlZVSk1PKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mi46Pzo*Dzg3DTgXHR5MTjoO
        MUpPCVFVSlVKTkJLTElITU5DQk1KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJSUtMNwY+
X-HM-Tid: 0a725e84c4822086kuqybbc4641eac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/2020 7:35 PM, Edward Cree wrote:
> On 28/05/2020 08:15, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Currently all the conntrack entry offfload rules will be add
>> in both ct and ct_nat flow table in the mlx5e driver. It is
>> not makesense.
>>
>> This serise provide nat attribute in the ct_metadata action which
>> tell driver the rule should add to ct or ct_nat flow table 
> I don't understand why changes to the core are needed.
> A conntrack entry should be a NAT if and only if it has
>  FLOW_ACTION_MANGLE actions.  AIUI this is sufficient information
>  to distinguish NAT from non-NAT conntrack, and there's no need
>  for an additional bool in ct_metadata.
> But it's possible my understanding is wrong.

Yes, Currently the  FLOW_ACTION_MANGLE can distinguish this.

But I think the right way to get nat or non-nat conntrack  is through the

nf_conn->status ?


 
>
> -ed
>
