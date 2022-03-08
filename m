Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABD84D1CDF
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiCHQMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348227AbiCHQMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:12:05 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0439850B2A
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:11:07 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id r13so40368119ejd.5
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 08:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SbxuD1tl20domxWOehSZ8fJftX11yDf/ZZR/EJ7SZrA=;
        b=xJSdRLK6rX9iEpNpbynXa3kQwTAxTSJNJIEVGLYDU3so027WMlIz0h2P7sUEtJEGCg
         qltlF5xkBcSyVRYaAWUpfUbS7P5TsVoZt/h+E3eSeTimQn/xw+n6et7tuvGrcg2k4qJO
         y7UskzFCElyFItlj5/CtgJo95gdsGHPNZHp/ppF3R4eg2xkbauwT3HwALZZ8myVsE+qX
         8f1VvQ18jShYfrKD8xTXEWDjspqSdK4hZZNun/dCUUL787F/PECqTJ6XYqpG5WVp6CgU
         Vaval1bwJl/UV+izJAf0vvHjvcFvz1FT+dVXFd2vUKr2vq+G4MA7dsVn7c96c7iD116C
         W1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SbxuD1tl20domxWOehSZ8fJftX11yDf/ZZR/EJ7SZrA=;
        b=Mwx3YHtkKB6z4EzeHAsapB4ufHO65GRtKSxiConaCUi6BpF1pxEvH1H6+FgsEfXMH+
         y05e+rjTMEywSOm2RlPR/0Q48aALKnSGnOOE89oxxyMc9vS7ska16jXSNmjTVurxNBVP
         0gRF6IGGj5JZkXGAKHdu+aHiZISXnheJ7dYNxRZr18ioRTDiS+8P/SHNc6YP7+4Ahusk
         eIlasOoJaHpgLiEso12vxfUrarFzbWqzScENeljFoGy9n+vFqO6PGqvX1ewk+eMajDuh
         AY8EIiiN1M/s6oScmKHn9KOdtYlaTJqS+mciHb7Yylnte9OyGjyc/wiA5r/yGKNSQxab
         bxdg==
X-Gm-Message-State: AOAM533QdzdhlXbRJSuIDSCPDvdY1Z54QdJu1IkpAa+z+lyunw6ZdVIL
        5VkbV7+IgNnlemzTHf5UcS35Mm5XJziBFfyP+OI=
X-Google-Smtp-Source: ABdhPJyxVzOzvGvdYdp+ahLuHf9DYxGAc6dvxOGqkP+g2Y7DnDrEofiMMhqKXU4RyT9gEeFBxTIGWQ==
X-Received: by 2002:a17:907:7659:b0:6da:a62f:8c1d with SMTP id kj25-20020a170907765900b006daa62f8c1dmr13642301ejc.453.1646755866333;
        Tue, 08 Mar 2022 08:11:06 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id ky5-20020a170907778500b006d1b2dd8d4csm6072617ejc.99.2022.03.08.08.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:11:05 -0800 (PST)
Message-ID: <70f81f09-0b18-43c2-206d-c31c518dab4d@blackwall.org>
Date:   Tue, 8 Mar 2022 18:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next 1/2] bridge: support for controlling
 flooding of broadcast per port
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20220308132915.2610480-1-troglobit@gmail.com>
 <20220308132915.2610480-2-troglobit@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220308132915.2610480-2-troglobit@gmail.com>
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

On 08/03/2022 15:29, Joachim Wiberg wrote:
> Add per-port support for controlling flooding of broadcast traffic.
> Similar to unicast and multcast flooding that already exist.
> 
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  bridge/link.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

Nice, thanks for adding this. Please also update ip/iplink_bridge_slave.c and the
respective docs with the bcast flag, it already supports the other two.
