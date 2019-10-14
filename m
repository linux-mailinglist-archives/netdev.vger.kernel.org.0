Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7106D5EEC
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 11:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbfJNJbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 05:31:52 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46425 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730667AbfJNJbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 05:31:51 -0400
Received: by mail-wr1-f42.google.com with SMTP id o18so18782959wrv.13
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 02:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AmPmOoaiMgL6YCWtVNATx/hqb+YoKNHwT3sJM39RinY=;
        b=KiEmCdkitnsJlVN5A1+HtuzhPMicvUUFPmKeFWS+cBZolZPM0DItFLcvVlS09Z9ky+
         Gh5dK6WhkF51rUQL3DV6wQ5OPxG/XOOG7zFZiS8r1Td/PgJdxRIsq70t1UjWgbBL37yc
         SjjizVvWfX9I+x6R0/IKEq58fXjG14Mj0MQRpgbsn8tNlTSYz3SwB7o2Q+cPaCONVYS7
         5zt1aBVJRuMBod69oNjAOsrU5WKOILq3LFXsKfgZhTg7KjYzqJiKZmHjMDcN5XUiOhLT
         Wf7JYzOCmY4v4HoPeUaRVH00UjN65mye729JX6J/N7cHwe9RXYVkM56HxRoppbnoQxNA
         Pd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AmPmOoaiMgL6YCWtVNATx/hqb+YoKNHwT3sJM39RinY=;
        b=iICZOl96z4SGVS9cC5lIFqKYMF/6yl4CYeJFo9NFHjbBlYCdsGUH68bACb60J7VtbE
         Bymd2e+R1n9udLCH7V4ZTVm0DxPSSrbt7jVDN+Bkht7442rr6yZRf+i/EmNPCK+fUpoz
         ESdX8MfQuXSnOzetFPDVK+7u8Bz0PoO8nRHVA8qX3ge2T5RdijstIsWm49CAzAlY6GvY
         RMTSGhcYeuMkbnnjqCTB5lISYF04IObPYoAQohpHmL3Q9iEplrIwQab85PS05m+/YGgy
         lRU70P99ms3rmMIO8DAiY6/MmI/PYxPfJVkLbm3+Oyod/AXCioj/G2rgThqLNYHsdWuC
         pPpQ==
X-Gm-Message-State: APjAAAX0Jsl5h4cDebztTJcl/YFSBTUSgLskHFd2RQx3rs9hE5L4/MI9
        jsqHGmJfzAY/pbzcwcTgu3RPLtTTXTI=
X-Google-Smtp-Source: APXvYqwst91iMWWdK7L3UN7hzUHBfI0FPjugPj8F/4qErXk/zWde/mxhzh3+Ivf6FMx3jH90iGvIHw==
X-Received: by 2002:a5d:4a46:: with SMTP id v6mr9491007wrs.158.1571045509450;
        Mon, 14 Oct 2019 02:31:49 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:6c26:3154:28c0:6a9f? ([2a01:e35:8b63:dc30:6c26:3154:28c0:6a9f])
        by smtp.gmail.com with ESMTPSA id a13sm48662641wrf.73.2019.10.14.02.31.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 02:31:48 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: pull request (net): ipsec 2019-09-05
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
References: <20190905102201.1636-1-steffen.klassert@secunet.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
Date:   Mon, 14 Oct 2019 11:31:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190905102201.1636-1-steffen.klassert@secunet.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/09/2019 à 12:21, Steffen Klassert a écrit :
> 1) Several xfrm interface fixes from Nicolas Dichtel:
>    - Avoid an interface ID corruption on changelink.
>    - Fix wrong intterface names in the logs.
>    - Fix a list corruption when changing network namespaces.
>    - Fix unregistation of the underying phydev.
Is it possible to queue those patches for the stable trees?
And also 56c5ee1a5823 ("xfrm interface: fix memory leak on creation")?


Thank you,
Nicolas

> 
> 2) Fix a potential warning when merging xfrm_plocy nodes.
>    From Florian Westphal.
> 
> Please pull or let me know if there are problems.
> 
> Thanks!
> 
> The following changes since commit 114a5c3240155fdb01bf821c9d326d7bb05bd464:
> 
>   Merge tag 'mlx5-fixes-2019-07-11' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-07-11 15:06:37 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master
> 
> for you to fetch changes up to 769a807d0b41df4201dbeb01c22eaeb3e5905532:
> 
>   xfrm: policy: avoid warning splat when merging nodes (2019-08-20 08:09:42 +0200)
> 
> ----------------------------------------------------------------
> Florian Westphal (1):
>       xfrm: policy: avoid warning splat when merging nodes
> 
> Nicolas Dichtel (4):
>       xfrm interface: avoid corruption on changelink
>       xfrm interface: ifname may be wrong in logs
>       xfrm interface: fix list corruption for x-netns
>       xfrm interface: fix management of phydev
> 
>  include/net/xfrm.h                         |  2 --
>  net/xfrm/xfrm_interface.c                  | 56 +++++++++++++-----------------
>  net/xfrm/xfrm_policy.c                     |  6 ++--
>  tools/testing/selftests/net/xfrm_policy.sh |  7 ++++
>  4 files changed, 36 insertions(+), 35 deletions(-)
> 
