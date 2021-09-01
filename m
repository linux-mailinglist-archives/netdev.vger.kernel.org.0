Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25383FE116
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344533AbhIARXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhIARXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:23:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C91C061575;
        Wed,  1 Sep 2021 10:22:03 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y17so335020pfl.13;
        Wed, 01 Sep 2021 10:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nfAkk0jXyriy7YDumg63T1rJOPepAna5AhOX1c8OHnQ=;
        b=dPBqyV9ygf0IfaVod4baG7+G/rSQITh1zx0NaRJCobxojqZw/QUYOijDGZCb5XfuQj
         8ziD1XxSuntvqgkoIhoMfCCoNGVV9VixMGvQM0M3XF+X3N4SHBYc6VFM3HPmUaVQya14
         fZvEe3RXE3iMnYn6HTrAfgF1CFZ+340BndMOa9hu65Uoj/tGjkjYcC/tQ+7hoJ4424qc
         Gocevt2y+kettLMzO3eJuUvMzSWrhvkJdmMDletClAhXdzR/De1XYbJn0uepbVpxxRZT
         Ma67PjjxBV+lTC+QiioYaG5iwE/5HmF3zDD8f1H4mjeWKQ4/OwQ0G0hkwXu3yf7m3sWO
         q5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nfAkk0jXyriy7YDumg63T1rJOPepAna5AhOX1c8OHnQ=;
        b=BpWWr36NafM2gLZcbu0q7Q2fyHz+IxZnF0DxO2dvYEuleSgmMzlXgelWIq2BF9g5UU
         2kjiuVsHlOWa6483PATOU8zyk/6iOem5jRfZKLfK4rb1uMem9YxcyNx+IXH/yEEhfm1j
         sQNAIoiiyCRtp1ide1ET3Bf+y5uOGN+veoejzO1edWWSNmESL5cP82KoJ4TvRwOa/6Ux
         50kPfa1ZMjHzJtqcj3rgtPodaSPQ2BNovPkiUhnX+sGEBETEje4wq2LnZ7K+DYT0wJYe
         EU6H/ssRCup/us37Pbn9O/1RUxrXxuw5tbIgDddlAWpsT5sDmZCI205/6cA6wCQrMubd
         4L1A==
X-Gm-Message-State: AOAM5303uIcU94Sd1AhHDDd/Af4Ns9IvW87KD/UHvpyXunS4EsPJ+BAt
        yUcMr8F6rILuwzM09Y+PMZE=
X-Google-Smtp-Source: ABdhPJwyVNwraC5WuvjTCVqbv1S8nmODuGucwAgdAL+N9DZK2bR+X6Kr9Do+OYcNYXimMMdFIUBvsA==
X-Received: by 2002:a05:6a00:1a88:b0:407:1f7c:60b9 with SMTP id e8-20020a056a001a8800b004071f7c60b9mr403178pfv.77.1630516922932;
        Wed, 01 Sep 2021 10:22:02 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id d19sm157452pjs.18.2021.09.01.10.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 10:22:02 -0700 (PDT)
Message-ID: <ba35e7b8-4f90-9870-3e9e-f8666f5ebd0f@gmail.com>
Date:   Wed, 1 Sep 2021 10:21:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH net 2/2] net: dsa: b53: Set correct number of ports in the
 DSA struct
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        stable@vger.kernel.org
References: <20210901092141.6451-1-zajec5@gmail.com>
 <20210901092141.6451-2-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901092141.6451-2-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2021 2:21 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Setting DSA_MAX_PORTS caused DSA to call b53 callbacks (e.g.
> b53_disable_port() during dsa_register_switch()) for invalid
> (non-existent) ports. That made b53 modify unrelated registers and is
> one of reasons for a broken BCM5301x support.
> 
> This problem exists for years but DSA_MAX_PORTS usage has changed few
> times so it's hard to specify a single commit this change fixes.

You should still try to identify the relevant tags that this is fixing 
such that this gets back ported to the appropriate trees. We could use 
Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper"), to 
minimize the amount of work doing the back port.
-- 
Florian
