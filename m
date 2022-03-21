Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E214E2EC1
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351594AbiCURIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351667AbiCURH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:07:59 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A39BAF1F8
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:06:31 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w127so16842169oig.10
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ljp+RpoQ+9bQpD0J1lWBQJX7RJIKcqaNYHNTqSdo0Ok=;
        b=ZxBcp7r+7nIMq0wyBblLM7KGILc1VY0kSQ5DAQMNaY4lo1hY1VkVPoMTS4+N7D53ww
         zxwjKq3O3Fpj8oNdLB+IA3YbAPJi6HiC16/qljTGGNLvZ2mzGKV1kVYNI3vASZWcQ/mn
         DeO+M5CitPYube/ShGRXguXpv6wYzFb9T/AT93AAM9YujYJKnSi23ybqdzGdCFXfd+0J
         KPv4t2ZVS8Lc1S1a3pIzGACzrLpD2xoKGHRfjIc9y0fihoGqvjhIz26ABP12N1dQ7WSu
         smpCGEAz8qPYY/O3nPyXZ6JXi8BlBfUNRCx04tCfuvKmTUYfTopIEq81B20smL39Ieua
         OYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ljp+RpoQ+9bQpD0J1lWBQJX7RJIKcqaNYHNTqSdo0Ok=;
        b=qdwo9UW6gOAelucf9T4nQyOQeDNKYj1EkSoJeAJOQ5oNFakkcwyJxo81gcmhvpLwsv
         TPgY8rX+YFvd0gN73ULov9GW0UrIgeYSAtsYporDEj22C7RusHMIC1/ZG76T054sEC2N
         4WUdz2gapigoOTrC5wQLaNLfGdZgMzGWe1w0X72zf1Uk9LkFfFMrS2T+UUJrthCF2G9X
         yq+UnlwBaebNddavJ/MJhZBg5yYFdRbwfYYVNc4CtTblKDRm/2Hnwg6V0rvkk2tgcuFb
         0VRkWFsBY2nPyF44aiq4rSyjYvpJ1B/+oAPITg1yQ71RhOC3H7yXub7eJvw2LuRqiEYx
         gx1Q==
X-Gm-Message-State: AOAM5312IAy8do+pOsN1b72bRZD55f2fvtB8D02nUei4R23l0GQBWuXv
        LcllnLuQ4sXoCobDoS1Dv5Y=
X-Google-Smtp-Source: ABdhPJzEoIw9Dd6XzG/8aCiPA/3LleU7QMh4MTzDazWObSq3h0yXy+PW6L90xx6cizXA5auxsR0HtQ==
X-Received: by 2002:aca:2b0d:0:b0:2d9:dc99:38a2 with SMTP id i13-20020aca2b0d000000b002d9dc9938a2mr43102oik.198.1647882390670;
        Mon, 21 Mar 2022 10:06:30 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id m23-20020a4add17000000b0032489ab619esm1889809oou.45.2022.03.21.10.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 10:06:30 -0700 (PDT)
Message-ID: <7242dabc-8c01-a66f-3686-4fc81093d35b@gmail.com>
Date:   Mon, 21 Mar 2022 11:06:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH iproute2-next v7 0/2] GTP support for ip link and tc
 flowers
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com
References: <20220317162755.4359-1-wojciech.drewek@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220317162755.4359-1-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/22 10:27 AM, Wojciech Drewek wrote:
> This patch series introduces GTP support to iproute2. Since this patch
> series it is possible to create net devices of GTP type. Then, those
> devices can be used in tc in order to offload GTP packets. New field
> in tc flower (gtp_opts) can be used to match on QFI and PDU type.
> 
> Kernel changes (merged):
> https://lore.kernel.org/netdev/164708701228.11169.15700740251869229843.git-patchwork-notify@kernel.org/
> 
> ---
> v4: updated link to merged kernel changes
> v5: restore changelogs, they were missing in
>     previous version
> 
> Wojciech Drewek (2):
>   ip: GTP support in ip link
>   f_flower: Implement gtp options support
> 
>  include/uapi/linux/if_link.h |   2 +
>  include/uapi/linux/pkt_cls.h |  16 ++++
>  ip/Makefile                  |   2 +-
>  ip/iplink.c                  |   2 +-
>  ip/iplink_gtp.c              | 140 +++++++++++++++++++++++++++++++++++
>  man/man8/ip-link.8.in        |  29 +++++++-
>  man/man8/tc-flower.8         |  10 +++
>  tc/f_flower.c                | 123 +++++++++++++++++++++++++++++-
>  8 files changed, 319 insertions(+), 5 deletions(-)
>  create mode 100644 ip/iplink_gtp.c
> 

looks like the patchworks notification did not go out. This set has been
applied to iproute2-next.
