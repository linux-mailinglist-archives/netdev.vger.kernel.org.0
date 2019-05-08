Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB58616F43
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 04:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfEHCzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 22:55:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfEHCzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 22:55:01 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A05F3DDBE;
        Wed,  8 May 2019 02:55:01 +0000 (UTC)
Received: from [10.72.12.176] (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BF6360123;
        Wed,  8 May 2019 02:54:56 +0000 (UTC)
Subject: Re: [PATCH net] tuntap: synchronize through tfiles array instead of
 tun->numqueues
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     mst@redhat.com, YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>
References: <1557199416-55253-1-git-send-email-jasowang@redhat.com>
 <7b9744b4-42ec-7d0a-20ff-d65f71b16c63@gmail.com>
 <6f880c3e-ebb6-a683-6c75-c94409a60741@redhat.com>
 <98fb0760-a772-ca1c-d97b-d8b70066c9aa@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <17394b97-15f0-ffbf-3d5d-6480ea60b86a@redhat.com>
Date:   Wed, 8 May 2019 10:54:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <98fb0760-a772-ca1c-d97b-d8b70066c9aa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 08 May 2019 02:55:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/7 下午10:47, Eric Dumazet wrote:
>
> On 5/6/19 11:54 PM, Jason Wang wrote:
>> On 2019/5/7 上午11:41, Eric Dumazet wrote:
>>>>    
>>> If you remove the test on (!numqueues),
>>> the following might crash with a divide by zero...
>>
>> Indeed, let me post V2.
> You probably want to fix tun_ebpf_select_queue() as well.
>

Yes, will fix this in V3.

Thanks

