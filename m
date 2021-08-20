Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D103F31FA
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhHTRHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhHTRHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 13:07:14 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36D6C061575;
        Fri, 20 Aug 2021 10:06:36 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso10236307otp.1;
        Fri, 20 Aug 2021 10:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZLQf+DCPXtPja1Wn3Jwj50C4NZ7pfzdSEBWd5kZn1KI=;
        b=idHbewlEPI07K7dUj6u5WKIvAXZfe7DPzoECuJXMFdXXLtPyRCva1T79kVDa9DzYtt
         NQubybyP+nV1dVyQ+CBupJAp1Ny5SWmpoxlvg4YBRP9tsXHkAnPF67mDh4AwzccrT/j+
         tH/6j3LPBqSx/fd3lXIKaBiomMvEMyRf9BgQaJ4KaLdhcg8v7TA4w4XJaRbHPeW9fyXe
         n+U3dzZiwiaLVDhNj8NfDp6cJ5Kv7d2kiG36fVRQoSLd0LSfQ/qyY5Y7nNmxYe2+ZEfV
         EddrSne927yyZkTQfUeU5Sa4YaIffwbbz4kKJOxVjRqgtFDtuXb2kGkDNHEq9hiEMRjK
         fbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZLQf+DCPXtPja1Wn3Jwj50C4NZ7pfzdSEBWd5kZn1KI=;
        b=pqsjWx8LTC8hBsS8DYyVTnGImhMvHdPsuLUp1DTIcHXt85cRLGLZTmC5/ZnlvItEJs
         jlVY960zMs57i/+soLURWSQabHmAKmIX+/cx03686EspiFz5pcxw946OPzp+FWprFpcp
         RBdjyHWYhIw54rw9YGMXjogFGGaEdnGiabIcE+gFok4NTqFzayhbILf/aBC/IbogIilZ
         DTeC4Yz+lKxgEA4rQ8reUKI+uQXU5Bb5XtJ6cOmiOBTfv58i/Sj2j+eEc4+GbrDAepIU
         YkuJXLCk6WxiUYGgPJtegSOcvjnLKNCaKhTSSW4hBSXUsDb5AQ9/K49Gq1kdqDgT2P7Z
         +dWw==
X-Gm-Message-State: AOAM53247uJbNi04Ktm6DTUwhjs0pVI8lhDYsYZt70qxg1+MpcWpWVLg
        IDMjP5tsjlOZHjj281XAVkzLTPIkhFwKGA==
X-Google-Smtp-Source: ABdhPJzCkdSR3Ium9E7AXLcXw++SuHtt7DejBfg3ndGryCcVNZlZDDLvT1eAsCeqbfXUY5DVzd56tg==
X-Received: by 2002:a05:6808:cd:: with SMTP id t13mr3580206oic.111.1629479196180;
        Fri, 20 Aug 2021 10:06:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id b24sm1483849oic.33.2021.08.20.10.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 10:06:35 -0700 (PDT)
Subject: Re: [PATCH net-next] doc: Document unexpected tcp_l3mdev_accept=1
 behavior
To:     Benjamin Poirier <bpoirier@nvidia.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20210819083854.156996-1-bpoirier@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5254c616-dc21-1e41-9923-59aade8a4731@gmail.com>
Date:   Fri, 20 Aug 2021 11:06:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819083854.156996-1-bpoirier@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 2:38 AM, Benjamin Poirier wrote:
> As suggested by David, document a somewhat unexpected behavior that results
> from net.ipv4.tcp_l3mdev_accept=1. This behavior was encountered while
> debugging FRR, a VRF-aware application, on a system which used
> net.ipv4.tcp_l3mdev_accept=1 and where TCP connections for BGP with MD5
> keys were failing to establish.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
>  Documentation/networking/vrf.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/networking/vrf.rst b/Documentation/networking/vrf.rst
> index 0dde145043bc..0a9a6f968cb9 100644
> --- a/Documentation/networking/vrf.rst
> +++ b/Documentation/networking/vrf.rst
> @@ -144,6 +144,19 @@ default VRF are only handled by a socket not bound to any VRF::
>  netfilter rules on the VRF device can be used to limit access to services
>  running in the default VRF context as well.
>  
> +Using VRF-aware applications (applications which simultaneously create sockets
> +outside and inside VRFs) in conjunction with ``net.ipv4.tcp_l3mdev_accept=1``
> +is possible but may lead to problems in some situations. With that sysctl
> +value, it is unspecified which listening socket will be selected to handle
> +connections for VRF traffic; ie. either a socket bound to the VRF or an unbound
> +socket may be used to accept new connections from a VRF. This somewhat
> +unexpected behavior can lead to problems if sockets are configured with extra
> +options (ex. TCP MD5 keys) with the expectation that VRF traffic will
> +exclusively be handled by sockets bound to VRFs, as would be the case with
> +``net.ipv4.tcp_l3mdev_accept=0``. Finally and as a reminder, regardless of
> +which listening socket is selected, established sockets will be created in the
> +VRF based on the ingress interface, as documented earlier.
> +
>  --------------------------------------------------------------------------------
>  
>  Using iproute2 for VRFs
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


I don't have the cycles right now, but if you or someone else has time
it would be good to look at ways to improve the current situation.
