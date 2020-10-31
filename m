Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC9A2A1885
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgJaPXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgJaPXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:23:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5052C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:23:22 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id a20so9102612ilk.13
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HpWzV2sAcTKYfQ/uT/V3yuYivZTG5jNQg2mi7hAqq5I=;
        b=Xx/kqf6Xfzo3gWHtm+A4aXnEW/QWXJdWd/LsC/OHl3lr/1I2bOJAbjE/tx+VKQTRSO
         1CdvC6zC3L89RnRm/vE0PSAyQLWKBRoi/Lg+v3Mn5hALt75CuV8mHDQxaqGkvGVJbpBT
         CRlE15b2dbGHU/uNoj57CqP7Au7ROWoQRYol/hwyQz9mI9cma2rhll1u80insu/E8eUn
         1vHuIz7Yyjc38Bao9z7KCNfAE4ZHu9IgFwaBcxrmbCmgOvJCpngCe5RGv2BxAbk5fe5V
         2DNxFWGcAEakdKcpfik3kjVqwwZ+LbHorCtzm0fvsI4hKA8pjlQb/6ObdMfloVrbyMBh
         /33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HpWzV2sAcTKYfQ/uT/V3yuYivZTG5jNQg2mi7hAqq5I=;
        b=NxR2yDuIIEqbtBNZMG7PhdjebZOcVZp+Oj5HSA5EokxOzGqNrX42jgh3ZSd4ZET+TD
         I4t4swWjHdt11QTipedmn4YL1F+uGSrGPdriHVuJ3ca0phYsRd+sM5fqsQZIuYuemg7C
         2MrpflQ459ed8vCmbBasDdRpJ9ebBc+QQLM1ockQBdK5i3f7kmkmrvSisViqkZrUbl1w
         Xj4jZCX0mhIqOucrED7Ux8siKFLuVQ+Fuxn0b8ozVysNANGLCdDq/YIj2/k34KcgYADI
         hYUMGzv5jggHL4d7xf8dsjT4MB2TaOSWawQDQajlJet85pVMf1k0GNjPT2TqSa0uqm/A
         Uf2w==
X-Gm-Message-State: AOAM531b+DdPjGthw20ZIbVKD9QohGaHaXvFxdF8XLyGdDQrqDtuoTqH
        k4ESTWm2qK5Z6siPVUzp3u8=
X-Google-Smtp-Source: ABdhPJy4Bs0ffWZ0qQ3cZSRUyP4PgFg/z//rHtlTzB5ToXFFGa4tj5m93EOTbCn1aOpTtCSqrz2Obg==
X-Received: by 2002:a05:6e02:ca9:: with SMTP id 9mr5318495ilg.2.1604157802376;
        Sat, 31 Oct 2020 08:23:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:10cc:b439:52ba:687f])
        by smtp.googlemail.com with ESMTPSA id o19sm7016870ilt.24.2020.10.31.08.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 08:23:21 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 0/2] Implement filter terse dump mode
 support
To:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        vlad@buslov.dev
References: <20201023145536.27578-1-vladbu@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e9b2504-7397-6b96-f4f5-54c112a7724d@gmail.com>
Date:   Sat, 31 Oct 2020 09:23:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201023145536.27578-1-vladbu@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/20 8:55 AM, Vlad Buslov wrote:
> Implement support for terse dump mode which provides only essential
> classifier/action info (handle, stats, cookie, etc.). Use new
> TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
> kernel.
> 
> Vlad Buslov (2):
>   tc: skip actions that don't have options attribute when printing
>   tc: implement support for terse dump
> 

applied to iproute2-next.

