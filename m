Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DC52DDB2E
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbgLQWEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:04:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732098AbgLQWEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 17:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608242597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C0sgbGiFG7XgKZ99IeYyXSL6vj+ZYcARGRfsHU94m7Y=;
        b=iUy0bB4PWHrQ6Kkw0T8REU/Fb1UmX+d+ZyYLqH7NMddoZ5xN/qG1ootpeHAAN5yIghH7r4
        FCQVLdacnAJQUeKkDvoGWa0ibMoWuAvqAXmRZ4QqLde6oIanLhA4tfscAg2G+vu7Cup4Zr
        U8zxhuBnPfTIPGHm1o/HT+6MVIr3P88=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-VaTvwygNNbeC85nzARuubQ-1; Thu, 17 Dec 2020 17:03:10 -0500
X-MC-Unique: VaTvwygNNbeC85nzARuubQ-1
Received: by mail-qk1-f200.google.com with SMTP id g4so174390qko.23
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 14:03:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=C0sgbGiFG7XgKZ99IeYyXSL6vj+ZYcARGRfsHU94m7Y=;
        b=umBUhMXWAYpn1Rn2UJUlA6gjurC2D4gqUiRMiQ+RwHeKrFNSpvoeAkRvfmZK9yE8AS
         owZPnfQi+9UNYAA/IjU9sWTcEN17LEYCPj/5gFMfJMZysldmipxcc3nIv9vdgkl4TRTK
         MfTqbLDNhsKkgXme641FLyXgcBcuSIr230DK5ZQTiWD9e7/lyH2uNe5ZAoVl6i59tKX3
         L6+Slr2TISsE8Foq4a2GtvadaFMA3rr1/BkbiJ/08kMGNzwmFoK3gkh39YkBIeohXDiu
         92jVb2yT9Xzy22Mc3bMLQFF0uE+HslcHQNYtdmPrLEO8hKjTLU7qzdwTLp8OO/6ONJ/G
         WTOg==
X-Gm-Message-State: AOAM530N14CdxsxVsrL45u+qgaLp207vNrSlfAZn48Y61dH0AA5fCkF/
        si83c8PjvfjEE/pIGpFlOlHOQ8kqxAN9G4k9l+VANal1bnD7q+9k2UOakPSCyat87+fOwLgc/hP
        Jf+nrKxPNekAbXNIQ
X-Received: by 2002:a37:a1d6:: with SMTP id k205mr1573187qke.384.1608242589710;
        Thu, 17 Dec 2020 14:03:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmkx2if7Kw2NwuxIsapTJwjnUAUWq9916p4JEscDmDC0JfDUcetA9R7rcyXDUDXWXhtiYy9g==
X-Received: by 2002:a37:a1d6:: with SMTP id k205mr1573171qke.384.1608242589530;
        Thu, 17 Dec 2020 14:03:09 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id x134sm2488905qka.1.2020.12.17.14.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 14:03:08 -0800 (PST)
Subject: Re: [PATCH] atm: ambassador: remove h from printk format specifier
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201215142228.1847161-1-trix@redhat.com>
 <20201216164510.770454d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6ada03ed-1ecb-493b-96f8-5f9548a46a5e@redhat.com>
 <20201217092816.7b739b8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <ae7d363b-99ec-d75f-bae3-add3ee4789bd@redhat.com>
Date:   Thu, 17 Dec 2020 14:03:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201217092816.7b739b8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/17/20 9:28 AM, Jakub Kicinski wrote:
> On Thu, 17 Dec 2020 05:17:24 -0800 Tom Rix wrote:
>> On 12/16/20 4:45 PM, Jakub Kicinski wrote:
>>> On Tue, 15 Dec 2020 06:22:28 -0800 trix@redhat.com wrote:  
>>>> From: Tom Rix <trix@redhat.com>
>>>>
>>>> See Documentation/core-api/printk-formats.rst.
>>>> h should no longer be used in the format specifier for printk.
>>>>
>>>> Signed-off-by: Tom Rix <trix@redhat.com>  
>>> That's for new code I assume?
>>>
>>> What's the harm in leaving this ancient code be?  
>> This change is part of a tree wide cleanup.
> What's the purpose of the "clean up"? Why is it making the code better?
>
> This is a quote from your change:
>
> -  PRINTK (KERN_NOTICE, "debug bitmap is %hx", debug &= DBG_MASK);
> +  PRINTK (KERN_NOTICE, "debug bitmap is %x", debug &= DBG_MASK);
>
> Are you sure that the use of %hx is the worst part of that line?

In this case, it means this bit of code is compliant with the %h checker in checkpatch.

why you are seeing this change for %hx and not the horrible debug &= or the old PRINTK macro is because the change was mechanical.

leveraging the clang build and a special fixit for %h, an allyesconfig for x86_64 cleans this problem from most of the tree in about an hour.  atm/ was just one of the places it hit, there are about 100 more.

If you want the debug &= fixed, i can do that.

The macro is a treewide problem and i can add that to the treewide cleanups i am planning.

Tom

>
>> drivers/atm status is listed as Maintained in MAINTAINERS so changes
>> like this should be ok.
>>
>> Should drivers/atm status be changed?
> Up to Chas, but AFAIU we're probably only a few years away from ATM as 
> a whole walking into the light. So IMHO "Obsolete" would be justified.
>

