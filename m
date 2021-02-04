Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7730EA09
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhBDCQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhBDCQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 21:16:42 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8FCC061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 18:16:01 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id n7so2144882oic.11
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 18:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AJESvYOZ2NW9Jg3gzBgEsYBAcWSJCXJPCY8AwxXwGZc=;
        b=jdiubEmH7WCocufS9KTHr6knhzJlT2KIer2D5AViiOgTAXf8fWKhV34AQYJdt4jyo9
         PTq38ByTdWXfxKT5aM/sdO2RNea7jhbBOfuym5+HCs+bnYy8NFPTsA1DxKZzQ57gDY4n
         wzsL5P//RCWSPEYDAflhqtCT+hbTWz5SqayIlEy224ZX7v5ufRDq2J8fo+vffjMwE8Mo
         qSaVRAzHmB6WL6+HSGoeDErsDzwN6otiPoJYkU0EKqL+sbYbg21IXlePP7XzZFclC4TJ
         ZIWj9sNTsZC4LUuZpv3+0SeXc+ZKi47yIaUWlpaGvOI2FHWNjmy3fLfkDmCE7qhr+CBl
         jO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AJESvYOZ2NW9Jg3gzBgEsYBAcWSJCXJPCY8AwxXwGZc=;
        b=iI+50TBmbd+BFoh16TTjMpHwvi3YDlbdf5epOKyqkckan9db6Q7WktgEFhgyw5lwUb
         7N6tclTFGGfot3YR/GlZdjCAuFZbLLikDAivPFZRX44JVg6Xr4hH52moWXZLRpU7xADo
         njyg+VXwlKH1h4Qzzb5Q5wdEDkfAld6fu/k4exPPCsV1D0UB7tmDC8yPN5r0vLx5efaC
         GnX5+dfDarG7uCNpxr0gM9mlkXNDBpfjNteFMTW6eeKX5bczANX98mAQTZbXaWZaei8S
         n0jnJng908svn8mejuIgO3i3tWk3N3JgPNAKB19n0SO6Vk5YH6PLyZkZkfq6Qr881rDy
         5VhA==
X-Gm-Message-State: AOAM533hwuKNIbm+BfbcrlMNReNpBDkvLEeipQy34mauej1LSxp+TF3e
        gS1Ad2zYcnIFEXGll07OPiI=
X-Google-Smtp-Source: ABdhPJzlxEa0DT/A+Ii5p5r4bRC6xPUF3uZ0V4S/KLe0J5qCQzy7vkEvoGYtz6F75BqkbxQOhiplKg==
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr3896120oiw.92.1612404961481;
        Wed, 03 Feb 2021 18:16:01 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id f26sm826477otq.80.2021.02.03.18.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 18:16:00 -0800 (PST)
Subject: Re: [PATCH net-next v2] netlink: add tracepoint at NL_SET_ERR_MSG
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
References: <4546b63e67b2989789d146498b13cc09e1fdc543.1612403190.git.marcelo.leitner@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <be290c78-1929-9d33-d236-d5d202613522@gmail.com>
Date:   Wed, 3 Feb 2021 19:15:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <4546b63e67b2989789d146498b13cc09e1fdc543.1612403190.git.marcelo.leitner@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 6:48 PM, Marcelo Ricardo Leitner wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Often userspace won't request the extack information, or they don't log it
> because of log level or so, and even when they do, sometimes it's not
> enough to know exactly what caused the error.
> 
> Netlink extack is the standard way of reporting erros with descriptive
> error messages. With a trace point on it, we then can know exactly where
> the error happened, regardless of userspace app. Also, we can even see if
> the err msg was overwritten.
> 
> The wrapper do_trace_netlink_extack() is because trace points shouldn't be
> called from .h files, as trace points are not that small, and the function
> call to do_trace_netlink_extack() on the macros is not protected by
> tracepoint_enabled() because the macros are called from modules, and this
> would require exporting some trace structs. As this is error path, it's
> better to export just the wrapper instead.
> 
> v2: removed leftover tracepoint declaration
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  include/linux/netlink.h        |  6 ++++++
>  include/trace/events/netlink.h | 29 +++++++++++++++++++++++++++++
>  net/netlink/af_netlink.c       |  8 ++++++++
>  3 files changed, 43 insertions(+)
>  create mode 100644 include/trace/events/netlink.h
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
