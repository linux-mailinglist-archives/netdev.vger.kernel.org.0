Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223B046C0D6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbhLGQkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbhLGQkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:40:45 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7794FC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 08:37:15 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso18820895ota.5
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 08:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ft01ug+wcObzRghrP/onVbkHp22WiNHqOY27doOM0RM=;
        b=T9mkAmcketqHkDL0S4AeWZHcTAdu8tvECpuTAUeRAFf+HN89BLOmg3vnuO2jw9UHgt
         +uSCXnAf4I0Gcqcb8cCEKa94je/kUahnzvMhQ5cIpO6rdZw2DbaN9CfEoaz86h6agmzw
         k1KnQWQN/d8+naOvt3xRj3F39rKvMYFXi9idYr2KiZoq2mDCrfex30bYQJe+w6iy7aN0
         ZWswuMRLyEBoXz9Ug/nqEg6esP77dtFvc72OIxN83WaJWUESCIL0iCu/h6bDxn0/pb3Y
         It5B5kWro3oAwhAd/wTL6pFRyW1QrOhggqp8B9Gl64nBtNTI5pC5yIxmX5AM3omQQfVT
         mh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ft01ug+wcObzRghrP/onVbkHp22WiNHqOY27doOM0RM=;
        b=OQVpqOu3hZXdfxDhiTlHKbPSr4dxi0F+rFoLTxYKd4KokUJn190pIvyRi3KCW61KUa
         fvkuRoALBPKLzCnF6oUoN+yqrBG80Ur0uW9IobmZbCDMY/SAKCBxxAxvfleCxS/3aEP5
         reHzp3+SjgePiBiXpRaNL7Xg1i9N2OPT0OrRrGg46X70+2gfpQMsJ7EbvrXyhD96kqxP
         Kr9BD1Umbxsw8agmXeh0iqkoT/M3Iywf9xO5fEUQHwOEcIJm4peq2V7nis7Pmq0zFrXD
         +cZVZMJDemHSa4BHHtBBJayXMH+5VNI+qVZXz7JCzUfJvvp4XM8BQJ1rDsspxf2aX1GS
         R/Yw==
X-Gm-Message-State: AOAM532OnIJzFfTw3Gbcgo9wm7KQTZRwebI6hr/Vhm4bVTb0aKLYud2F
        ALfohLwbhqFxhqRJu7bLzRM=
X-Google-Smtp-Source: ABdhPJwzKIOUNkvZkwfRVBMMvlnjpmRPX7hIW6mlTWA1fmmqqhP7d1LyNDplWUSB6pTVYIbQxyJM/Q==
X-Received: by 2002:a9d:6d85:: with SMTP id x5mr36557881otp.221.1638895034360;
        Tue, 07 Dec 2021 08:37:14 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id p10sm12430otp.53.2021.12.07.08.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 08:37:14 -0800 (PST)
Message-ID: <ca0f1801-8bbb-6013-cda5-8cf924d51fc6@gmail.com>
Date:   Tue, 7 Dec 2021 09:37:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy data
 field
Content-Language: en-US
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, vbabka@suse.cz
References: <20211206211758.19057-1-justin.iurman@uliege.be>
 <20211206211758.19057-3-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211206211758.19057-3-justin.iurman@uliege.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 2:17 PM, Justin Iurman wrote:
> This patch is an attempt to support the buffer occupancy in IOAM trace
> data fields. Any feedback is appreciated, or any other idea if this one
> is not correct.
> 
> The draft [1] says the following:
> 
>    The "buffer occupancy" field is a 4-octet unsigned integer field.
>    This field indicates the current status of the occupancy of the
>    common buffer pool used by a set of queues.  The units of this field
>    are implementation specific.  Hence, the units are interpreted within
>    the context of an IOAM-Namespace and/or node-id if used.  The authors
>    acknowledge that in some operational cases there is a need for the
>    units to be consistent across a packet path through the network,
>    hence it is recommended for implementations to use standard units
>    such as Bytes.
> 
> An existing function (i.e., get_slabinfo) is used to retrieve info about
> skbuff_head_cache. For that, both the prototype of get_slabinfo and
> struct definition of slabinfo were moved from mm/slab.h to
> include/linux/slab.h. Any objection on this?
> 
> The function kmem_cache_size is used to retrieve the size of a slab
> object. Note that it returns the "object_size" field, not the "size"
> field. If needed, a new function (e.g., kmem_cache_full_size) could be
> added to return the "size" field. To match the definition from the
> draft, the number of bytes is computed as follows:
> 
> slabinfo.active_objs * size
> 
> Thoughts?
> 
>   [1] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.2.12
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  include/linux/slab.h | 15 +++++++++++++++
>  mm/slab.h            | 14 --------------
>  net/ipv6/ioam6.c     | 13 ++++++++++++-
>  3 files changed, 27 insertions(+), 15 deletions(-)
> 

this should be 2 patches - one that moves the slabinfo struct and
function across header files and then the ioam6 change.

[ I agree with Jakub's line of questioning - how useful is this across
nodes with different OS'es and s/w versions. ]
