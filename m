Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68FF2D38D3
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 03:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgLICaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 21:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgLICaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 21:30:01 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4D5C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 18:29:15 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id y24so808752otk.3
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SaXHYVSm9UVp8Vi/nCkZF7dzMcfDByxL6Z7rUQMVELU=;
        b=IojtK68qJw0evh9rmIgcF+zpJC8yaHDL5pY2LRiIbhw+honGNt5VOVyCl7NXvnmmdb
         LOfdSNXHGLExHYoNFupFuVgn94/ZkWKOyadT0EkBWE0+n6iMRKOfmz4PZlwIWPTO1yXq
         IbReyIs8RfluNIvV9PHI9WYHsYfSiBjp95ELlGoipgxV5sVnOTKhVM6nZGIkaSGTLRAe
         gJbkZeqSTrqlaVk2FGy7IVUWSnJC6EnWjgG+Lk/QrYi/5MqduhdnI+8sOKF7P0Fu7GWh
         B0GxqMDBJ0xtxqjVWreNUf2VrhOdhcjmGWtfGdka+E6rQlk7NcZ6tdbtRvPVnftRUU5N
         S/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SaXHYVSm9UVp8Vi/nCkZF7dzMcfDByxL6Z7rUQMVELU=;
        b=UwPotOrXFBpof1g4CwVJECBIQV5HNnVoIo602wgMGG5W2P1vJcZ+n3R9YtZ4nOmIhz
         FwGoJAvoY033lpzhv2sO/x3PbyaqW/1kwlCZ2w0LHMjMqn/2iRfuN5/ntCPGzUT7mv9j
         IFZhUgN6lQxKZpFgEI/MY+rRpa0L3Jb5ynTR+qbAa8gAPGBFA11Na2E6KlebdserajMj
         7PpYZO9o6znnUIE3g4lo92nBr8vRNFDNBuMDaOw32qUXVfKtB6E0YQmkcfb8yh3gKWJG
         4/i4weIsAEt7WxlcBelgxqMIJQr0oVLsl9KvM6ceVa/BTSDypOWFxR7S6Gj68OXHop0j
         L+Vw==
X-Gm-Message-State: AOAM530QMYGH2W9ZfrRT8pbMRz3ip40HNYUn23Z6OGf+qMzfc99GoFEI
        EwMq5AJaxOFOFs2U75GffW7JN9lJ1dU=
X-Google-Smtp-Source: ABdhPJz92/VCQ9NifdDzAyveQr3/Zy475fCImuE3ncTVlH2HUEUfuC2mep8F+Hp+d83JBT8MlXluyA==
X-Received: by 2002:a05:6830:1aec:: with SMTP id c12mr33637otd.337.1607480954656;
        Tue, 08 Dec 2020 18:29:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id g188sm52440oia.19.2020.12.08.18.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 18:29:13 -0800 (PST)
Subject: Re: [iproute2-next v2] seg6: add support for vrftable attribute in
 SRv6 End.DT4/DT6 behaviors
To:     Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20201202131551.19628-1-paolo.lungaroni@cnit.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b86a2b0a-46c5-94de-9443-522428b6b069@gmail.com>
Date:   Tue, 8 Dec 2020 19:29:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201202131551.19628-1-paolo.lungaroni@cnit.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/20 6:15 AM, Paolo Lungaroni wrote:
> We introduce the "vrftable" attribute for supporting the SRv6 End.DT4 and
> End.DT6 behaviors in iproute2.
> The "vrftable" attribute indicates the routing table associated with
> the VRF device used by SRv6 End.DT4/DT6 for routing IPv4/IPv6 packets.
> 
> The SRv6 End.DT4/DT6 is used to implement IPv4/IPv6 L3 VPNs based on Segment
> Routing over IPv6 networks in multi-tenants environments.
> It decapsulates the received packets and it performs the IPv4/IPv6 routing
> lookup in the routing table of the tenant.
> 
> The SRv6 End.DT4/DT6 leverages a VRF device in order to force the routing
> lookup into the associated routing table using the "vrftable" attribute.
> 
> Some examples:
>  $ ip -6 route add 2001:db8::1 encap seg6local action End.DT4 vrftable 100 dev eth0
>  $ ip -6 route add 2001:db8::2 encap seg6local action End.DT6 vrftable 200 dev eth0
> 
> Standard Output:
>  $ ip -6 route show 2001:db8::1
>  2001:db8::1  encap seg6local action End.DT4 vrftable 100 dev eth0 metric 1024 pref medium
> 
> JSON Output:
> $ ip -6 -j -p route show 2001:db8::2
> [ {
>         "dst": "2001:db8::2",
>         "encap": "seg6local",
>         "action": "End.DT6",
>         "vrftable": 200,
>         "dev": "eth0",
>         "metric": 1024,
>         "flags": [ ],
>         "pref": "medium"
> } ]
> 
> v2:
>  - no changes made: resubmit after pulling out this patch from the kernel
>    patchset.
> 
> v1:
>  - mixing this patch with the kernel patchset confused patckwork.
> 
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  1 +
>  ip/iproute_lwtunnel.c           | 19 ++++++++++++++++---
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 

applied to iproute2-next. Thanks,

