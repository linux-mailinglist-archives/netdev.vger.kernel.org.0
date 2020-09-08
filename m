Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468FD261FF9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgIHPTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbgIHPSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:18:35 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE2BC0A3BF1
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:55:08 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j2so17347957ioj.7
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+OhoPAbESPKfyNSNALuaJzKOuwy+1BTpjbLG3GUjALg=;
        b=T9JgonxhIxGUTN4REsR2nFnZpBXk/EOSMqAsCp7WGAx9mv78fOBYeRPxSwJhcEjdA8
         eCA/9nKzOgYu2S2i8O7AHFtZcSsWPUAcm4t9T5gwd/GXA1lulZi3N0ww0bUihqYfTTOy
         uqyx9N/o/RWUMYrS48bFk6yvjZK0W02dbUFRdGPx5c648ibgAqaLe5hTLHBb19K/seDh
         Z21mwvk7Mct4ZSJDRTw0zm49XRoDGHcELkRTw+oHzHl/zN0BSyEkB487sJW+8q5rABGI
         akiq+ztLLjV4tM8JLsB7ynF947RQgk642sjwxXieYI416IsuJDpcCQs+c1qVn4SE396I
         4rbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+OhoPAbESPKfyNSNALuaJzKOuwy+1BTpjbLG3GUjALg=;
        b=d82J4eUhUbpAv+Z3Z/IxhyYzXTAftt73zfeww5nbCZ1VhRi3/W+W0Gjal7/V7UhCqk
         /nN0AeSx97pxI1JMJJiMdh7IJGC2XHYi43XeLgN2HsWWmtLtGtYpnBpvs7WfFtiUED22
         isNofwsePmbWjvCihAgAAVymiyDgdW5TW9zs1DGp82pwhFB7Mccqae/JDSlgXrFgSoIu
         D7AkQ7YYj4vqh/yotPDoIYFQUhQPIMR8goNyMhlUj4zqsXqDmt2+2nc78I4LQdOuOLy3
         VUtfNZfgaACl21hrPl+6iqQhMl2ug8bnOteElkJhgalLUpqhfoo7Tvls4oQa0CBNxNCn
         KRTA==
X-Gm-Message-State: AOAM532XHLw4DKZGL27pQgEwyD5JcWSZqrAY8EjELBI2ihYzXRWrIPaI
        lGpDvwwg3Qvl4zZv6rS575k=
X-Google-Smtp-Source: ABdhPJxLVRQ0i8cT5BcaFS0zNbuz0yTKSE7sAyKcSivhMGT/YsEAlnvgph8Y7CpMn80unef8QX0/FQ==
X-Received: by 2002:a02:c914:: with SMTP id t20mr8229868jao.117.1599576908013;
        Tue, 08 Sep 2020 07:55:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id 137sm8911754ioc.20.2020.09.08.07.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:55:07 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 07/22] nexthop: Prepare new notification info
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-8-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1c27afdc-870e-f775-18c9-a7ea5afee6dc@gmail.com>
Date:   Tue, 8 Sep 2020 08:55:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-8-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Prepare the new notification information so that it could be passed to
> listeners in the new patch.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 108 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 108 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

one trivial comment below.

> +static void
> +__nh_notifier_single_info_init(struct nh_notifier_single_info *nh_info,
> +			       const struct nexthop *nh)
> +{
> +	struct nh_info *nhi = rtnl_dereference(nh->nh_info);
> +
> +	nh_info->dev = nhi->fib_nhc.nhc_dev;
> +	nh_info->gw_family = nhi->fib_nhc.nhc_gw_family;
> +	if (nh_info->gw_family == AF_INET)
> +		nh_info->ipv4 = nhi->fib_nhc.nhc_gw.ipv4;
> +	else if (nh_info->gw_family == AF_INET6)
> +		nh_info->ipv6 = nhi->fib_nhc.nhc_gw.ipv6;

add a blank line here to make it easier to read.

> +	nh_info->is_reject = nhi->reject_nh;
> +	nh_info->is_fdb = nhi->fdb_nh;
> +	nh_info->is_encap = !!nhi->fib_nhc.nhc_lwtstate;
> +}
> +

