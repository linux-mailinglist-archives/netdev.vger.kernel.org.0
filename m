Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833D548CA7D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348647AbiALR5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242192AbiALR5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:57:53 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2646EC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 09:57:53 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id u8so4845356iol.5
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 09:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4m0dbrDG3kjTnMhuxOA+yVKrJ0fcR2XJeuaybltVmMM=;
        b=FnZqYCa+Ock/kquuE8hGvCQdfM6LxwGk0/JpP7eclDUFbq4r1gTtkg/kUyFcLguVci
         NtlpuokpyYo15sDowI03aNGcuK4S2QPMKiheRM9JomN4FWuxoB6qfQPycQ4MGQIIaSZp
         lAM3YkT3I49Gkoi+rRjCDWAI/FgPG11oT8Opcmo32cAlOPfkMH+PmLUVOXHeES6YybCn
         KP6pXijHIdC7WTpiKVnmY9Q+p2GLshsMREQh7Nz5k0GnJO1IQUJWkoQRY4GwyZS6Zh7n
         rMbQuISnlhG3YguGQWRcFKMyNvfGxEXuVcFLml00Wvo48mwz8kGkREWwETBQ1fwDHL0k
         BUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4m0dbrDG3kjTnMhuxOA+yVKrJ0fcR2XJeuaybltVmMM=;
        b=aSPxi7c5IiFvUTo9Slf3zOMAmvnaOAKXkliTRqkHTZDVbt/Xs/UysbaX1PlbByS+jE
         oCK2NFFZg4wy6U1X/cEJptmwKkkjlkONuYmEIaKun45QuvM6nIw3kTN6qynqXdE6Kgjb
         srSo4W9EqKcZKdb/ByaLDRV7G7H2vMg85S7EzCahBgu3irAyhgRKeQsO5HbYEzN8BnCo
         EoVtKzErjP+YRROzyzxH61fP88Gcuws7Grvcj3scKcSVP11S3/S4ObYiFlXv+ZpaNxqq
         GIApDWu5N4f71m2DAhjtFdPXonNqjpsjyLfDitDuM4RmskVmsLwe5RVOqIRJyT61pWir
         ld3w==
X-Gm-Message-State: AOAM532Zl/PEdQ4smj9VbY3GZ7LENEoxOJ0VH6CRr/rjP3HTgtNMOt/x
        wckF6AwrcJhHozoMqCsgBMk=
X-Google-Smtp-Source: ABdhPJwAGw+eBpCzJCQirv08wg/f+kKGwuEY/2GMppjDcUDmYVSExZXyB0KeQAoM4sYnp/SJxq4M1A==
X-Received: by 2002:a02:9699:: with SMTP id w25mr432066jai.27.1642010272281;
        Wed, 12 Jan 2022 09:57:52 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id y8sm329923ilu.72.2022.01.12.09.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 09:57:51 -0800 (PST)
Message-ID: <6421a75c-0341-4813-7c12-5836a440df76@gmail.com>
Date:   Wed, 12 Jan 2022 10:57:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH iproute2 v2] ip: Extend filter links/addresses
Content-Language: en-US
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20220108195824.23840-1-littlesmilingcloud@gmail.com>
 <acff5b79-2e5d-2877-0532-bb48608cc83b@gmail.com>
 <CAEzD07JA8+MnQCcRViUxY=TFgeiFn-ZNgkMzvYo06oDuFUMRVA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CAEzD07JA8+MnQCcRViUxY=TFgeiFn-ZNgkMzvYo06oDuFUMRVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 12:09 PM, Anton Danilov wrote:
> Hello, David.
> 
>> current 'type' filtering is the 'kind' string in the rtnl_link_ops --
>> bridge, veth, vlan, vrf, etc. You are now wanting to add 'exclude_type'
>> and make it based on hardware type. That is a confusing user api.
> 
> The 'exclude_type' options first checks the 'kind' in the
> rtnl_link_ops, then the hardware type.

ok; missed that on the first pass.

Update the commit message to say filtering by "hardware type"

>> On 1/8/22 12:58 PM, Anton Danilov wrote:
>>> @@ -227,6 +227,28 @@ static int match_link_kind(struct rtattr **tb, const char *kind, bool slave)
>>>       return strcmp(parse_link_kind(tb[IFLA_LINKINFO], slave), kind);
>>>  }
>>>
>>> +static int match_if_type_name(unsigned short if_type, const char *type_name)
>>> +{
>>> +
>>> +     char *expected_type_name;
>>> +
>>> +     switch (if_type) {
>>> +     case ARPHRD_ETHER:
>>> +             expected_type_name = "ether";
>>> +             break;
>>> +     case ARPHRD_LOOPBACK:
>>> +             expected_type_name = "loopback";
>>> +             break;
>>> +     case ARPHRD_PPP:
>>> +             expected_type_name = "ppp";

ppp devices have kind set, so ARPHRD_PPP should not be needed.


Also, you have supported hardware types in multiple places - this match
function and the filter.kind check. Make 1 table with supported types
and use that table with helpers or both paths.

Why not allow exclude by "_slave" type? e.g., should all devices but
bridge ports?

