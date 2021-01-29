Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9635F30841E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhA2DHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhA2DG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:06:57 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD16C0617AB
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:05:54 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id e70so7331707ote.11
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0jemj/tjNgRTarSU8CSpliCbrUUkG2Lvec8/bdyQHqY=;
        b=ssLNbWnJaw2WrAos5Wl8lVfgnRFGd/+JQHFj5hEHHEHGxV48RiLKG63cS6aJj4/6Jx
         pSVuorfQasiCpld3omU3IVpGYUUetjG7Lww6+eLW1J/Cjm4qJOPGJUTbJ9H0b2DVIXDX
         eHN+Fji1jlVxCDaP92vOrwwP/3ElqkjJx19WZb2a0GKAu7/yz2/oxJbHao9gymWIgD+V
         r4QXzo/sQhpjP+HIUl3UG65FtXgux/ATwpI4qx63rYNRaEkDE7ovMbpT12XD5IwN3w0+
         t6TYod2dPa3WcsjQhtbsHWV3NBBcR0Qje85f7UK3ht46UiZC1xAH+10uMGDUxQmsPgkh
         JLhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0jemj/tjNgRTarSU8CSpliCbrUUkG2Lvec8/bdyQHqY=;
        b=C8R6pLDMNDuEu+0qwmGDPeRggDLga+cvpG6jE6pSt4aEPMp6rv+fGg/YDsw7W1zw+g
         ELb4wyM+cnt6+Fz+1TyRN18jVTjlB1K4xs9a7keXnVse521L1KdyBQ64ZhNovjA88wMM
         KUwgOHVO6ZR5P98pE5ymL9jSINtlUTA+4AqwryK3xqjTTSRooIlPs6WQeAZWqCtn6vz1
         Xlm+H3xiSNmQUTrzszlmezzkMGvEqw5OJLmqk8btbGsgWBlo1ffYN6/xSm1zVGDTG76h
         CPut+x6sNA0b0PLs9JPjKXXBQD9YJpirDT+4WQ22S/K7w6+d7AWKKNErOOjrVOT2RcTO
         cPYQ==
X-Gm-Message-State: AOAM532RnpWFWrS6cF0kjP22vNhQVg4ANiF4kxXA12LOtoyTDvvM9DQt
        sWLPQRCm6r72mGPUHhHdois=
X-Google-Smtp-Source: ABdhPJyNp9miVOuCQRM0gVh7CgJ1R4mf5d/HNaad1bbhHkPXgHISVSVAh22xN3sow9eVeIjwgZ5iDw==
X-Received: by 2002:a9d:4b05:: with SMTP id q5mr1714714otf.228.1611889553612;
        Thu, 28 Jan 2021 19:05:53 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id t16sm1659794otc.30.2021.01.28.19.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:05:52 -0800 (PST)
Subject: Re: [PATCH net-next 01/12] nexthop: Rename nexthop_free_mpath
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <9471a24d9c43c2ace3e68c88165c5212ae6944fa.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9d447916-bf35-c11a-c7a6-3c8d4b077f43@gmail.com>
Date:   Thu, 28 Jan 2021 20:05:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <9471a24d9c43c2ace3e68c88165c5212ae6944fa.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> From: David Ahern <dsahern@kernel.org>
> 
> nexthop_free_mpath really should be nexthop_free_group. Rename it.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


