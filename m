Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D0393117
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhE0Om1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhE0Om1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:42:27 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525BAC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 07:40:53 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id d25-20020a0568300459b02902f886f7dd43so410336otc.6
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 07:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NbpVTvw84vL7rxPFnv7XoTAcWTh4nvFWoa5LmSY/P/Q=;
        b=u7ghFQGxJLiXV6BlXXIRO4c4tPWxKmuoeW/7CR6x4bAEQQBiC0DG5egH8G8MEKU3Kq
         KB6ObOvfzMNtuvlt8CDEWeZALBdsa/QjbxxCOZA/XBvXYFMBwQMZx1fIFc9rojcnt4WI
         gXAyXQNXdkWHGHOucFlQ47B5Tp8UvBO/U75uwC3rH4jpOgOEM7x/6ThlPAmwpI3SADXZ
         6/NnbLYmSVxb10x7xIJD8onRyDVfUKOCNsDDmBh+2/9fuR/E8N8XEpTQtuDQb0RO7fHW
         goR8bIpqbYyXr9IVLGKGaUUWUvRZMyN9EXkkesNfYz3XN+SAz0z9KAW/M5EJiPTBEh0z
         T7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbpVTvw84vL7rxPFnv7XoTAcWTh4nvFWoa5LmSY/P/Q=;
        b=N+f0KOG2KQ8SU7ki5Q6QQ/3/EyFZ8zDGT4L+/FmiUj6wtQIIkmkIc9J/zHfChrRmzQ
         feQ2gfAt+iKsXToVyNbvyNOgqwbQAzuDplH/iSw47isIHiLfRITjCv3nCSE5WLUbSnae
         OQWHAJN4l8104ObmVOtOBnRbr5Um/QYpsKgkX0vcH/uTH1vF1t+sA5vee49QzsPBLKJ3
         +MTVgMCbdv2gB+J3WuAEsDxfxkxIIB7pn4KCgJTjLYA/ejfujQpIeCTcH65T8I3vQHRB
         Zbtbj/QFf7JgatGch0gy20hcTLWcpEtH6q6tKkSiCggwK0J+0HMY9iqPWx6PznAALg9M
         zcHQ==
X-Gm-Message-State: AOAM533cBxEsBrxtGIXti9QfaQNFXZ51uWUJLtvftiuBTyG8qQW+4QFY
        +GokcBHcyBX3EgHikAF3EYn4eV8UZ/UMhw==
X-Google-Smtp-Source: ABdhPJz53OH1QKIFM7g2SX7yu6hWuDGmyW1BzMeT1aiuiRYXmSMXnPXbUKQkgC/TQVFi/WGwT4JE+g==
X-Received: by 2002:a05:6830:13c4:: with SMTP id e4mr2908233otq.315.1622126452599;
        Thu, 27 May 2021 07:40:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x8sm488950oiv.51.2021.05.27.07.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 07:40:52 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/2] tc: Add missing ct_state flags
To:     Ariel Levkovich <lariel@nvidia.com>, netdev@vger.kernel.org
References: <20210521170707.704274-1-lariel@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7bc12f25-aae0-67b8-3742-03114a502d20@gmail.com>
Date:   Thu, 27 May 2021 08:40:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210521170707.704274-1-lariel@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 11:07 AM, Ariel Levkovich wrote:
> This short series is:
> 
> 1. Adding support for matching on ct_state flag rel in tc flower
> classifier.
> 
> 2. Adding some missing description of ct_state flags rpl and inv.
> 
> Ariel Levkovich (2):
>   tc: f_flower: Add option to match on related ct state
>   tc: f_flower: Add missing ct_state flags to usage description
> 
>  man/man8/tc-flower.8 | 2 ++
>  tc/f_flower.c        | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 

applied both to iproute-next.
