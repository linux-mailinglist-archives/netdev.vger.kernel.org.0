Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88ADA2F9533
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 21:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbhAQUnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 15:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbhAQUnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 15:43:05 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416F6C061573;
        Sun, 17 Jan 2021 12:42:25 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id u19so15363585edx.2;
        Sun, 17 Jan 2021 12:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i8Mw+aRfPM/naCLccErYbbvNL6miHz5vja/K03ZgClM=;
        b=hUuc7GeiL9SVh1rYNR9u51Ao/KO814qe4+vHkQIToh0Mp88VjrcmP8Oj/vNt5VEB2H
         yKT0xm/LdwsiCCjPhTf20JyJPnngA5DsuwzMLSed63kNRwN9+WGFqoZgqWggwR1PCSu/
         IZfZg8Sa3Z1IDC1aKpBoCNxiFuH0vz/ChLTAkSy47XX7nPgHF7bAZV2wYAB5lU6KbzMS
         wxF27fO6zpPPOvFdOppvO4xjYRqyayVCjq72VdfzKhX6aUhnUwAG807MW5mIgB8bIYlb
         sIctPo33EptFPrO87ypn0HjxYCqSZXbxKJHC921iWsPqqRM/qUS6tNiw+s2x1/FhJZTj
         7vUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i8Mw+aRfPM/naCLccErYbbvNL6miHz5vja/K03ZgClM=;
        b=KhQO5J9IFnz6LE9B82t7VMBymBkua5RUYh/QJZy9uvSgC6cWxJk15LuMg7BQSkUiB+
         41ghX8GiYun3M2pm5tngwoVRApHtGIyTcSSE8KFhEARb4IAFSWKZvGd/llPqOoteRvTX
         GtinhYT87LecfLz1nFwVdLNIL4jutVuNAevRatfGOu3pcTcoI4yaVRa57HmsfCEXDwGg
         tkQe0mjH7dpslCqJGkA8D7nEvdmnANfxMM/JSP2aFJsR+2jGGqECmZ7VTt2GRpg56B6J
         b5cu8/AwoEKm+BLJ3sjchy0Ew0bjrdquh74dsRVt7CngFc3rgHd0b5e+F3MP64rZofs1
         AhkQ==
X-Gm-Message-State: AOAM532vhhvAtNeCpxw3jOfRq3gAjJPuHJH4Cwv1qUtUV5vUG45Wk5da
        MIM5Xcke88QI5s04RcJk9ME7bUbNDZ8=
X-Google-Smtp-Source: ABdhPJz+w37Mun8201403wyh8G0/XKeYmMSlpLSdfT72Bqod3nujdM3VBDRHrerm2TlUha0ExppQsg==
X-Received: by 2002:a05:6402:487:: with SMTP id k7mr17068742edv.130.1610916143620;
        Sun, 17 Jan 2021 12:42:23 -0800 (PST)
Received: from ?IPv6:2001:a61:244d:fe01:9fb1:d962:461a:45e8? ([2001:a61:244d:fe01:9fb1:d962:461a:45e8])
        by smtp.gmail.com with ESMTPSA id i13sm9774136edu.22.2021.01.17.12.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 12:42:22 -0800 (PST)
Cc:     mtk.manpages@gmail.com,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rtnetlink.7: Remove IPv4 from description
To:     Alejandro Colomar <alx.manpages@gmail.com>
References: <20210116150434.7938-1-alx.manpages@gmail.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <613ba649-4787-9457-f81d-475428c060a4@gmail.com>
Date:   Sun, 17 Jan 2021 21:42:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210116150434.7938-1-alx.manpages@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex and Pali

On 1/16/21 4:04 PM, Alejandro Colomar wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> rtnetlink is not only used for IPv4
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>

Thanks. Patch applied.

Cheers,

Michael

> ---
>  man7/rtnetlink.7 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man7/rtnetlink.7 b/man7/rtnetlink.7
> index cd6809320..aec005ff9 100644
> --- a/man7/rtnetlink.7
> +++ b/man7/rtnetlink.7
> @@ -13,7 +13,7 @@
>  .\"
>  .TH RTNETLINK  7 2020-06-09 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> -rtnetlink \- Linux IPv4 routing socket
> +rtnetlink \- Linux routing socket
>  .SH SYNOPSIS
>  .nf
>  .B #include <asm/types.h>
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
