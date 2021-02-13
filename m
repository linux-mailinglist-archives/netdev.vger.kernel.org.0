Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B031ADB9
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBMTRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMTR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:17:28 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47D6C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:16:47 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id a16so2300254ilq.5
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f9spF8VW2ptdvPCIqc/q8Ka4ev0vK3BIoz8aLJqywFk=;
        b=PjZ2gLmidzzufv2S7Z1q8UwAevEW4ioEZ29vcwGD39hc7zVz/6IZzfKfOd40wkh/PX
         4EeIYZOzKMoPBbLcXeWn/Jz+4Pvb5cSIZTCIht8wMhSSoWuFtypNDD1wPeKG+aAfZ/x/
         CMNyoxol+lvxENU+2xV50q6PfgRyovuec2F+eaR/dBxtIpLiuga9cnqn5SC0AGec3U7A
         KGtt+q+YADTk7KtfIsPv4RywFEwgjM3ozjQKsiq6eypNE3nG2JhIq1CtR+mKlDRWIdG5
         /PMED4TDYalBsUkfXBy+p7PNG8QucupB5qQWtQUNvzTzd9sL3xYWyMi2DgVCAdz3feEZ
         x9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f9spF8VW2ptdvPCIqc/q8Ka4ev0vK3BIoz8aLJqywFk=;
        b=i8U3ffqPB+FD16HTafYcqmcdBOn/kpFX1bWPhI1OjHh0rSnGSIDKyZXGPWUmu2TtV6
         5++nlrPugdQndDrUOzSoQxVDPucGM9gwtS+06sQQ0Kl2Vxb71lPR2JgJUkUmfyeaP+gx
         1mLMFJTr4fEhV0ieiSK+X2nylxCikQDvWr0fYmwozaKAg1YMRQOti5tYUyShsEEPbsIX
         BWDmCOj0okDl+g6FeqGN9a+4frdak1ehczpu4Whkbq2nxH6Y8lTqF3JKmh/jcKKHzFXA
         /uYefvNd4DPRZmejkWk3MCAH23Lf/Mv7a37ihHOcGdcEpcjVDWiTWcFB6AcrcdgrQu9V
         20ow==
X-Gm-Message-State: AOAM532/lQ2XOJT8r1E4brg+idu08TLG0g2u12mpdyyOvdsTOd/0pCUr
        nNnnHICVcFLBP851dZMVDWk=
X-Google-Smtp-Source: ABdhPJwJ0nS8BkgTMj10zCbzW1QT/gN34zHA0+k/juJ5gaVpB82rA5zN1+uqfE0chQyAjckdjQ75/g==
X-Received: by 2002:a05:6e02:b25:: with SMTP id e5mr7157873ilu.37.1613243807414;
        Sat, 13 Feb 2021 11:16:47 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id y11sm6421835ilv.64.2021.02.13.11.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 11:16:47 -0800 (PST)
Subject: Re: [RFC PATCH 03/13] nexthop: Add netlink defines and enumerators
 for resilient NH groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
 <893e22e2ad6413a98ca76134b332c8962fcd3b6a.1612815058.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d3a64aea-d544-cd58-475c-57e89ea49be5@gmail.com>
Date:   Sat, 13 Feb 2021 12:16:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <893e22e2ad6413a98ca76134b332c8962fcd3b6a.1612815058.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 1:42 PM, Petr Machata wrote:
> @@ -52,8 +53,50 @@ enum {
>  	NHA_FDB,	/* flag; nexthop belongs to a bridge fdb */
>  	/* if NHA_FDB is added, OIF, BLACKHOLE, ENCAP cannot be set */
>  
> +	/* nested; resilient nexthop group attributes */
> +	NHA_RES_GROUP,
> +	/* nested; nexthop bucket attributes */
> +	NHA_RES_BUCKET,
> +
>  	__NHA_MAX,
>  };
>  
>  #define NHA_MAX	(__NHA_MAX - 1)
> +
> +enum {
> +	NHA_RES_GROUP_UNSPEC,
> +	/* Pad attribute for 64-bit alignment. */
> +	NHA_RES_GROUP_PAD = NHA_RES_GROUP_UNSPEC,
> +
> +	/* u32; number of nexthop buckets in a resilient nexthop group */
> +	NHA_RES_GROUP_BUCKETS,

u32 is overkill; arguably u16 (64k) should be more than enough buckets
for any real use case.
