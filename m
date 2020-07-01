Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AB12105FF
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 10:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgGAIR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 04:17:56 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:9084 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbgGAIR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 04:17:56 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id AC36C41EBE;
        Wed,  1 Jul 2020 16:17:51 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
From:   wenxu <wenxu@ucloud.cn>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
 <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
 <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
 <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn>
Message-ID: <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
Date:   Wed, 1 Jul 2020 16:17:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0tPS0tLS01MTEpLQ0NZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw5FQ8DHg0pDQMeCR1QTTocVlZVTkNOKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mz46PBw6Gjg0NyxPVhcXNhQy
        NxEwCgFVSlVKTkJITkJKT0xJS0lMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJTUxJNwY+
X-HM-Tid: 0a7309741eb32086kuqyac36c41ebe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/1/2020 2:21 PM, wenxu wrote:
> On 7/1/2020 2:12 PM, Cong Wang wrote:
>> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
>>> Only forward packet case need do fragment again and there is no need do defrag explicit.
>> Same question: why act_mirred? You have to explain why act_mirred
>> has the responsibility to do this job.
> The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
>
> the act_mirred can decides whether do the fragment or not.

Hi cong,


I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"

Did you have some other suggestion to solve this problem?


BR

wenxu

>
