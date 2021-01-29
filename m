Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3530842D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhA2DTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhA2DTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:19:22 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F35C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:18:36 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id n42so7361408ota.12
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cIoPVq/gAtBSXIMwIfczRXEZIN3PLDOjnThaNxz3Iyg=;
        b=dIcD6dnEEFpYsnDVbV5J/4wsTZWx8OKFv6xOkrmHdSGCkP4SAwj870/HuUppQZ1LrB
         YcH6YiZuiockrR5AfFYcYSF0SMGKG8FP68xHDeMvFbEPjaafwM/KYonomircaNR/Xt9p
         DYCRQALaBRELAESj88yu/P8R6tnbVsu0cbpAIQ9andEPxEib3hmXt+HUWtTj//xeYBYx
         O1kfb1ZJc+ZqhItMyNyg/D/dxFxEC3Jt15s7Y7whj/paPDzzn7wT7aNWlnVbD0Oxh+p2
         oi6rM3/Vc6B7VtLjNRGg6cH6wYxQ4WbWreceC4KH75qlpcuXezfaGjbxUez/7/YSg/Y9
         y4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIoPVq/gAtBSXIMwIfczRXEZIN3PLDOjnThaNxz3Iyg=;
        b=bS8DWVW8IgDVmIqdBxluoqBTIJVQKJ79nwHpxmF/3o4iksuZSKslhb3MJ8W6OwESwx
         BbnuFucgNgYlOSEAY7DnzvL8I9JlocXBMxRtgqgJk9kOR0MiwKRu5uOhPSyQco/YJqDR
         VzTaB5so1aUuUoHnpWz/AcyfJArdUKyK1HA1beP2mM9j+rQhhLuQv/NDd7dqmXcpHc4K
         oKq5wRXNnCNoT0j+MDcfbD6ifS5qaTyHta56YkRtGS05XFcTrEy0dZy2M3hgWv+wZpI6
         la2RAnN8v7F3ASQ9JjYSw328jNftYxhUAPUNh8FLX0JPtroYDTRJMfy6uf4V+qDdrJiC
         biUA==
X-Gm-Message-State: AOAM532uZc97cLCOc9F+JxZqP2YGJuWIhcZvf/HP6jCJ0XkQzmN0nZsi
        A5N4G8oDmVzzJNM6HivGaCn4KkuvNFw=
X-Google-Smtp-Source: ABdhPJykR8Gt4O4tpSIDpcN0NNl5NDdzAliFQ87Avkq4J9tnVnGAiXHbtX1okbMW22bVL+dkRZdu6g==
X-Received: by 2002:a05:6830:1084:: with SMTP id y4mr1837830oto.9.1611890316306;
        Thu, 28 Jan 2021 19:18:36 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id b21sm1871929oot.34.2021.01.28.19.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:18:35 -0800 (PST)
Subject: Re: [PATCH net-next 09/12] nexthop: Strongly-type context of
 rtm_dump_nexthop()
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <540e18781f82a0f0b0482b10e7180a57369e8388.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fda6a9ba-48c1-c4f1-b1f9-05346e7f96c3@gmail.com>
Date:   Thu, 28 Jan 2021 20:18:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <540e18781f82a0f0b0482b10e7180a57369e8388.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> The dump operations need to keep state from one invocation to another. A
> scratch area is dedicated for this purpose in the passed-in argument, cb,
> namely via two aliased arrays, struct netlink_callback.args and .ctx.
> 
> Dumping of buckets will end up having to iterate over next hops as well,
> and it would be nice to be able to reuse the iteration logic with the NH
> dumper. The fact that the logic currently relies on fixed index to the
> .args array, and the indices would have to be coordinated between the two
> dumpers, makes this somewhat awkward.
> 
> To make the access patters clearer, introduce a helper struct with a NH
> index, and instead of using the .args array directly, use it through this
> structure.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


