Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55233A5D0
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 16:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCNP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 11:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhCNPzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 11:55:48 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92565C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:55:47 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id d16so22809901oic.0
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Om//DNEUW7+iGhPaQYofUVUUFylbpGKM/enveNygqok=;
        b=pMmXRmsAqm6dJxsr82NFX96lb85CbiPVumfKB6UM0bbt2VuVykZDX5S2iGi4m6RWXW
         Yugy95R+rA9xK4/t4DtF+paqyhd6PmBgtNgGjSBHJ7jxslV97oMCsk7urYWdbIEtq1hw
         Ai88CwDv6a163v3+KEDCdGRdHrEeqfIO9B2hDIuBnInnRgST47rOhqVGn77geEeZ+jkt
         XsKXGNeSQjRNgf52VVwodI1o3UveOsrJCKwU6+rTTTwOTNdxjSFBt1b6PoVdDmCH2lle
         w3TRVckQAWA2BswT4Q4AfSkcqRf34kDue2wWv3Rd34BnSC/f5QD28oiavL2gdVFdW28t
         /azQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Om//DNEUW7+iGhPaQYofUVUUFylbpGKM/enveNygqok=;
        b=L4ygaU2ZPa4NEnoIZsl972vlNzgYEh4+ODUkwSxg5ZFS+stXw9qekEgUMmurvNEnR8
         hu8L12S/U8f6xByfyWXml4ZzE2+y+yvImGn6nn9vi3nQ+L1c6pNqV+2LsP6Q7RLPQmT1
         kTfDh5ITmlicA7dsb497e/tSAz626Bvg7GwYYx6x093SixiXowPouxFBcv+/jX8s9tUV
         77jbkJUIuBlbJwjoA1j+fDctHeGQ6YeBPuJ7jVA9GNePbiVzYTd1e2LlNva72J8cRbka
         nXInu63XlKD4dnCClZ9xLQHlwLCQLlaPoRV69YXIErITmXTZkjdyih6vLX1V7l+egoPE
         3ViQ==
X-Gm-Message-State: AOAM532zhrrZNR6THunN+gtd6yzKLchOIteJHg0LKi6ilyb7/nHnpJKk
        ollfH6Sdy4exgsPwCWJrW6M=
X-Google-Smtp-Source: ABdhPJwbvHglViRJsM6Zs0IW3wtIdvUd4MWtJGIqRT13eFhPrjolM5Nz3g3XPhjRuUFdTBgKiFbIqw==
X-Received: by 2002:aca:d854:: with SMTP id p81mr11671131oig.90.1615737347047;
        Sun, 14 Mar 2021 08:55:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id z8sm5201611oih.1.2021.03.14.08.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 08:55:46 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 4/6] nexthop: Add ability to specify group
 type
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <me@pmachata.org>
References: <cover.1615568866.git.petrm@nvidia.com>
 <b614d787896a33481e09487deec42b482fdc8643.1615568866.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5397a5b8-da46-7290-9395-5fcd46121f42@gmail.com>
Date:   Sun, 14 Mar 2021 09:55:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <b614d787896a33481e09487deec42b482fdc8643.1615568866.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 10:23 AM, Petr Machata wrote:
> From: Petr Machata <me@pmachata.org>
> 
> From: Ido Schimmel <idosch@nvidia.com>

All of the patches have the above. If Ido is the author and you are
sending, AIUI you add your Signed-off-by below his.

> 
> Next patches are going to add a 'resilient' nexthop group type, so allow
> users to specify the type using the 'type' argument. Currently, only
> 'mpath' type is supported.
> 
> These two command are equivalent:
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  ip/ipnexthop.c        | 32 +++++++++++++++++++++++++++++++-
>  man/man8/ip-nexthop.8 | 18 ++++++++++++++++--
>  2 files changed, 47 insertions(+), 3 deletions(-)
> 

...

> diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
> index 4d55f4dbcc75..f02e0555a000 100644
> --- a/man/man8/ip-nexthop.8
> +++ b/man/man8/ip-nexthop.8
> @@ -54,7 +54,9 @@ ip-nexthop \- nexthop object management
>  .BR fdb " ] | "
>  .B  group
>  .IR GROUP " [ "
> -.BR fdb " ] } "
> +.BR fdb " ] [ "
> +.B type
> +.IR TYPE " ] } "
>  
>  .ti -8
>  .IR ENCAP " := [ "
> @@ -71,6 +73,10 @@ ip-nexthop \- nexthop object management
>  .IR GROUP " := "
>  .BR id "[," weight "[/...]"
>  
> +.ti -8
> +.IR TYPE " := { "
> +.BR mpath " }"
> +
>  .SH DESCRIPTION
>  .B ip nexthop
>  is used to manipulate entries in the kernel's nexthop tables.
> @@ -122,9 +128,17 @@ is a set of encapsulation attributes specific to the
>  .in -2
>  
>  .TP
> -.BI group " GROUP"
> +.BI group " GROUP [ " type " TYPE ]"
>  create a nexthop group. Group specification is id with an optional
>  weight (id,weight) and a '/' as a separator between entries.
> +.sp
> +.I TYPE
> +is a string specifying the nexthop group type. Namely:
> +
> +.in +8
> +.BI mpath
> +- multipath nexthop group
> +

Add a comment that this is the default group type and refers to the
legacy hash-bashed multipath group.

The rest of the patches look ok to me.
