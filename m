Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BDE2C3828
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgKYEjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKYEjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:39:11 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66967C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:38:58 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id y9so959674ilb.0
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wuvCxCUyDw0maOAHbIfj8AAmeWOiQAsI4pw9FsSwaMA=;
        b=r9QrsDaxxdBjVObs90I/xupcP3d5ZLsxNKvLG8YMz0/KOwD3pbpMrJHA7XkL6khjQq
         N4ACKlzIGZjhqFknfIMS7xDxoRHoeUnUu3+os3s1g076pwknOZihKkAmSfc0CDxJDI7l
         FMenFALRX58L9cnVTBAqaEiRG+pIoSWljiVuhrgkH4tlDs6NkOStZE9b9UfZH02MC8Ne
         dm9c7mF2I2HxSCUw8nW5mDU5liVn1qt9qCtZbdNS+f6jkbTBP8Bc+eWteZ7hdx0vtDiy
         IxcKwzlQcMli1vc/W7I/KJ7SeDbGdanz/qXVfVVk8GiWF6zg905ptmB/ymfFvANJFsTD
         5Oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuvCxCUyDw0maOAHbIfj8AAmeWOiQAsI4pw9FsSwaMA=;
        b=VCbXv58XU+4ag/yfR26Md10J8n0q2N04vzvhLwuZ3JRFaEZfYAQFqe8iT5obfLLF9L
         tVJE9phvkw/OfY8nNDRACRosjUHI3KmltZKlllio8s3M8POxNs7vwnBlbe6dYhHlGq21
         F6ZOihjIrAohlz9v77q+m28dWOIaAvWayyp/g66Uj9lt0D3Xv9JWg1b3SqufSk683eyL
         Kx/9TZbwmKmvzXoD/6hLjo6hNBaNN9tWw8T+F0wZ4ynRAAUHxG8h7xGUO+bw8ibFXwCo
         QapacHnCo6AGJ0SwU+erq/EoPIdrnQ3bJoYkceB3aeKcQXBPE1NPGRbHxZquxYxLWyTc
         Llxw==
X-Gm-Message-State: AOAM533ykfbx+C/oCHBXrHXlXd9GaUmwcQ3dMK2+H0MkahwDzwrZEb6W
        GjYrjwgPzfuuZQajV3Gp/PI=
X-Google-Smtp-Source: ABdhPJzGUKW+XjSeWdIGDEzLLnrUCiBUlOs14PQBU6bzOJZin+Fh4XSIgq1CODlmD0GnvoVVJGieow==
X-Received: by 2002:a92:8bcb:: with SMTP id i194mr1566858ild.200.1606279137842;
        Tue, 24 Nov 2020 20:38:57 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id 26sm408212iof.35.2020.11.24.20.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 20:38:57 -0800 (PST)
Subject: Re: [PATCH net v2] Documentation: netdev-FAQ: suggest how to post
 co-dependent series
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, brouer@redhat.com, f.fainelli@gmail.com,
        andrea.mayer@uniroma2.it, stephen@networkplumber.org,
        ast@kernel.org
References: <20201125041524.190170-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ddc9fac-b399-cd11-b5e7-e703e7dee855@gmail.com>
Date:   Tue, 24 Nov 2020 21:38:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125041524.190170-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 9:15 PM, Jakub Kicinski wrote:
> Make an explicit suggestion how to post user space side of kernel
> patches to avoid reposts when patchwork groups the wrong patches.
> 
> v2: mention the cases unlike iproute2 explicitly
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/networking/netdev-FAQ.rst | 26 +++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
> index 21537766be4d..4b9ed5874d5a 100644
> --- a/Documentation/networking/netdev-FAQ.rst
> +++ b/Documentation/networking/netdev-FAQ.rst
> @@ -254,6 +254,32 @@ you will have done run-time testing specific to your change, but at a
>  minimum, your changes should survive an ``allyesconfig`` and an
>  ``allmodconfig`` build without new warnings or failures.
>  
> +Q: How do I post corresponding changes to user space components?
> +----------------------------------------------------------------
> +A: User space code exercising kernel features should be posted
> +alongside kernel patches. This gives reviewers a chance to see
> +how any new interface is used and how well it works.
> +
> +When user space tools reside in the kernel repo itself all changes
> +should generally come as one series. If series becomes too large
> +or the user space project is not reviewed on netdev include a link
> +to a public repo where user space patches can be seen.
> +
> +In case user space tooling lives in a separate repository but is
> +reviewed on netdev  (e.g. patches to `iproute2` tools) kernel and

double space. besides that:
Reviewed-by: David Ahern <dsahern@kernel.org>




