Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D31341D1D1
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347779AbhI3DVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346735AbhI3DVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:21:50 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB56AC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:20:08 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id e16-20020a4ad250000000b002b5e1f1bc78so1413994oos.11
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0qXzTeIto2hKgC9SebnuW0T4TvmpMxfgKJLCEzxCAM0=;
        b=bEEHmrEbyiILzdPRqFmuzdG1/8/mDlFNulGnNxIz3HdYh9eVz7Nmy5ESRZFe4Jl/eM
         +KrxjDnZNfPyxYSYTDApq0MSHrL2Gl053Z1dvohEFn5STImlN5A79PUDSGTAbn/HUURM
         0wqR1COXbNhiKAOALBg5fq92Uxj3EuJ1JOfbvApCOjsE/CNB6USlzZs4QqwVLf9Lq93a
         pmng4H7uFyqF9ECgnewecHf8xuR6xroiRHkFBPdgKPKILA1AOPXeAk93GQ3DWJqFcU54
         7BgOkqNGL+ZSnOJ4SZ+65ad8opXpMZL8xTM9arclvJvmAt7qBoHbB/vXhpc/9Uz2B3yv
         touQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0qXzTeIto2hKgC9SebnuW0T4TvmpMxfgKJLCEzxCAM0=;
        b=TZ3k1RNMF/D6cN+f9ynKInkLOIA5cytW0a9iVTf6M0OwXCBu61fD7D6gby71fgkYe4
         i9APvBdZNe8UNB20fxk4LrttEX4yyHughcN5lxz7zZKQ+SvvqODpw4+P8UPqPn5jVwzU
         m6XwJRHEctGQcDuPGnoa7mLd8tmyP6us8K6TIDAxIynpseDccZEgpy+MZ9cHJitYfYc8
         7cAzQdDP3t9bTDNPqongzjEl4r60rcqqIh2V+gPKjGaJeIK9HEYB8xBC2Wov+BHYxxQc
         9muNoo4CcSMXXt0Ed7A5lx8MGr+Ktt73kBnrtXiGlL8ieNCg9Jfj0s2Mcd3kXA4KMvpy
         O0LA==
X-Gm-Message-State: AOAM531vg545wT8olpWu5EMo6w1yXLMjZsPuJrNw9eA0NoB44oQQvu5G
        U+/XVi8udwYHA4Ee9cmfbAc=
X-Google-Smtp-Source: ABdhPJzRRbhdfeJknQM6JPDaboY+lczGzPMY5ELp9eRjqFulXM2S1TDRWe7QhYWN72HsRavlMjQD6w==
X-Received: by 2002:a4a:7b4b:: with SMTP id l72mr2803316ooc.21.1632972008163;
        Wed, 29 Sep 2021 20:20:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id u6sm377834ooh.15.2021.09.29.20.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 20:20:07 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] Support for the ip6ip6 encapsulation of IOAM
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
References: <20210928190328.24097-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <590592ba-0e79-b649-e03b-6b735a575fc3@gmail.com>
Date:   Wed, 29 Sep 2021 21:20:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928190328.24097-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 1:03 PM, Justin Iurman wrote:
> In the current implementation, IOAM can only be inserted directly (i.e., only
> inside packets generated locally) by default, to be compliant with RFC8200.
> 
> This patch adds support for in-transit packets and provides the ip6ip6
> encapsulation of IOAM. Therefore, three explicit encap modes are defined:
> 
>  - inline: directly inserts IOAM inside packets.
> 
>  - encap:  ip6ip6 encapsulation of IOAM inside packets.
> 
>  - auto:   either inline mode for packets generated locally or encap mode for
>            in-transit packets.
> 
> With current iproute2 implementation, it is configured this way:
> 
> $ ip -6 r [...] encap ioam6 trace prealloc type 0x800000 ns 1 size 12 [...]
> 
> Now, an encap mode must be specified:
> 
> (inline mode)
> $ [...] encap ioam6 mode inline trace prealloc [...]

I take this to mean you want to change the CLI for ioam6? If so, that
does not happen once an iproute2 version has shipped with some previous
command line; it needs to be backwards compatible.

> 
> (encap mode)
> $ [...] encap ioam6 mode encap tundst fc00::2 trace prealloc [...]
> 
> (auto mode)
> $ [...] encap ioam6 mode auto tundst fc00::2 trace prealloc [...]
> 
> A tunnel destination address must be configured when using the encap mode or the
> auto mode.
> 
