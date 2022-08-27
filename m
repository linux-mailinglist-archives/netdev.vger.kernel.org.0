Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573695A35A5
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 09:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiH0Hjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 03:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbiH0Hjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 03:39:43 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B893C926A
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:39:41 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a36so725697edf.5
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=pA7MyAsJLaEB/gROdjAtr0RToMaQCvrWDWTLRH5BdCY=;
        b=iG+HX4fsIPXRjBMbc6LyyJlD6RSnNtls71gHSRKiTJ85U4MOhZf6JIsz8m2hpnI1Wc
         +EWojqeVQ5FGf0xanhi1bLRxYXMwoHw5SQMbXein6FCszO509Ig63q3DrZ6l90+dZInr
         SNPXe7w6pU8H5odi82l+cGt6ziiA1nx5h/kpLgRmys9kn0CcDChM8el57/g2r720d4an
         TNyW35Rg76kDnqvvmyXJs3f7H5ZttN/wIz5UjKrwdmEpH0ZCwDGxZGNZwk65MVCsJkCu
         H8VkNA+ynagxDnvRSk1+UI5XGYosE4Rk69OZJIazMkSkf9UFJkbO9S3JVwTJkh9BtlFB
         e5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=pA7MyAsJLaEB/gROdjAtr0RToMaQCvrWDWTLRH5BdCY=;
        b=VHpKbuyQgBc4wg7XqvBJ0aM09GwRBn64NcEaUBcRoVbX3LLPGfPpwZRrvfYwKKDC4S
         rHv2KGx+r4kJCll2oNdQoJS2ZWiByB2sEVswPgQzb0st4NK878aoWrdtkfURdnXNL0eU
         ywLtSENSWuj3iUOQkHN97r7Is7TyZDrvbCSHN7WfwSTYpAn05X4a0enKlherzBx1dwFk
         8GtVkyCjmjzwKjG/gl7kwrcDa5stkhnGVfhIw9zxsrQedmKUUw/5DoDJRuuTXHTKAWwK
         1eVRo/AIhG6aU9k+/2k2rEjlAZOYqDX1ODenWxlKKMRDlKxhRvCoqpp+1lv3Bgk/YtV5
         WA8A==
X-Gm-Message-State: ACgBeo3CoS93f2tCpIiHvdwymAvXZwdG4e2WASF9+Q4cQUR6R4fIQ/J3
        nfVQW1GuFigXiNnb0Oiu3psLjA==
X-Google-Smtp-Source: AA6agR40GPMalIQ8XsTV6frcBgYazmvxs+Ma7TVSI3xXMD2QTudlI3aTzkb6LzAjC+gXj2xbCgINkw==
X-Received: by 2002:a05:6402:22d0:b0:447:9c9a:f6b9 with SMTP id dm16-20020a05640222d000b004479c9af6b9mr9533875edb.296.1661585979758;
        Sat, 27 Aug 2022 00:39:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z2-20020a170906240200b0073c23616cb1sm1834357eja.12.2022.08.27.00.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 00:39:39 -0700 (PDT)
Date:   Sat, 27 Aug 2022 09:39:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next 0/7] devlink: sanitize per-port region
 creation/destruction
Message-ID: <YwnKOvs3xtIyDxiS@nanopsycho>
References: <20220825103400.1356995-1-jiri@resnulli.us>
 <20220825150132.5ec89092@kernel.org>
 <YwiChaPfZKkAK/c4@nanopsycho>
 <20220826172243.16ad86fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826172243.16ad86fe@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 27, 2022 at 02:22:43AM CEST, kuba@kernel.org wrote:
>On Fri, 26 Aug 2022 10:21:25 +0200 Jiri Pirko wrote:
>>> The point of exposing the devlink lock was to avoid forcing drivers 
>>> to order object registration in a specific way. I don't like.  
>> 
>> Well for params, we are also forcing them in a specific way. The
>> regions, with the DSA exception which is not voluntary, don't need to be
>> created/destroyed during devlink/port being registered.
>> 
>> I try to bring some order to the a bit messy devlink world. The
>> intention is to make everyone's live happier :)
>
>The way I remember it - we had to keep the ordering on resources for
>mlx4 because of complicated locking/async nature of events, and since
>it's a driver for a part which is much EoL we won't go back now and do
>major surgery, that's fine.
>
>But that shouldn't mean that the recommended way of using resources is
>"hook them up before register". The overall devlink locking ordering
>should converge towards the "hold devl_lock() around registration of
>your components, or whenever the device goes out of consistent state".

As you wish.
