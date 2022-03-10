Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8294D426D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbiCJIZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiCJIZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:25:47 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BFD13548B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:24:46 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id k24so6690489wrd.7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=klp4I9KWkRZtURbIPgUKipxadJ2L7KUubiYtCCXhet8=;
        b=doyor3/AuhfIZK/L7sQZ/+IDCle7JEW3ZZhJGS2VrkZGOdxtQFPjOx2L3FiiN/g4P5
         zROj3zSL9QlripkaEPNFHXoutzfpjmhlfO8HMaI+ZdOQyGYL5de9ZnmDwPcxk4cr29i1
         V5WHM3UVJtfsbufSE6xapWxKxv/DqSrXblZzRCINJmHrv2cmvR4a/95PykoS+L0+qgSs
         pI7mc+1MSy1Rvi6jZ3bEt/vMOs/RTjj1s0XJ0Sd7ez3feLNBTkO4htSuMbUvt7YQoDmB
         JRPLlNhJGxxhksd6MtJH9+27Tl/YSEfHEo+venhjge1gZKWCXsPbEGI7cNELOiTdTvLl
         F20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=klp4I9KWkRZtURbIPgUKipxadJ2L7KUubiYtCCXhet8=;
        b=bR6VgsME+up4B1+gV52Zzd9rYJay6pdduRVEAaRcDiFtNqVzYtZRFXS7V7uR4gmjrA
         FalYgDJKa/538moMscfAR7iWUlwYIeBE0m32uy+tIHrxsOqXH/4rIOKXUrgEop6JSiad
         OS3Y/PKhc5Z8u6NCYOTvHKfAGKYKgMgL6rrQD3X3w5hBD+0r6MXdyjaLfa1krdpvLOJu
         wy0DNnbb1YdfvcnUbABwlsAhVxJWT3fWTRKUsBS5SEzevPN8Cecq0RjzOxLRDbTXnx2a
         W7gyIWDJkvGCyKrgAW/PRyKx1PsUF7NsSaVETuhgNsrHfibJJRp5dYkz3PbzzhaknXyh
         aSdw==
X-Gm-Message-State: AOAM532TgBqr2IsgtvlnrnqSVHmLWDyIBkt6Y+a7+RI1ri+vpMvlGmn4
        44lxY1j7an7Mw1Ng9shPwdEBsQ==
X-Google-Smtp-Source: ABdhPJwDCznlJL4RxC6gDSkv29wEtMcr/bHK2tZPHoGGURVO6IItMV87wC5TC1u69sVEGDY3GWLGKQ==
X-Received: by 2002:a05:6000:18ab:b0:203:731d:1ac1 with SMTP id b11-20020a05600018ab00b00203731d1ac1mr2567964wri.411.1646900684929;
        Thu, 10 Mar 2022 00:24:44 -0800 (PST)
Received: from ?IPV6:2a01:e0a:b41:c160:2863:9561:cedb:112e? ([2a01:e0a:b41:c160:2863:9561:cedb:112e])
        by smtp.gmail.com with ESMTPSA id p22-20020a1c5456000000b00389e7e62800sm52403wmi.8.2022.03.10.00.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 00:24:44 -0800 (PST)
Message-ID: <3371a7f4-e882-96ac-37ff-6492caced7d6@6wind.com>
Date:   Thu, 10 Mar 2022 09:24:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
Content-Language: en-US
To:     Ilya Maximets <i.maximets@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Aaron Conole <aconole@redhat.com>
References: <20220309222033.3018976-1-i.maximets@ovn.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220309222033.3018976-1-i.maximets@ovn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 09/03/2022 à 23:20, Ilya Maximets a écrit :
> Few years ago OVS user space made a strange choice in the commit [1]
> to define types only valid for the user space inside the copy of a
> kernel uAPI header.  '#ifndef __KERNEL__' and another attribute was
> added later.
> 
> This leads to the inevitable clash between user space and kernel types
> when the kernel uAPI is extended.  The issue was unveiled with the
> addition of a new type for IPv6 extension header in kernel uAPI.
> 
> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
> older user space application, application tries to parse it as
> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
> malformed.  Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along with
> every IPv6 packet that goes to the user space, IPv6 support is fully
> broken.
> 
> Fixing that by bringing these user space attributes to the kernel
> uAPI to avoid the clash.  Strictly speaking this is not the problem
> of the kernel uAPI, but changing it is the only way to avoid breakage
> of the older user space applications at this point.
> 
> These 2 types are explicitly rejected now since they should not be
> passed to the kernel.  Additionally, OVS_KEY_ATTR_TUNNEL_INFO moved
> out from the '#ifdef __KERNEL__' as there is no good reason to hide
> it from the userspace.  And it's also explicitly rejected now, because
> it's for in-kernel use only.
> 
> Comments with warnings were added to avoid the problem coming back.
> 
> (1 << type) converted to (1ULL << type) to avoid integer overflow on
> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
> 
>  [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 pipeline")
> 
> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com
> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
> Reported-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Thanks for finally doing this. I also suggest it months ago:
https://lore.kernel.org/lkml/a4894aef-b82a-8224-611d-07be229f5ebe@6wind.com/

Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
