Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EF334AB30
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhCZPOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhCZPN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:13:57 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085BCC0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:13:57 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so5505907otk.5
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YtWZKPv0Y1ZPSmNK2E/u1XmjOi8zAX10j63pJRUNGJ0=;
        b=M15BJ8LUCrzKWLe7ocjWg51wP+sYRWo3yEcIE6O4GpPzG+RATEkIQc0mLyJnoxZK0G
         5GRoKeLfuMuW/sn8nmA6rzgk95LhNcN3CDmmTzraC7cbCjA8UU4MimFSCT/Do6RaZGsH
         xnmamF6xt2Mu7cWWgq5yFxXl08LUNAGcZYgyfvHSRep0eO6/V3bz+FOiUbGdMppwpeV3
         KuVbr+62WzRgZBX2gHdtF8ooY1FCzkhjV+0Hedwz+VDPW1PHvqqloGmm25L1evWBqdd3
         HOIjcvTSFl1G0Kr2AWShE4bv1wxdMO0LRzYFR6U2NX7BHNHzVu1E2UHti84wh6bkEoIE
         RKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YtWZKPv0Y1ZPSmNK2E/u1XmjOi8zAX10j63pJRUNGJ0=;
        b=QKaMsND7w1VOdWXXhfkL2gNa00pZJVni9d//I0Tnq3kBV8EJ9ONgWccTaY5HqRiYI9
         2e2oiZud44tXlylRfPbweOxVK2lAFoJw1YQMYJvgVuxOHyCoRjpdQLdeexXrsxvVkdnD
         yXVJfETPYIeoKxkzlj9PSOQ8KgGKVublMUJcZ/mn0FD38i7IX+y2mqSTHusmBCOl/ph/
         ZL6BrtL+ckwUDxD6C2fTW9KucLg42i+S4Lu2dPsOcIQmW+KVffAAP/yzLFgPXT1XErx/
         krmh286YVPdb1Qjf/6I3yFgqRl6psaymgAdSZthbI3XD0k3EBa57QK8mnXvxlmx7x6SB
         2WOA==
X-Gm-Message-State: AOAM5316IdlIv3AgIImmD0Z04TkUn01oeBAtllaPExPPCtapKIF4i8Sr
        u400gmXdv4h7gwp4w14fVtcPqxzPe80=
X-Google-Smtp-Source: ABdhPJz4P9FQSmdBN/I7rp6WidFWyVv4PDAJ3mIL/8RE4Gu0oeKNpP6wNpaOQU7aylgb5SPuFHpdMQ==
X-Received: by 2002:a9d:6a50:: with SMTP id h16mr12083692otn.67.1616771636361;
        Fri, 26 Mar 2021 08:13:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id e4sm1739178oie.23.2021.03.26.08.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:13:55 -0700 (PDT)
Subject: Re: [PATCH net-next] nexthop: Rename artifacts related to legacy
 multipath nexthop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
References: <2e29627ba3c4e6edf5ee2c053da52dab22f3d514.1616764400.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2eca9b17-2014-d2a6-9030-acf1b2beb3e6@gmail.com>
Date:   Fri, 26 Mar 2021 09:13:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <2e29627ba3c4e6edf5ee2c053da52dab22f3d514.1616764400.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/21 7:20 AM, Petr Machata wrote:
> After resilient next-hop groups have been added recently, there are two
> types of multipath next-hop groups: the legacy "mpath", and the new
> "resilient". Calling the legacy next-hop group type "mpath" is unfortunate,
> because that describes the fact that a packet could be forwarded in one of
> several paths, which is also true for the resilient next-hop groups.
> 
> Therefore, to make the naming clearer, rename various artifacts to reflect
> the assumptions made. Therefore as of this patch:
> 
> - The flag for multipath groups is nh_grp_entry::is_multipath. This
>   includes the legacy and resilient groups, as well as any future group
>   types that behave as multipath groups.
>   Functions that assume this have "mpath" in the name.
> 
> - The flag for legacy multipath groups is nh_grp_entry::hash_threshold.
>   Functions that assume this have "hthr" in the name.
> 
> - The flag for resilient groups is nh_grp_entry::resilient.
>   Functions that assume this have "res" in the name.
> 
> Besides the above, struct nh_grp_entry::mpath was renamed to ::hthr as
> well.
> 
> UAPI artifacts were obviously left intact.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  include/net/nexthop.h |  4 ++--
>  net/ipv4/nexthop.c    | 56 +++++++++++++++++++++----------------------
>  2 files changed, 30 insertions(+), 30 deletions(-)
> 

Thanks for the followup.

Reviewed-by: David Ahern <dsahern@kernel.org>

