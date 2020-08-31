Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E320025846B
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgHaX2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgHaX2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 19:28:55 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A24C061573;
        Mon, 31 Aug 2020 16:28:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g14so7918983iom.0;
        Mon, 31 Aug 2020 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D1ocXnofZxoRyDNB+hFWtCrTUM6YCZuKINCBVBZF6So=;
        b=XyGOuegMr+498BAU2EiZ0yVkFqRYi/rYk6AfyYhi166EidK0pcokQLsTTBbTQk+kFD
         FSskFulUlLfD+bQoUYxGF3bKKHRJwjE8TRuZRzA1tITgrYB3N1eGR6VYHe22J6P5Iy61
         1uURdCtImW3HvCa+OuThgOzgjFunFUmfpevdUseHbTburXkru4OWjVlPhsPCTGy1rFSx
         SsmAiyZRBDAPgsYL/rmC1IJSQvrPwnlGNcY+wtYBqAnLCOsWq1FHKUDOoBum2ZzB9jJP
         73g377IYglxvlyB7ofp9hQedD6ElW9Cyf+p+vQUnb1eCqv4pFWuwWoaLa4op1CFrgB2L
         l0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D1ocXnofZxoRyDNB+hFWtCrTUM6YCZuKINCBVBZF6So=;
        b=YELjX2THMWuCN+0+uCj0wTyQRhB1AfKiSLW2QxAUkl34FkXs2Vep5zcNODFJSOxp/e
         FwKuJh0mXsiFzR1oj20z+/5AEPWGg+oGJaMULX+6N3Tdvh8lfo2Z9OZjL+iw4xxNO0/G
         e5aC6+EBRBYlTFhWeoJyTtUMzrodrHyvua9qbhi3fgRrb0ZGVyAaVz1ZoEEwMYt3gnu6
         jB1+eljd4X/gvLYg5zcRKzyCe/sFI/MG3hbqf4bm6AJSPP5SGip5XHvIYwCJc1dmSrQC
         5znA37AYkUFdwET0VJYrIf++G1rRVwXaDJ1Dr95+uI6wzK2iIq0dK6Jufca9gvssuVwn
         N8nQ==
X-Gm-Message-State: AOAM533Gb3p/iNKIs0qhcj9SQhsPTBojzXkBPahf5DERfg9Kij3J5IpF
        BMjVQfREJQD1t80Hr0RDxEU=
X-Google-Smtp-Source: ABdhPJzfZH5VjsiJgRfWCfENrh8jatvBZwnt5gBK+uUDv5D5rKZNuTL76K8wuDeqcnZxiJtmY3jbtg==
X-Received: by 2002:a5e:d514:: with SMTP id e20mr3225285iom.183.1598916534144;
        Mon, 31 Aug 2020 16:28:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4c46:c3b0:e367:75b2])
        by smtp.googlemail.com with ESMTPSA id b207sm3175329iof.37.2020.08.31.16.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:28:53 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: refer to struct xdp_md in user space comments
To:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, yhs@fb.com
References: <20200819192723.838228-1-kuba@kernel.org>
 <ec62c928-429d-8bea-13ec-5c7744ebf121@iogearbox.net>
 <20200831154319.71a83484@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <27686437-0db5-5882-278c-53bdc47e866a@gmail.com>
Date:   Mon, 31 Aug 2020 17:28:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831154319.71a83484@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 4:43 PM, Jakub Kicinski wrote:
> On Thu, 20 Aug 2020 16:16:47 +0200 Daniel Borkmann wrote:
>> On 8/19/20 9:27 PM, Jakub Kicinski wrote:
>>> uAPI uses xdp_md, not xdp_buff. Fix comments.
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> ---
>>>   include/uapi/linux/bpf.h | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 0480f893facd..cc3553a102d0 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -1554,7 +1554,7 @@ union bpf_attr {  
>>
>> Needs also tooling header copy, but once that is done, it needs fixup for libbpf:
>>
>> [root@pc-9 bpf]# make
>>    GEN      bpf_helper_defs.h
>> Unrecognized type 'struct xdp_md', please add it to known types!
>> make[1]: *** [Makefile:186: bpf_helper_defs.h] Error 1
>> make[1]: *** Deleting file 'bpf_helper_defs.h'
>> make: *** [Makefile:160: all] Error 2
>> [root@pc-9 bpf]#
>>
>> Pls fix up and send v2, thanks.
> 
> FWIW upon closer inspection it appears that this is intentional
> (even if confusing) and bpf_helpers_doc.py swaps the types to 
> __sk_buff and xdp_md when generating man pages and the header.
> 

I liked the direction of fixing the uapi file. Is there a legit reason
to have the documentation in uapi/linux/bpf.h to reference a struct that
is not part of the uapi?
