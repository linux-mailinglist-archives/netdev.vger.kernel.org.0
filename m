Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BC0399DAC
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFCJZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:25:10 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:59100 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhFCJZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:25:10 -0400
Received: from [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504] (p200300e9d72228a192405b8af0370504.dip0.t-ipconnect.de [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0C15EC0542;
        Thu,  3 Jun 2021 11:23:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1622712204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WX/4tdZvwC4/e0ryKleeaQPK16tDTBOC8u4sk29eW14=;
        b=RqruZ5FZPyZ9S6EIRMhek86GCuDx5h3tJyeXMJp3HuVjOonu8ym4dMf+hT4NRA0d/yQqy1
        QSDLCkSZyRSlT4yWYag9YNbUBZIJ7PhqUUGFYYtqUvxUaLR8OETsIL68pXvwVzfM87Q7uG
        O8sdBZSNZmSfUQk0eOgUZWAVJahS8OmwB+oKRZNsYTVjop5DlG5dMz/svurNvqTXnGlv7Z
        hUodAqHsCzBLvp9MMZZ3BWcuxiJV7Vz0WtKGO5J0ZwqphXOXUEUnqJaUGnIIyo6tWdQXzN
        lPuNjx71Yc1zGRKzdoAbTFHXLAH/PlWWN38jlfat8FkeovW6/BlgnRfHTFQvhg==
Subject: Re: [PATCH v1 1/1] mrf29j40: Drop unneeded of_match_ptr()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wpan@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Ott <alan@signal11.us>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210531132226.47081-1-andriy.shevchenko@linux.intel.com>
 <5dd2a42d-b218-0b23-aa14-7e5681e0fb3a@datenfreihafen.org>
 <CAHp75VdcFut0Tks3O=HJPLncebgDdfEv7Robm9ujG6yL+PT3OQ@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <bc7ad567-5dd4-3176-2b71-5dd36cc03875@datenfreihafen.org>
Date:   Thu, 3 Jun 2021 11:23:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAHp75VdcFut0Tks3O=HJPLncebgDdfEv7Robm9ujG6yL+PT3OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 03.06.21 11:19, Andy Shevchenko wrote:
> On Thu, Jun 3, 2021 at 11:35 AM Stefan Schmidt
> <stefan@datenfreihafen.org> wrote:
>> On 31.05.21 15:22, Andy Shevchenko wrote:
>>> Driver can be used in different environments and moreover, when compiled
>>> with !OF, the compiler may issue a warning due to unused mrf24j40_of_match
>>> variable. Hence drop unneeded of_match_ptr() call.
>>>
>>> While at it, update headers block to reflect above changes.
> 
> ...
> 
>> I took the freedom to fix the typo in the subject line and add a better
>> prefix:
>>
>> net: ieee802154: mrf24j40: Drop unneeded of_match_ptr()
> 
> Right, thanks!
> 
>> This patch has been applied to the wpan tree and will be
>> part of the next pull request to net. Thanks!
> 
> Btw, which tree are you using for wpan development? I see one with 6
> weeks old commits, is that the correct one?

I assume you mean this one:
https://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git/

Its the correct one. I was a bit busy lately, but luckily ieee802154 
patches again net apply fine most of the time as well.

I collected the piled up patches right now and will send a pull request 
after some testing later today. Once that is merged I will update my 
tree as well.

regards
Stefan Schmidt
