Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF08E3048CC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388243AbhAZFjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbhAZDpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 22:45:17 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6BAC061573;
        Mon, 25 Jan 2021 19:44:36 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id k8so15026820otr.8;
        Mon, 25 Jan 2021 19:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QYpNjuNru06EFnnFLn43itUHwOQyKaiL6y8bBDSD5sQ=;
        b=XhPd+lgDt122eBk+Xk24gXLt+5dNaxpYMD2aQMCN++4C1FI1bqMVQsnuHZaW5XYZD2
         jqsqxCUX6iUvwmsNp0ATA9BfGFmuRQzOFNmXMTYKJy+LuKMqmBDFWc4ZlNQUIZAulfVT
         MRcZrLoTe014yYkvsUVhk26xyBfZYp4WOeT3abYzd9GAERs2xHPs5vId2KOgXH7qyMEU
         rNMZxV7F6X6M2v4bFOa6VmnlvBN29XkPG7368bgSspQZeMLGCja9KN1RigyI/xEshbXb
         +qb4AA2l56jYYzLhzbh2c4lpjInnJqfRtww3mozxpa/NF+NaDNa5kSnnQQ29sks6mhzO
         ILUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QYpNjuNru06EFnnFLn43itUHwOQyKaiL6y8bBDSD5sQ=;
        b=EklNt+HUEOLfg144BTNaUCNsrMhqIcB9GBM5wHW9xbNX938ra+N8898vYQWCPJ824F
         xc6bLpSLrCdXDBb+Xyx3N2AseMochGLtHxSGmZALWnSBuLm8yZVgYnwWpe5OP2yO3Qvv
         DReufk6oSZs9f/5HTNnSatOq9GBlIWxGScDZRwTXM6MLIx/TXb05Euig0Z2ScJ+eKKjM
         Aaaqyvi5ERlVrLvpBs3ISPei5yJkhycdsqxkz3dfufNHVOv416k+vVSoOTZGhau/K88/
         0RLZ5cfJzKinBygJbAhZaFoF0FkvinHQptIAyCLYKBRhY+El/aWsZzYfexLfPnQw8mo8
         nLog==
X-Gm-Message-State: AOAM531zeGzGr8ZxiRMENTu3CTsm0Gru6UIN3wFeyaxJ2tqGSAMJlkDL
        WWbZv2DWQwPHqvDtzt9Ic+pdJ62VIx8=
X-Google-Smtp-Source: ABdhPJzevCvJbwS97Y0Id7uIY+jKo6tZfeZfkdPwO4z3yF+uNLZATxvSby7w8guNEnzGjLF01bT9RQ==
X-Received: by 2002:a9d:674f:: with SMTP id w15mr2603796otm.88.1611632675976;
        Mon, 25 Jan 2021 19:44:35 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id r1sm3666823ooq.16.2021.01.25.19.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 19:44:35 -0800 (PST)
Subject: Re: [PATCH 4/4] net: l3mdev: use obj-$(CONFIG_NET_L3_MASTER_DEV) form
 in net/Makefile
To:     Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20210125231659.106201-1-masahiroy@kernel.org>
 <20210125231659.106201-4-masahiroy@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5bf4b9e8-50f8-011a-94fc-fd0b3d119b14@gmail.com>
Date:   Mon, 25 Jan 2021 20:44:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125231659.106201-4-masahiroy@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 4:16 PM, Masahiro Yamada wrote:
> CONFIG_NET_L3_MASTER_DEV is a bool option. Change the ifeq conditional
> to the standard obj-$(CONFIG_NET_L3_MASTER_DEV) form.
> 
> Use obj-y in net/l3mdev/Makefile because Kbuild visits this Makefile
> only when CONFIG_NET_L3_MASTER_DEV=y.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  net/Makefile        | 4 +---
>  net/l3mdev/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
