Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ABD3347EF
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhCJT3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhCJT2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:28:52 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DEFC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:28:51 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id d20so20361011oiw.10
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3f2/4HRWVdFZs1gZxCMmIEzhqEAvM2To88K+yXP5nUU=;
        b=Cn3NO9GG1jAPauwjEKrjtkbUFIlscr1k92BFL3euUWSkcgEz40BeekrlBfLqxxvlTR
         z1Ys9rwkHnuL4ZmvPAffVIsutB1mlxY8XUp4hzDeYsaW6qkC0YFREbO79HCwVgcNniL1
         Ic1Bxph3IzOOy3WqJIricLfHeLL6It//51Qxzqz3ZX5PXuc9DxsvfoDBBOc785iWFFHO
         jnUpLu4cf5Y0/tat9FPpAMVfVYDgCblCYmqspYs8jZkuqHg02GLn/XwvoIWV5QoLT31k
         h/YSXCnu8VUUWT/CXfPHUslbeQTmGaqHTGNyCRP1C+5/punaBHC0fYem7izhrj7mzx+6
         /NMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3f2/4HRWVdFZs1gZxCMmIEzhqEAvM2To88K+yXP5nUU=;
        b=jO5AAwOMsXpQLQILsvhR1rJoReBy+K2EUpb8zg7+Or2erJzqke5piurpc1mW2PrTv8
         97Xy2oEhCEleOHpymsYCjsR960TuTUTb/aCo1SD6JEC67JrusDFW/CRdS0jNZVIEGIaE
         IiNXOuhmnYL/+XHPfv5CPZWP+aEoIHlmSjVRpNFDkYvc5tujmRwsJqTraCNJ35uRCub+
         l+5DB7LN8fPExmhgFYpysUDKPBiokJRN1G4aphdBl1jRIuSdsoMOSwfNmMfBNLLYkedF
         W00fZo9QG/NzhNMUHF598iBQh1Uh3KdLg6b0Sjy5jZHUyHimm90OIxaJFe1DFbSrscI7
         3yrA==
X-Gm-Message-State: AOAM531pmdfEBpheZYsSWPIsqNDNmgikViZ9Bm9abt4Gt5g1zQZ1Y4OG
        kWBNpz6Ol8em/9lS3R2Ea6M4KMVBDtA=
X-Google-Smtp-Source: ABdhPJxmC/IK6AgsWD57ZPujxO6lpBdasC9uZw/8mY9+7qcxqkdABJVy6z02J5UEsUN7GRlARO3WhA==
X-Received: by 2002:aca:3742:: with SMTP id e63mr3550609oia.158.1615404531231;
        Wed, 10 Mar 2021 11:28:51 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id h7sm138122otm.0.2021.03.10.11.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 11:28:50 -0800 (PST)
Subject: Re: [PATCH net-next] net: ipv6: addrconf: Add accept_ra_prefix_route.
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org
References: <1615402193-12122-1-git-send-email-subashab@codeaurora.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d7bb2c1d-1e9a-5191-96bd-c3d567df2da1@gmail.com>
Date:   Wed, 10 Mar 2021 12:28:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1615402193-12122-1-git-send-email-subashab@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 11:49 AM, Subash Abhinov Kasiviswanathan wrote:
> Added new procfs flag to toggle the automatic addition of prefix
> routes on a per device basis. The new flag is accept_ra_prefix_route.
> 
> A value of 0 for the flag maybe used in some forwarding scenarios
> when a userspace daemon is managing the routing.
> Manual deletion of the kernel installed route was not sufficient as
> kernel was adding back the route.
> 
> Defaults to 1 as to not break existing behavior.
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  Documentation/networking/ip-sysctl.rst | 10 ++++++++++
>  include/linux/ipv6.h                   |  1 +
>  include/uapi/linux/ipv6.h              |  1 +
>  net/ipv6/addrconf.c                    | 16 +++++++++++++---
>  4 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c7952ac..9f0d92d 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2022,6 +2022,16 @@ accept_ra_mtu - BOOLEAN
>  		- enabled if accept_ra is enabled.
>  		- disabled if accept_ra is disabled.
>  
> +accept_ra_prefix_route - BOOLEAN
> +	Apply the prefix route based on the RA. If disabled, kernel
> +	does not install the route. This can be used if a userspace
> +	daemon is managing the routing.
> +
> +	Functional default:
> +
> +		- enabled if accept_ra_prefix_route is enabled
> +		- disabled if accept_ra_prefix_route is disabled
> +
>  accept_redirects - BOOLEAN
>  	Accept Redirects.
>  

this seems to duplicate accept_ra_pinfo

