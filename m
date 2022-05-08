Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F2451EEBB
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiEHP47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiEHP46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:56:58 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146BDE0A0
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:53:07 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id e3so12937777ios.6
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 08:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G3kAIk2eVI7vXrJ8umDiVGEpncB62dULZJDkc1tyXQo=;
        b=C1rcQZusyF5AZAVlEHTN6JipE8iHf5DLRCSgL9MMncNZxrhyJHtQILmOFZcGuTlpIX
         1QSrGvMoko8B1SO41h1ebX5BbHKPwEBVpxXyfnpsnOaMTOMBeTzyCuPtasA1q8HvAKJs
         SwFLDgKof82QPSdIAz2AbwnByIEz4F7VI2I+m7w5DJMQZPPvTpBZep/FeTb6VsRV3k1B
         vO0uWRzKgfIKatwA6VObPoZYDBv4dYHYEs5qiIaQuSrpZtT/JHPPaLyqYOj0+vEkH4EL
         NlWu+1GNVNhct+yJ3+6dtlwPHtT+m0iGBk+/eIlnosN/I0a9XyD9yyz9FjNWxzLrg4X8
         RMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G3kAIk2eVI7vXrJ8umDiVGEpncB62dULZJDkc1tyXQo=;
        b=HUCJK+XHvk3UGrcbiWGuIMu3jnuzxwthOeHk4cti/zrvCSTrMAgt0Xlmrhlx2qjMcV
         Fakyz/YdcmtntNW9TOOfYg3EjNf6obfN/lBfH1yZfIcLvgB2k7eWliOcGPMFdJLRNGK1
         kdpMRLwVZTtRcYpCnlahQkrYdosIMdhI/7k82pqmdej4b4fjys5MOFvkCRGvt40cv6b/
         MuhsZwvdLSs+gyBBijuPOPSPSimJCd0fOgJkWArE4tDIrZA3fvS/QdtDKucMlxKY/aUD
         kFFd4A7UcIk6JQU+ql/Y6Zii6cYOO7H6XQ+PdD5pzwmHgV3h99U/FS1muPU0Wl1ETkLj
         I90A==
X-Gm-Message-State: AOAM5321ql5+lm0jiCXw/d0zW4KcKmknbSdRH8AzMcqw1l1RgujZChYT
        8tNTy3Z/qww2iP4Ujat/1k5iFrYQPfY=
X-Google-Smtp-Source: ABdhPJw9BLxFGDi36pfR6y8XeKeJI4N07vBHVy1ySHGySpkMIZMqfZLE0LOtXSV0KHJwcXabZOaaOQ==
X-Received: by 2002:a02:c88d:0:b0:32b:a357:71bb with SMTP id m13-20020a02c88d000000b0032ba35771bbmr5463185jao.203.1652025186411;
        Sun, 08 May 2022 08:53:06 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:c98a:a98e:9d55:fe1? ([2601:282:800:dc80:c98a:a98e:9d55:fe1])
        by smtp.googlemail.com with ESMTPSA id o27-20020a02c6bb000000b0032b5e78bfcbsm2938044jan.135.2022.05.08.08.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 08:53:05 -0700 (PDT)
Message-ID: <7da08a10-7d2d-4b58-821c-bec68bc55c87@gmail.com>
Date:   Sun, 8 May 2022 09:53:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH iproute2 net-next v2 0/3] support for vxlan vni filtering
Content-Language: en-US
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        razor@blackwall.org
References: <20220508045340.120653-1-roopa@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220508045340.120653-1-roopa@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/22 10:53 PM, Roopa Prabhu wrote:
> This series adds bridge command to manage
> recently added vnifilter on a collect metadata
> vxlan (external) device. Also includes per vni stats
> support.
> 
> examples:
> $bridge vni add dev vxlan0 vni 400
> 
> $bridge vni add dev vxlan0 vni 200 group 239.1.1.101
> 
> $bridge vni del dev vxlan0 vni 400
> 
> $bridge vni show
> 
> $bridge -s vni show
> 
> Nikolay Aleksandrov (1):
>   bridge: vni: add support for stats dumping
> 
> Roopa Prabhu (2):
>   bridge: vxlan device vnifilter support
>   ip: iplink_vxlan: add support to set vnifiltering flag on vxlan device
> 
> v2 : replace matches by strcmp in bridge/vni.c. v2 still uses matches
> in iplink_vxlan.c to match the rest of the code
> 

fixed those as well and applied to iproute2-next. We are not taking any
more uses of matches(), even for legacy commands.
