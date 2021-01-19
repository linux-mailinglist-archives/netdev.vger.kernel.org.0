Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD2C2FAEC1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 03:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436795AbhASC0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 21:26:51 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:44175 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436741AbhASC0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 21:26:49 -0500
Received: from [192.168.188.110] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 776E25C1CC1;
        Tue, 19 Jan 2021 10:25:55 +0800 (CST)
Subject: Re: [PATCH net-next] net/sched: cls_flower add CT_FLAGS_INVALID flag
 support
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
References: <1610947127-4412-1-git-send-email-wenxu@ucloud.cn>
 <20210118182112.GC2676@horizon.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <677113f7-2dd5-393a-c160-ccffc94c08c0@ucloud.cn>
Date:   Tue, 19 Jan 2021 10:25:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210118182112.GC2676@horizon.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZH0MZQktNGEpIGBpOVkpNSkpLSUhKTk1LSUNVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0xKTVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oi46NRw5LD06IhQ#ExRWESMd
        NzAaFBZVSlVKTUpKS0lISk5NSUtOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJSkhPNwY+
X-HM-Tid: 0a771876824e2087kuqy776e25c1cc1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/19/2021 2:21 AM, Marcelo Ricardo Leitner wrote:
> On Mon, Jan 18, 2021 at 01:18:47PM +0800, wenxu@ucloud.cn wrote:
> ...
>> --- a/net/sched/cls_flower.c
>> +++ b/net/sched/cls_flower.c
>> @@ -305,6 +305,9 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>>  	struct fl_flow_key skb_key;
>>  	struct fl_flow_mask *mask;
>>  	struct cls_fl_filter *f;
>> +	bool post_ct;
>> +
>> +	post_ct = qdisc_skb_cb(skb)->post_ct;
> Patch-wise, only here I think you could initialize post_ct right on
> the declaration. No need for the extra line/block of lines here.
>
> But I'm missing the iproute2 changes for flower, with a man page
> update as well. Not sure if you planned to post them later on or not,
> but it's nice to always have them paired together.
Will do . Thanks.
>
> Thanks,
> Marcelo
>
