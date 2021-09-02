Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390323FE7E4
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 05:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhIBDFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 23:05:09 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:44893 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231680AbhIBDFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 23:05:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UmymB6c_1630551847;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UmymB6c_1630551847)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Sep 2021 11:04:08 +0800
Subject: Re: [PATCH v2] net: fix NULL pointer reference in cipso_v4_doi_free
To:     David Miller <davem@davemloft.net>
Cc:     paul@paul-moore.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1ed31e79-809b-7ac9-2760-869570ac22ea@linux.alibaba.com>
 <20210901.103033.925382819044968737.davem@davemloft.net>
 <6ca4a2d5-9a9c-1b14-85b4-1f4a0f743104@linux.alibaba.com>
 <20210901.114500.1826347270421267882.davem@davemloft.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <7d43588d-1941-6887-46f7-1d76db64e568@linux.alibaba.com>
Date:   Thu, 2 Sep 2021 11:04:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901.114500.1826347270421267882.davem@davemloft.net>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/1 下午6:45, David Miller wrote:
[snip]
>>>>>
>>>>> It isn't your fault that both v1 and v2 were merged, but I'm asking
>>>>> you to help cleanup the mess.  If you aren't able to do that please
>>>>> let us know so that others can fix this properly.
>>>>
>>>> No problem I can help on that, just try to make sure it's not a
>>>> meaningless work.
>>>>
>>>> So would it be fine to send out a v3 which revert v1 and apply v2?
>>>
>>> Please don't do things this way just send the relative change.
>>
>> Could you please check the patch:
>>
>> Revert "net: fix NULL pointer reference in cipso_v4_doi_free"
>>
>> see if that's the right way?
> 
> It is not. Please just send a patch against the net GIT tree which relatively changes the code to match v2 of your change.

Sorry for my horrible reading comprehension... I checked netdev/net.git master branch
and saw v2's change already applied, thus I've no idea how to change it again but pretty
sure I still misunderstanding the suggestion, could please kindly provide more details?

Regards,
Michael Wang

> 
> Thank you.
> 
