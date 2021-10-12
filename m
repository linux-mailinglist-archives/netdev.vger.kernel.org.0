Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3656D42A96B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhJLQba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhJLQba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:31:30 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC2BC061749
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:29:28 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e12so68661156wra.4
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WoI+RIYPtTHHEGdSwuorNq+48h1lI38S5XMbUzci1do=;
        b=IXnGkACIv8ATP6Rg+2IOmXepCL9y3vwvei56jej9pA2dn5ZGDyaixPeJaPEI3uby1y
         Hr9e0UN5sFQlev6+W+k7RzkQNF1NZeX3p8ox3nucq6xMUHyOIkiWkCUpj2QGe/r9evuE
         0+9pce8I5+0Da9ZDGxt/eAGDFuRmXasghtIlP/gDlRyfsh4EZP0K9uH+Qme+YarXosb5
         5zT3IzvsQl62fzHEfSIBDXFRrezqj/75a6nuZ3KbS1egtb8NU9Wzc4noOWPXO8ZveJ3Z
         4cHRUBorP1aqAr166LpyNMvn2pfPUk70LqYkfxJ4Nlxeu38PE8MIQIBdlilyvzYWAKHo
         iA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WoI+RIYPtTHHEGdSwuorNq+48h1lI38S5XMbUzci1do=;
        b=s4lOzSuC6ItMIwM/BFUY3mxId7gTy7TZ75mSRdNrB9NKdl32zYxGUTaMzx0nRHjSUm
         tyeRWwbqABe0qqbwMs916dy4mtO/nch3u6GDjxGUDxRyMMpp1FBWBA7UpPISRlqdPKz0
         uayrcDXGovEfKC4NF2dtmRktXHgeXrNIXlFz8qkalMzrOvcdzkS7WGt2h3YAJ+fw+RFe
         WX06KIZFIoproJZZRf9o61Q4i7OTd5d1JLuIucPMPdgrVL7pVgUNJpjcWBCr9veziIdq
         7O/UeoKxyNff4zNza10TZn99jH6UWmTt0g3Z0dgCicP8pEFD18m+aTng+3lVuB2LQ2gb
         DZsg==
X-Gm-Message-State: AOAM531Ketcq4LCxApZErGsB6At4s9Zyhj7Ldf6zuHLEx7eizHfJfp3I
        Au2l06sDMH+dPrln0n5hyGkKpA==
X-Google-Smtp-Source: ABdhPJyOvOpRNu4YETAcMkAxjvEJmxG7khGK/O+O0wVECw82ef9aelrGdQva2GQHQ48aAFfflyUy1Q==
X-Received: by 2002:adf:bc14:: with SMTP id s20mr33111077wrg.8.1634056167015;
        Tue, 12 Oct 2021 09:29:27 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:5564:458a:9373:f0e4? ([2a01:e0a:410:bb00:5564:458a:9373:f0e4])
        by smtp.gmail.com with ESMTPSA id p19sm2886484wmg.29.2021.10.12.09.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 09:29:26 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 4/4] bpf: export bpf_jit_current
To:     Lorenz Bauer <lmb@cloudflare.com>, luke.r.nels@gmail.com,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211012135935.37054-1-lmb@cloudflare.com>
 <20211012135935.37054-5-lmb@cloudflare.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <836d9371-7d51-b01f-eefd-cc3bf6f5f68e@6wind.com>
Date:   Tue, 12 Oct 2021 18:29:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012135935.37054-5-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/10/2021 à 15:59, Lorenz Bauer a écrit :
> Expose bpf_jit_current as a read only value via sysctl.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

[snip]

> +	{
> +		.procname	= "bpf_jit_current",
> +		.data		= &bpf_jit_current,
> +		.maxlen		= sizeof(long),
> +		.mode		= 0400,
Why not 0444 ?


Regards,
Nicolas
