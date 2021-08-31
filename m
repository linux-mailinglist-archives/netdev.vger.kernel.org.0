Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4DE3FC0E1
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 04:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbhHaCm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 22:42:56 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:52325 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236452AbhHaCmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 22:42:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Umi-x8D_1630377711;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Umi-x8D_1630377711)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 31 Aug 2021 10:41:52 +0800
Subject: Re: [PATCH v2] net: fix NULL pointer reference in cipso_v4_doi_free
To:     Paul Moore <paul@paul-moore.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
 <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com>
 <CAHC9VhTEs9E+ZeGGp96NnOhmr-6MZLXf6ckHeG8w5jh3AfgKiQ@mail.gmail.com>
 <20210830094525.3c97e460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHC9VhRHx=+Fek7W4oyZWVBUENQ8VnD+mWXUytKPKg+9p-J4LQ@mail.gmail.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <84262e7b-fda6-9d7d-b0bd-1bb0e945e6f9@linux.alibaba.com>
Date:   Tue, 31 Aug 2021 10:41:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRHx=+Fek7W4oyZWVBUENQ8VnD+mWXUytKPKg+9p-J4LQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/31 上午12:50, Paul Moore wrote:
[SNIP]
>>>> Reported-by: Abaci <abaci@linux.alibaba.com>
>>>> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
>>>> ---
>>>>  net/netlabel/netlabel_cipso_v4.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> I see this was already merged, but it looks good to me, thanks for
>>> making those changes.
>>
>> FWIW it looks like v1 was also merged:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=733c99ee8b
> 
> Yeah, that is unfortunate, there was a brief discussion about that
> over on one of the -stable patches for the v1 patch (odd that I never
> saw a patchbot post for the v1 patch?).  Having both merged should be
> harmless, but we want to revert the v1 patch as soon as we can.
> Michael, can you take care of this?

As v1 already merged, may be we could just goon with it?

Actually both working to fix the problem, v1 will cover all the
cases, v2 take care one case since that's currently the only one,
but maybe there will be more in future.

Regards,
Michael Wang

> 
