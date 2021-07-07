Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390CF3BEA16
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhGGOxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhGGOx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:53:29 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF1BC061765
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 07:49:49 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id n99-20020a9d206c0000b029045d4f996e62so2471923ota.4
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 07:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ix2VfgIsIq4xN8KU30jdPLbyzLuICqtgWPTHfLkejoo=;
        b=srsGb24MDZ+xITPY1sBrn5ljiaa3G1WBng56220/QXT/cz7/jKpgePkX93lD2q8CfF
         E9/oZRhOb2WuaLgF6kk61J8bUymaNykV8bOQm7bIJ0ltsuT7bhUbrloMkP01bCUp3zJr
         WExxOvgKoXTKdlJ79hQv2C1Jv7HakR02qy1/3iME2PHPjPfTt7v2f3Z8ssw67q7+sAU3
         gCIx8DHOuo+lDM3eQ/C9QbQUnIi6e5NudWuqGV4w+jHSkIIlaUtmA6tmudbbxqA6j9zZ
         J65kLYGgj+KJERW4AQvR46dHmSksqFCW/xaD7FTLyX/Drf8sjdENenCNTJFUw+2YGViw
         k4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ix2VfgIsIq4xN8KU30jdPLbyzLuICqtgWPTHfLkejoo=;
        b=RZ7M1dp89k8U2d38lXwY8+T2gLpCwl980qtt8bARMTipSaOAADO9Wdg4H+Sx+2adFt
         d9a4ChyBsmEXYeWwmofJRy/csfJupW4vzyZFLgGbX/pAnANVwedrqnzD5zqmaDqlmWHy
         1b0FOHrnqXjsVT0ppvdYtAB0QstHf9LGJHWETvMMwwQDjUpLUe381Zn7WEcFGhZkOFSK
         knlQS6mKxz+vruJ8FPwEOMydmvxGvNNSRL6+IXO40xVBKgcVU19gMxsf+bgbYmlWv4Zz
         tU1CUcEkf74cLXlh8twXUhN9btrg2xFHGja64hi9KFFun6JWT3fp0zpmS2lviSTgoxKV
         2bow==
X-Gm-Message-State: AOAM530eqS071cAvi7lh1ZnckwAzMjzzgJ+JI4sv40tzylBepJee8Xcz
        DFzm1xO4APbT8Eoodjym/AY=
X-Google-Smtp-Source: ABdhPJyugs5eGOCXPBffnc2Gvun92XLLAGRybMJDjOEryVWsOi34q6Ylz/EgoGNPNgVJFQdh5TAiXg==
X-Received: by 2002:a05:6830:916:: with SMTP id v22mr16611175ott.201.1625669388832;
        Wed, 07 Jul 2021 07:49:48 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id c64sm4250366oif.30.2021.07.07.07.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 07:49:48 -0700 (PDT)
Subject: Re: [PATCH net 1/2] selftests: icmp_redirect: remove from checking
 for IPv6 route get
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>
References: <20210707081530.1107289-1-liuhangbin@gmail.com>
 <20210707081530.1107289-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <51db3cbf-8e9b-fa9e-4cd4-5803e9a67e21@gmail.com>
Date:   Wed, 7 Jul 2021 08:49:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707081530.1107289-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 2:15 AM, Hangbin Liu wrote:
> If the kernel doesn't enable option CONFIG_IPV6_SUBTREES, the RTA_SRC
> info will not be exported to userspace in rt6_fill_node(). And ip cmd will
> not print "from ::" to the route output. So remove this check.
> 
> Fixes: ec8105352869 ("selftests: Add redirect tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/icmp_redirect.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
> index c19ecc6a8614..3a111ac1edc3 100755
> --- a/tools/testing/selftests/net/icmp_redirect.sh
> +++ b/tools/testing/selftests/net/icmp_redirect.sh
> @@ -315,7 +315,7 @@ check_exception()
>  
>  	if [ "$with_redirect" = "yes" ]; then
>  		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
> -		grep -q "${H2_N2_IP6} from :: via ${R2_LLADDR} dev br0.*${mtu}"
> +		grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0.*${mtu}"
>  	elif [ -n "${mtu}" ]; then
>  		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
>  		grep -q "${mtu}"
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
