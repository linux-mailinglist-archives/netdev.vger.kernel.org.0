Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B931F0829
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgFFSrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 14:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbgFFSrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 14:47:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D10C03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 11:47:15 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l17so196919wmj.0
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 11:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7usBrGKHvW3nSPXVqWjAZ/TmG7WNlTrS4Q2gmX4xR3I=;
        b=Lo4SVmnL5Ra/b2V2VE+lSMhjLxtNbwZLKSAyb6UrcreJJMPX6bieHv3yhRYeK/z9BI
         tkYk02Dro3+lHPm8EyLkPKhbuc8XvvVwi9pvXJInPKDhWlRmATOpOcWvgp/UBzi01i8o
         uWqYilpwc6YE0jVhIdhb/5VBDvnIwrp3DJpoUQLt12Ug3yu1Cg7PXByRVTYgmtMaSzZd
         +AsP8jHitAEEklQorXVAVZyt5BwU4U0nTMy2GTPjAuKpOg6WDHWf+pRLktgdQQP6ZTig
         Yz/i2+yge5ApH7A+3ooYlYff3J1tfIgrACzt+MFcZYzwtAFaBn2HhWutur36JWOTNQlc
         369A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7usBrGKHvW3nSPXVqWjAZ/TmG7WNlTrS4Q2gmX4xR3I=;
        b=k8S9sLVTV0nXL8zsrmhaq4hCosA2B97ECpqhITh40kglZmQidkhGQtt53nSZX7tEQH
         sJgAl87PodEnObzdEi2VYSSORA/na3EwlqniiUIkLxpapgphk0WnCZS2jydaA4Rp6dgD
         UfC9Dqx7Tma3yUMVnuB1w1T8pp/xoF+W+WGxSf9k+DroL3X8flL3d6B+19sLC0QQAm5u
         C9zwOC7jJDDlnEwAX+IFugRwbh4h7+U/777n9mglwIACvPsqHhaoAWI8/l3Lu1cX3hCB
         UXkOzZNoqd2+B5CT6+NxLbADtHqVz0Ohd6MFsB9F2aczGA+CizCq2F1dsAlszmivvl15
         MIWg==
X-Gm-Message-State: AOAM532/5fFDPx3CtRy2BwF92TPsba0bml0EOleM6q+f2MJ5Yq4ZhAPF
        Gk1YdUuPiy7RC+mmbPM4qlE=
X-Google-Smtp-Source: ABdhPJwithN+MmiGHaDEYzgDQ7F5wMjNMGLkVNbPszW5UTq2egPNDCP+iIwm7L1GuIS5Qn9puVgzwQ==
X-Received: by 2002:a1c:7414:: with SMTP id p20mr8333439wmc.124.1591469233103;
        Sat, 06 Jun 2020 11:47:13 -0700 (PDT)
Received: from [192.168.0.109] (ip5b426f84.dynamic.kabel-deutschland.de. [91.66.111.132])
        by smtp.gmail.com with ESMTPSA id o20sm18135381wra.29.2020.06.06.11.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2020 11:47:12 -0700 (PDT)
Subject: Re: [PATCH ethtool 01/21] netlink: fix build warnings
To:     Michal Kubecek <mkubecek@suse.cz>,
        John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
References: <cover.1590707335.git.mkubecek@suse.cz>
 <bb60cbfe99071fca4b0ea9e62d67a2341d8dd652.1590707335.git.mkubecek@suse.cz>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Message-ID: <af510107-1cf0-0ad8-63bb-0fd56386f0ab@gmail.com>
Date:   Sat, 6 Jun 2020 20:47:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <bb60cbfe99071fca4b0ea9e62d67a2341d8dd652.1590707335.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On 29.05.20 01:21, Michal Kubecek wrote:
> Depending on compiler version and options, some of these warnings may
> result in build failure.
> 
> - gcc 4.8 wants __KERNEL_DIV_ROUND_UP defined before including ethtool.h
> - avoid pointer arithmetic on void *
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Tested-by: Heiko Thiery <heiko.thiery@gmail.com>


-- 
Heiko
