Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45447214DAF
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgGEPfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgGEPf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:35:29 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB78C061794;
        Sun,  5 Jul 2020 08:35:29 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id e13so32744380qkg.5;
        Sun, 05 Jul 2020 08:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SH28tdiDJsXYXRFHInVuUZ9QDGxO5tD7WG8jpUhte4E=;
        b=FFVRSjoV3hlBBM259Ok+E3rMQceCGcET+Wj2uhalza1ZH93n/A553bBnFqzmGL0z+N
         eecaKCm3jqqWp22tJ/ctaeg+hLUAAYJRi7wtzy7Q+2v+Ad0kVJBQM9/PJAucrgeHbj7x
         DC9LZBW6u83mQj0J9uOi0BqsgNql4XHBz7tnqiOd5g9puQ+o/h27Kghc26Tk1kN7nlkh
         xLKRTaG25Xs/LWeNXsl+5OiEEMB31YUId4z5uffhm9WFAOn2yVJSyajvE+pc2tbU6CmR
         IFDtKvwBjPPMQ5ukwUnbCBFsTm3U4+MsudLLnB7eS/i8D2bAanpPTbnh7N6Z2nEXqKLi
         uaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SH28tdiDJsXYXRFHInVuUZ9QDGxO5tD7WG8jpUhte4E=;
        b=cHfQ6RxAyEjD1lJTIq/Ij0Uv6jXb59xqPNCjv0sjMZE3jv+kUcsdtYrguz1GNBIydZ
         9moczFHWpynB8VFmR9G+wuPamILU9rT/2TpXytviiCUSZLadmcAEd66tQcR+7ko64Nvy
         iEv+Y7geUILJXsLcAlFJ7qdZR8DyHLxoQGc9/Xc2jYvlpSjdl/Z31Z8axRb2EyfRz3+i
         G+8fAGKScSq/4or2UI5sQBIb3zW25nt/59lHjSw6LYiGIQhMgnZB2Cc9rCuAavXfOhV4
         1GsNv90eNiN7EwlivVF/ac4kRDUbGB3xIupxUEoBa6uYt7SjqRbvFIM75XAdh2o8bswJ
         AOPw==
X-Gm-Message-State: AOAM533C7g4FxA9OzCibdcDr/NVuKQjJEGRowCxnfRv5Mdk0nb65Adhc
        XnE7zlak+M+cytnMO/KEWqRWp1FQ
X-Google-Smtp-Source: ABdhPJybbAiZ3xkFTj9Py3ia20S8s+H1I2Iv59f/U7esrkNZc/5Vz5ksRkIFeL7XxzOVH5a0ekyBmA==
X-Received: by 2002:a37:6609:: with SMTP id a9mr43224012qkc.337.1593963328908;
        Sun, 05 Jul 2020 08:35:28 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id y67sm13141609qka.101.2020.07.05.08.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 08:35:28 -0700 (PDT)
Subject: Re: [v2,iproute2-next 1/2] action police: change the print message
 quotes style
To:     Po Liu <po.liu@nxp.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, davem@davemloft.net, jhs@mojatatu.com,
        vlad@buslov.dev, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com
References: <20200628014602.13002-1-po.liu@nxp.com>
 <20200629020420.30412-1-po.liu@nxp.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e2ca479b-7b94-eef8-f226-8d9153066134@gmail.com>
Date:   Sun, 5 Jul 2020 09:35:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200629020420.30412-1-po.liu@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/20 8:04 PM, Po Liu wrote:
> Change the double quotes to single quotes in fprintf message to make it
> more readable.
> 
> Signed-off-by: Po Liu <po.liu@nxp.com>
> ---
> v1->v2 changes:
> - Patch new added
> 
>  tc/m_police.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

applied both to iproute2-next. Thanks


