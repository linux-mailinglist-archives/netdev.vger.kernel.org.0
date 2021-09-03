Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77EA3FF8DB
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 04:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345222AbhICCcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 22:32:04 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:60953 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239772AbhICCcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 22:32:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Un3RzkZ_1630636261;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Un3RzkZ_1630636261)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 10:31:02 +0800
Subject: Re: [PATCH] Revert "net: fix NULL pointer reference in
 cipso_v4_doi_free"
To:     Paul Moore <paul@paul-moore.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
 <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com>
 <7f239a0e-7a09-3dc0-43ce-27c19c7a309d@linux.alibaba.com>
 <4c000115-4069-5277-ce82-946f2fdb790a@linux.alibaba.com>
 <CAHC9VhRBhCfX45V701rbGsvmOPQ4Nyp7dX2GA6NL8FxnA9akXg@mail.gmail.com>
 <a53753dc-0cce-4f9a-cb97-fc790d30a234@linux.alibaba.com>
 <CAHC9VhR2c=HYdWmz-At0+7RexUBjQHktv3ypHmFU2jD5gDc2Cw@mail.gmail.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <a732f080-1d72-d1ee-4eea-5266b5ad1447@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 10:31:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhR2c=HYdWmz-At0+7RexUBjQHktv3ypHmFU2jD5gDc2Cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/3 上午10:15, Paul Moore wrote:
[snip]
>> both v1 and v2 are there with the same description and both code modification
>> are applied.
>>
>> We want revert v1 but not in a revert patch style, then do you suggest
>> send a normal patch to do the code revert?
> 
> It sounds like DaveM wants you to create a normal (not a revert) patch
> that removes the v1 changes while leaving the v2 changes intact.  In
> the patch description you can mention that v1 was merged as a mistake
> and that v2 is the correct fix (provide commit IDs for each in your
> commit description using the usual 12-char hash snippet followed by
> the subject in parens-and-quotes).

Thanks for the kindly explain, I've sent:
  [PATCH] net: remove the unnecessary check in cipso_v4_doi_free

Which actually revert the v1 and mentioned v2 fixed the root casue,
Would you please take a look see if that is helpful?

Regards,
Michael Wang

> 
