Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC6C21658C
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgGGEt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:49:58 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:64425 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgGGEt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 00:49:58 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 443B74163F;
        Tue,  7 Jul 2020 12:47:16 +0800 (CST)
Subject: Re: [PATCH net-next 1/3] netfilter: nf_defrag_ipv4: Add
 nf_ct_frag_gather support
To:     Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
 <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
 <20200706143826.GA32005@breakpoint.cc>
 <06700aee-f62f-7b83-de21-4f5b4928978e@ucloud.cn>
 <20200706162915.GB32005@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <fe7fff2e-ab29-d3c3-e2c5-93f64d0fac0b@ucloud.cn>
Date:   Tue, 7 Jul 2020 12:47:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706162915.GB32005@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEhLS0tLSk1JSklPTUhZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw6Mwk2IS4kHDUdLUMvKjocVlZVSUJNKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODo6SSo*GD5NGk03QyJCKxIw
        ChkKCShVSlVKTkJPS0JMSUhNTk9CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJSUxONwY+
X-HM-Tid: 0a73279979f42086kuqy443b74163f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/7/2020 12:29 AM, Florian Westphal wrote:
> wenxu <wenxu@ucloud.cn> wrote:
>> 在 2020/7/6 22:38, Florian Westphal 写道:
>>> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>>>> From: wenxu <wenxu@ucloud.cn>
>>>>
>>>> Add nf_ct_frag_gather for conntrack defrag and it will
>>>> elide the CB clear when packets are defragmented by
>>>> connection tracking
>>> Why is this patch required?
>>> Can't you rework ip_defrag to avoid the cb clear if you need that?
>> The ip_defrag used by ip stack and can work with the cb setting.
> Yes, but does it have to?
>
> If yes, why does nf_ct_frag not need it whereas ip_defrag has to?
>
>
Yes, rework with ip_defrag is much better. Thanks.
