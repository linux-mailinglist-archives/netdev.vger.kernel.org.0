Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877A61AD556
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 06:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgDQEhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 00:37:14 -0400
Received: from m12-15.163.com ([220.181.12.15]:50219 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 00:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=aWKfV
        BxNwZSmPg7YqfkeHzmbJCUlgrXNh/oAP9D/I/s=; b=NQcq+5+3+tiRx5J0/aswM
        dzmX0qrg+ecHvj8dYTEY2jLQ0xzJlpeqQH/srKerx01yTVPHALz1oUEDXb0eQI+v
        m6KD2aYwpEgZENx+KXg8JW8iJEkzaRj2LSOkrXEhSxiXDTyeEwAYK8fW+OWjTXQS
        VWdp4gCjMwyrPVB1joAlr4=
Received: from [192.168.0.6] (unknown [125.82.15.62])
        by smtp11 (Coremail) with SMTP id D8CowACXnBjwMZlexhfjDg--.23S2;
        Fri, 17 Apr 2020 12:35:02 +0800 (CST)
Subject: Re: [PATCH v2] net/mlx5: add the missing space character
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Cc:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "lsahlber@redhat.com" <lsahlber@redhat.com>,
        "kw@linux.com" <kw@linux.com>,
        "xiubli@redhat.com" <xiubli@redhat.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wqu@suse.com" <wqu@suse.com>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "stfrench@microsoft.com" <stfrench@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200403042659.9167-1-xianfengting221@163.com>
 <14df0ecf093bb2df4efaf9e6f5220ea2bf863f53.camel@mellanox.com>
 <fae7a094-62e8-d797-a89b-23faf0eb374e@163.com>
 <a77ddcfad6bfd68b9d69e0d5a18cf5d66692d270.camel@mellanox.com>
From:   Hu Haowen <xianfengting221@163.com>
Message-ID: <4861c789-a333-efea-6d51-ab5511645dcf@163.com>
Date:   Fri, 17 Apr 2020 12:34:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a77ddcfad6bfd68b9d69e0d5a18cf5d66692d270.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: D8CowACXnBjwMZlexhfjDg--.23S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF4DAFyfGr18WrykWFW7urg_yoW8WF1kpF
        98J3Z8Cr48Jrn7Aa1vy3WjqayFyws3Jry5Xrn8Wr95KwnFqr1ftr48K3yYkF9I9rn5G390
        vF4jq3sFgayrJaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bzNtxUUUUU=
X-Originating-IP: [125.82.15.62]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbi6xgJAFXlqaPofQAAsV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/17 11:44 AM, Saeed Mahameed wrote:
> On Thu, 2020-04-16 at 22:44 +0800, Hu Haowen wrote:
>> On 2020/4/9 3:42 AM, Saeed Mahameed wrote:
>>> On Fri, 2020-04-03 at 12:26 +0800, Hu Haowen wrote:
>>>> Commit 91b56d8462a9 ("net/mlx5: improve some comments") did not
>>>> add
>>>> that missing space character and this commit is used to fix it
>>>> up.
>>>>
>>>> Fixes: 91b56d8462a9 ("net/mlx5: improve some comments")
>>>>
>>> Please re-spin and submit to net-next once net-next re-opens,
>>> avoid referencing the above commit since this patch is a stand
>>> alone
>>> and has nothing to do with that patch.. just have a stand alone
>>> commit
>>> message explaining the space fix.
>> Sorry for my late reply. Because I'm a kernel newbie, I know nothing
>> about the basic methods and manners in the kernel development. Thanks
>> a lot for your patience on my mistake, pointing it out and fixing it
>> up.
>>
>> Btw, did net-next re-open and did my changes get into the mainline?
>>
>>
> Normally net-next closes once merge window is open at the end of
> rc7/rc8 kernel cycle.
>
> and reopens on the week of the kernel release, after the merge window
> is closed (2 weeks after rc7/8 is closed).
>
> you can use this link.
> http://vger.kernel.org/~davem/net-next.html


Oh... Thanks.

But it's more than 2 weeks since Linux 5.6 was released, so net-next
should be open now according to your words. But it's still closed.

Is my idea wrong? Does "kernel release" mean an -rc release or a formal
release?


>
> Or just monitor netdev mailing list for an email announcement from
> David Miller.
>
> Thanks and welcome to the netdev family.
>
>
>   
>

