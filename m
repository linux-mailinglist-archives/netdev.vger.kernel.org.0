Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4EE48F9D8
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 01:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiAPAE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 19:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiAPAE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 19:04:57 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7DEC061574
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 16:04:57 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id c1-20020a4a9c41000000b002dd0450ba2aso3753760ook.8
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 16:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sW4qB/1UcVGKqyLeV1+rvQfo5BkCtqtWowtBSrGjXOI=;
        b=WBadkgld/pGBUjJC+OwxmErH4gbvDgIv6yW6h9O7h6D3fuZVRmjBUxVJUtYELb8hQ8
         fo4pRrSkkeM7nkYhDpMEF/ID73FT4t0ixDee6DIhXOhRXZzoulWmxY9ReuntrGwKlrWI
         nyl9SDqDaO/YG2u2zkraUWI5D4dAWOyBUmOj7L+34SVhzdhAPWyloUtERl+yg0KZEl2N
         un4z4NKW5l2G1RHixEP4stLfk44EF5j7Hc/AgqAUWZZFS04HmVf4Kh9o0D194pgLogyW
         x9WNNq3VDvHv0OtLn5xNAmCOBgXCHkctLxfUYNzCRz2nXusDZ35+Do09hUvwXU6uHFTd
         pYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sW4qB/1UcVGKqyLeV1+rvQfo5BkCtqtWowtBSrGjXOI=;
        b=rrHPEDq6tekKmQMdemVSgtjYilzmz2JrbNuqzEWVjcWoJAns88hyxxJ8DVsLqGdtRk
         AQY5RwBtivP5G3jMj7LHXzrpNXGvNZDcX+r52EwPnxt/gvlKWs2+nZ5Kg5LhNIt3mw8K
         CS+dBOHaPBnfFOGCW9epghNXWmyVzz/1hRO15mIyfYg8/W6Tao68UMQOeVQGcC9kin/w
         JuLeMIkYXnDjlz/ME7YMPNl+Gvp4KRVldcO+aqp1Tz30JQxQAS9e1itCGb01dEFt1lph
         cMSzBfILqYt4wf4aa04f/oQ2b0Yqc95dv7PQ2KO/eiqGTq3b/ZjZ6pW5PsvQty1GQ56a
         u/5g==
X-Gm-Message-State: AOAM530FT2GmVolD7zYU4rX8Bv2KvHV6G8rTfmikRoo7nQZ3qD+nPMGb
        /CZwDNiUVNpdik2qz8bd2s9jvd9WCInyFJI+/QFxmg==
X-Google-Smtp-Source: ABdhPJxGe8iAE8YbYMN7tVkNhe/WAF3czL+UFGh8lez+r5fsxvXAhX45du/vIN3DTAzTaNx6xNFTD+9Pj5czeIIDlf4=
X-Received: by 2002:a4a:55cd:: with SMTP id e196mr10982266oob.86.1642291496372;
 Sat, 15 Jan 2022 16:04:56 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-3-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-3-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 16 Jan 2022 01:04:44 +0100
Message-ID: <CACRpkdb3gD5Lhe5awJ43MCwb978a3t0TPRjv+TBZ_MS-E6q8Zg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 4:15 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> In preparation to adding other interfaces, the private data structure
> was renamed to priv. Also, realtek_smi_variant and realtek_smi_ops
> were renamed to realtek_variant and realtek_ops as those structs are
> not SMI specific.
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Fine by me:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
