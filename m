Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F14D4305
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 10:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240582AbiCJJCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiCJJCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:02:51 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7082A1375B7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:01:50 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a8so10557202ejc.8
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2WVBVRe9xgmB+2TNgF8MESLm2w/bT3buZVewbJyS+zY=;
        b=Yudg+I+jiLczdclrDpea3Qml+cfLh1+4Dngt6p7rj3giEsifwq0pxXcwbwHg/Oil+o
         vS2jT+sNw4R7By6P2qyrnReXr1JaIyJyF8wdYvJEubOEu0altU/wgBFC/3gVPCdo/CsV
         53QG+x6eKyS3BAYcPkgsF5Vw/Px3r0Uy6LfaSCN5GYHW/gynwz0MFQTFttWQ3jGLRzet
         B+ncdQMrv4fTgWlJI3crEtNPqlv0E2VEc92FkepAZMfHbxChWApDNg3hCFv+vkhoDc8P
         FKRfPfDu3XJKQrgHkAmc5AyUZ5uURPrnnLQ501ki41zRbF3urUHGNy3v2Ga6118FNZjo
         AxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2WVBVRe9xgmB+2TNgF8MESLm2w/bT3buZVewbJyS+zY=;
        b=EOGiL9Th/Zz9lZB7dHJkY8t0Sx52wjTZdvLQE5LA6lshFdKdonPcXJUoxtCnnf3+ZF
         /WFKmjQ28CYy9n7n85DG8Hy+WVDl/EdaFBHe1/euZNEMh+H7Vmwjh6J9/4ZvJixlS+fW
         ZossdTKl8yrTYn/E1Chyj1F1Km1oiiWwt+qRW1s5vWhqQy3gdrk5u/4C8VWkP9hTM+Jl
         FNXraxkS0NXymgRDWTzruCkefXl07zYbqgPq09wkJEcLnOPn4r9F5GLFxy1Jzw4nUhfx
         EtVBUKufagW7EuKqo/QPvlvCgxJtfvV+b2Ilnkw+Cy1Hcnc71ghj+SBI12c82nQUqkKO
         0v8Q==
X-Gm-Message-State: AOAM531aWUEASJWTOweKCmDYwwUY1PuxcVJJwnUAjvF38Z6Z2lBWWUnP
        mqLbk5VsG1abG4XOkkFSXOV4EAMNt+SkblhDiQk=
X-Google-Smtp-Source: ABdhPJxr2dhetF/cc53dZxMgbFjknx/9cDxwQ3cAzAuExWzjMdqeeBPqyjKvSzg1qJGLJ7Ky5Qzkug==
X-Received: by 2002:a17:906:d554:b0:6da:8a8e:2f2 with SMTP id cr20-20020a170906d55400b006da8a8e02f2mr3298007ejc.434.1646902908481;
        Thu, 10 Mar 2022 01:01:48 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id lb14-20020a170907784e00b006d5c0baa503sm1545787ejc.110.2022.03.10.01.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 01:01:48 -0800 (PST)
Message-ID: <070b4dff-3d76-4b65-8f05-eb32e1f91743@blackwall.org>
Date:   Thu, 10 Mar 2022 11:01:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next v3 0/7] bridge: support for controlling
 broadcast flooding per port
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20220309192316.2918792-1-troglobit@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220309192316.2918792-1-troglobit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2022 21:23, Joachim Wiberg wrote:
> Hi,
> 
> this patch set address a slight omission in controlling broadcast
> flooding per bridge port, which the bridge has had support for a good
> while now.
> 
> v3:
>   - Move bcast_flood option in manual files to before the mcast_flood
>     option, instead of breaking the two mcast options.  Unfortunately
>     the other options are not alphabetically sorted, so this was the
>     least worst option. (Stephen)
>   - Add missing closing " for 'bridge mdb show' in bridge(8) SYNOPSIS
> v2:
>   - Add bcast_flood also to ip/iplink_bridge_slave.c (Nik)
>   - Update man page for ip-link(8) with new bcast_flood flag
>   - Update mcast_flood in same man page slightly
>   - Fix minor weird whitespace issues causing sudden line breaks
> v1:
>   - Add bcast_flood to bridge/link.c
>   - Update man page for bridge(8) with bcast_flood for brports
> 
> Best regards
>  /Joachim
> 
> Joachim Wiberg (7):
>   bridge: support for controlling flooding of broadcast per port
>   man: bridge: document new bcast_flood flag for bridge ports
>   man: bridge: add missing closing " in bridge show mdb
>   ip: iplink_bridge_slave: support for broadcast flooding
>   man: ip-link: document new bcast_flood flag on bridge ports
>   man: ip-link: mention bridge port's default mcast_flood state
>   man: ip-link: whitespace fixes to odd line breaks mid sentence
> 
>  bridge/link.c            | 13 +++++++++++++
>  ip/iplink_bridge_slave.c |  9 +++++++++
>  man/man8/bridge.8        |  8 +++++++-
>  man/man8/ip-link.8.in    | 20 +++++++++++++-------
>  4 files changed, 42 insertions(+), 8 deletions(-)
> 

Thank you, the patches look good to me.

For the set:
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
