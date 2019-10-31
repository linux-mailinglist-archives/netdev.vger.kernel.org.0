Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A260AEB479
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfJaQL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:11:27 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36260 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaQL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:11:26 -0400
Received: by mail-io1-f65.google.com with SMTP id s3so3525907ioe.3
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sTBeRq4v+wjTfSf5oAMbUHSeAjg9jKJILxni8kDjY8o=;
        b=RUbg8glQsnlJqmc0Ypj2/+E5fBFR/19VQBYFvizHrHaL4eCCgm3Ph9tj8P5Za5gEi0
         3cfRm4kvrZJYh5V3AmBbdkllqnoA2zAnuzr4mEos9R5R4vuHYA2PUsdiwygbroBdEPXY
         5F9D6Vsml8XG3McGFMzbXMc99+oVmBe2291an4P+HrJEG1EV8jcJ1C/Mf3XWxLHnv/ue
         97gMvzj4Yrbefl/pYs4D4cK4PKOIduVfB1fHJhROMtUk2bUpLbr+T1uPncksHd1Z0g8w
         gW9p7B/Tl1IDYOtntOZVvhA4ymcWDo1x3Id5xqYATjkIpfRcaEdCJh/o+d7N9Umg9CCh
         Ladg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sTBeRq4v+wjTfSf5oAMbUHSeAjg9jKJILxni8kDjY8o=;
        b=GmUDs23b0iqgRGdoljACJxDcrgoSN8oQxwWdtYDCq2+jT+DYaCjkuBFMFIfA4KEsAW
         crkMtJJeJVp9UYheZa4xaJt6VMs0auDShmBDczgEZB49wpBhUFF+pUSRV5S53BRkYbHN
         WRa1lfWNTzEVBMPXXBqld9c9pf9aaiVERoH/mo24RDhTUxOWmPk4XeUAiIUsYfzBshyP
         US5mbyU7yK3w8JfWfqe+o9ZoAKKVyqgGdD9kjt8fq8Oguu86uS4Ex/EdqMSyAhDzqr/a
         rtKNNxnxK0VxO0FRNX3WmjokJZxeWixNz9MxtNt0fmITD7rtFr3sWU7+Ampzdshg/Ij2
         2RUA==
X-Gm-Message-State: APjAAAX5EG8yzWRPkrKaiuZ7yEy0ppfH2xoLEmn5kA/S7sV7yDitwK9R
        0eAUfHv04gyWCacZgiQwNew=
X-Google-Smtp-Source: APXvYqyl2l+v1cRK7ASnMwnjLuOSG7h6RLLd+GIWdRJZkL7BmAJRd0zkqmBBj636sz96iSej9x9UZg==
X-Received: by 2002:a5e:d502:: with SMTP id e2mr6092276iom.224.1572538285890;
        Thu, 31 Oct 2019 09:11:25 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:e0f1:25db:d02a:8fc2])
        by smtp.googlemail.com with ESMTPSA id h24sm399215ioh.0.2019.10.31.09.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 09:11:25 -0700 (PDT)
Subject: Re: [PATCH iproute2] ip-route: fix json formatting for multipath
 routing
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <99a4a6ffec5d9e7b508863873bf2097bfbb79ec6.1572534380.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f15a41a2-f861-550c-0f0b-5fc0b40db899@gmail.com>
Date:   Thu, 31 Oct 2019 10:11:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <99a4a6ffec5d9e7b508863873bf2097bfbb79ec6.1572534380.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 9:09 AM, Andrea Claudi wrote:
> json output for multipath routing is broken due to some non-jsonified
> print in print_rta_multipath(). To reproduce the issue:
> 
> $ ip route add default \
>   nexthop via 192.168.1.1 weight 1 \
>   nexthop via 192.168.2.1 weight 1
> $ ip -j route | jq
> parse error: Invalid numeric literal at line 1, column 58
> 
> Fix this opening a "multipath" json array that can contain multiple
> route objects, and using print_*() instead of fprintf().
> 
> This is the output for the above commands applying this patch:
> 
> [
>   {
>     "dst": "default",
>     "flags": [],
>     "multipath": [
>       {
>         "gateway": "192.168.1.1",
>         "dev": "wlp61s0",
>         "weight": 1,
>         "flags": [
>           "linkdown"
>         ]
>       },
>       {
>         "gateway": "192.168.2.1",
>         "dev": "ens1u1",
>         "weight": 1,
>         "flags": []
>       }
>     ]
>   }
> ]
> 
> Fixes: f48e14880a0e5 ("iproute: refactor multipath print")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> Reported-by: Patrick Hagara <phagara@redhat.com>
> ---
>  ip/iproute.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 

This is fixed -next by 4ecefff3cf25 ("ip: fix ip route show json output
for multipath nexthops"). Stephen can cherry pick it for master
