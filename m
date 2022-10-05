Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63045F5AD0
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 22:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiJEUID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 16:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiJEUIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 16:08:02 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04EE78BC3;
        Wed,  5 Oct 2022 13:08:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w10so60289edd.4;
        Wed, 05 Oct 2022 13:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sNYsP2tdylratBrLZxwOZJXo9et7aEKQDgWx4ky+S7c=;
        b=e/QHON+VMKkkb5bw8MT/7gedZezF31z6n7Hat9itDKV5R+Hgabf4mgasKfL4czlH2s
         o5jKj3lxItEzMBOtAFxUbXQoA4x3JRxMgW2VJJHXOhccksI6w3pCcSNY+gmHJg/2Lky3
         oBxG/pujzDGbah1o6cXrjLRxmjjoEbIS37UwJhL6zSnnZhPk4+htaBfFqqGZVxQ3a1kf
         9T3UsoKndMGuDYyjla4ef5VIGROfoMgHww0z+Zp7IpCTZQKS73XrIf+xfVtnBt3ASaHB
         0kr0u70JUtlA3my541zMYZjrtsGXnYuNgrpSj6+FvtQADQb/3DXDioSE2XKwdeiHoHXU
         LV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNYsP2tdylratBrLZxwOZJXo9et7aEKQDgWx4ky+S7c=;
        b=f9Isn467D4FEonMuQr/ex65KcHWhjY+bZ6uv6hGdHB9LoTe4lsrEzZBLFLkXLGN2ck
         CWt37q3/UwlG9eAZSctzHagt8/4mpmnujOQmheP5jnOPGo1ieJi6xE5Lkoq+viRjFarW
         jm24pkvbn1BTI8jxb4NLfbpmxQzhISHjf2KwP0FsTg47I0NfEoWPGgVkscG/vsSBhVJB
         CwYNszRVXbSYV/E76qjKRhOnnZe8Vwi8j1cNwpgtWIYK6Bodb7Nqwdrg8uHzT4SxOxK3
         qo8Sny2yeihILTvdPFueOqbeEbQtiDHAXtUU6vnksnEVdWY+gOPizIYtZP2AcXU9477v
         yVqA==
X-Gm-Message-State: ACrzQf3tKbf4OjEIxulJDdYoK2S2pdyjHULaU2j58mI8eItIWNcvwTn9
        VIUekSYqtCfg0rela24Z7eg=
X-Google-Smtp-Source: AMsMyM65UfHjDhZDsuG/ctGt3FZT88h9dASEFpyYNRoAglSsvORJhsqWaslD7rpLD8/rZMeVWdRh0Q==
X-Received: by 2002:a05:6402:348c:b0:459:9a51:5569 with SMTP id v12-20020a056402348c00b004599a515569mr1369593edc.65.1665000479235;
        Wed, 05 Oct 2022 13:07:59 -0700 (PDT)
Received: from krava ([83.240.63.251])
        by smtp.gmail.com with ESMTPSA id b16-20020a05640202d000b004576e3aee69sm4507042edx.4.2022.10.05.13.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 13:07:58 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 5 Oct 2022 22:07:57 +0200
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Daniel Xu <dxu@dxuuu.xyz>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <Yz3kHX4hh8soRjGE@krava>
References: <20221003190545.6b7c7aba@kernel.org>
 <20221003214941.6f6ea10d@kernel.org>
 <YzvV0CFSi9KvXVlG@krava>
 <20221004072522.319cd826@kernel.org>
 <Yz1SSlzZQhVtl1oS@krava>
 <20221005084442.48cb27f1@kernel.org>
 <20221005091801.38cc8732@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005091801.38cc8732@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 09:18:01AM -0700, Jakub Kicinski wrote:
> On Wed, 5 Oct 2022 08:44:42 -0700 Jakub Kicinski wrote:
> > Hm, I was compiling Linus's tree not linux-next.
> > Let me try linux-next right now.
> > 
> > Did you use the 8.5 gcc (which I believe is what comes with 
> > CentOS Stream)?  I only see it there.

nope.. latest fedora 12

> 
> Yeah, it's there on linux-next, too.
> 
> Let me grab a fresh VM and try there. Maybe it's my system. Somehow.

ok, I will look around what's the way to install that centos 8 thing

jirka
