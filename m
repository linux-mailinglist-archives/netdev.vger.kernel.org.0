Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EEB29129F
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438208AbgJQPX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 11:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438111AbgJQPX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 11:23:56 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E9FC061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 08:23:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k21so7636646ioa.9
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 08:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aElHXckNR7hO+6U53hqiTIX2MJmmjyOXCVvamWpuQxY=;
        b=Hlx5ypGU6SddZMJrhCDbHkFO/ILc+N+RsGCECXQY88gb1h+pYuPU4xWxG1b6SndHBE
         NpYnThgTg9P1U6IVS+/LqT5KANEZfIYINExvgiPK+DNcsEE1ChDYoFKcLtTBbMeO+gUS
         INliSSZ1pRqZjAvr/nuDwhu0WVKxrtVW3vLkc7+PIOP3APHGLkz6TGor0PgK+tTGTl/m
         FSgYoNNDcqVVE1eouLQU7wXvB2BlYjELpzMxHjH8E+toR75tdld+kRu+jc29Achoimx0
         1Ng421L0P/oToxlZSRqROKjKq5SmaPurbSaZ24p9tRBAwv6FlxrRlIPa9hxeRb6Pzz8i
         p6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aElHXckNR7hO+6U53hqiTIX2MJmmjyOXCVvamWpuQxY=;
        b=CtBLaBPPJm468HMdWRwA2mM80m9c/Gwmc9fj5bWbI9jH4hHNStfV/wQl/RqubQoqx4
         Fvf3vkVQ1joviGC5phvVQeRosavfBz4FBWm2dNGSw3tSfHTHqp/jIzGt/umV5ZJ5lDKs
         GuQ72eFuX3BN/+BUDXX29O65o2Mid2AJRT98Tzm703VhruZG4wRthLhr2FBQ5uLQTThh
         E1ls6GnkxNzPVNp/huWDqShAdap7j6a2W+tKrdL5x2EyKv/lQ7wvogjqriExdx8GEea4
         jbMyuESCasuZ6wE9co3BZKvq2mb09gMfNvA2afUDQApTEoit/lb4CkAcFSPu+W+EpSPV
         h8ag==
X-Gm-Message-State: AOAM531u/bPv7JC9L9Ds3QuHS3m4q1JcQ9Xy+ZgewhJSxnp/hoAlqQMF
        O07z5bB48r3vaQ37XFJW8oA=
X-Google-Smtp-Source: ABdhPJz4THr8awkV5pMPX8/jAtLkXPL3rLkab95QmCepPZhATUijgBAtD3+Q/REdw9AkiqV3lstcTw==
X-Received: by 2002:a6b:5c06:: with SMTP id z6mr6015753ioh.49.1602948233868;
        Sat, 17 Oct 2020 08:23:53 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:685f:6f0f:2fad:a95])
        by smtp.googlemail.com with ESMTPSA id m13sm4978442ioo.9.2020.10.17.08.23.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 08:23:52 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 2/2] m_mpls: add mac_push action
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
References: <cover.1602598178.git.gnault@redhat.com>
 <622d70e7bb6158c6f207661dea8c47e129f16107.1602598178.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5804f20b-b8ea-9f02-7aac-129d35f46a2c@gmail.com>
Date:   Sat, 17 Oct 2020 09:23:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <622d70e7bb6158c6f207661dea8c47e129f16107.1602598178.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/20 8:32 AM, Guillaume Nault wrote:
> @@ -41,12 +44,12 @@ static void usage(void)
>  
>  static bool can_modify_mpls_fields(unsigned int action)
>  {
> -	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MODIFY;
> +	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MAC_PUSH || action == TCA_MPLS_ACT_MODIFY;
>  }
>  
> -static bool can_modify_ethtype(unsigned int action)
> +static bool can_set_ethtype(unsigned int action)
>  {
> -	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_POP;
> +	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MAC_PUSH || action == TCA_MPLS_ACT_POP;
>  }
>  
>  static bool is_valid_label(__u32 label)

nit: please wrap the lines with the new action.

Besides the nit, very nice and complete change set - man page, help, and
 tests.
