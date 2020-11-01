Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AF42A2264
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgKAXeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbgKAXeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:34:15 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02269C0617A6;
        Sun,  1 Nov 2020 15:34:15 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id a9so12495087wrg.12;
        Sun, 01 Nov 2020 15:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nB17pwnP57+tQkhNWeBukL2LccU7GhHBJWPWrm23bd8=;
        b=Q8B3+lhAFq8lPty1RxuU9aYRmf1hAmGt4bliiJFz+86Ubmn93MgaUB/vznfzZaQsqn
         gJMPUnDGzjcGRtWJhn+TIabl51oYJgBR/uelQsuWh3DT0t9HOQKuF9c3niRjoSoSduZM
         RbQ934G+x8PUx7JP7vQ/qL2XcZz8ijFR1z4MXkriEn77GzkpU+wlABxryOPC+q1EJnVQ
         W6uOQb2EVx5P9UydE02hPBpgT5mruz+KRgOCsH6LsvjNbNKr6dA+HpSh6Xpv1EhVwufY
         smvarHS5G8v9+Lhs+cDuMLICOCGcx2SOskmSrWZGF035n5v8U6MUEqDJUkclf1XcYzXq
         vPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nB17pwnP57+tQkhNWeBukL2LccU7GhHBJWPWrm23bd8=;
        b=dAPUzgPVP0nYKx29Ge6+9zwQ6LeVfNCzTmJ1Uuun22os8IRdeFr09q6fMjyll8rJAo
         9BrD3pYROMgFDynD3rPO61PM63M5BMlJnxRQdg+GirHRaDc9cv6Sb16BDVKnTl5nOMbq
         OkuohU/bpsZnJ6qzRvyRXn1UPdWkfIUVz6PK4GloELgObZrvbCr5UW85pAXxNP5DQJOp
         bD0DUZS0H5Ekr4Wj4QHs75YBZFGG+BM/avosRU54zQZrlu519xGfddnQ9k43IirCXD0N
         0pqHiUzEko7MCcMP7YJ7gx0vhayFVNB+CIRjHtKf7k6/DcJ3x4z8OU3acM8YKM5VzBg0
         gb8g==
X-Gm-Message-State: AOAM533A8UhSzXVI2gB7o1BHElO03+AMsFXYOI/bQr0f33I9e0GSUQYK
        3roRk+RDyvN/im+8g9NTi8g=
X-Google-Smtp-Source: ABdhPJyCWs7cgF14HN/r+6VxCNSItinGyqgNmvq8VSl3sUK1kGJtanF0dqMXUF58AwX7bcXEcnM9TQ==
X-Received: by 2002:a5d:6cc9:: with SMTP id c9mr18057648wrc.276.1604273653756;
        Sun, 01 Nov 2020 15:34:13 -0800 (PST)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id v67sm13380559wma.17.2020.11.01.15.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 15:34:13 -0800 (PST)
Subject: Re: [PATCH] xfrm/compat: Remove use of kmalloc_track_caller
To:     Alistair Delva <adelva@google.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team@android.com,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <20201101220845.2391858-1-adelva@google.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <1a85a545-a663-828a-387e-fd4a0e2ae747@gmail.com>
Date:   Sun, 1 Nov 2020 23:34:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201101220845.2391858-1-adelva@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/20 10:08 PM, Alistair Delva wrote:
> The __kmalloc_track_caller symbol is not exported if SLUB/SLOB are
> enabled instead of SLAB, which breaks the build on such configs when
> CONFIG_XFRM_USER_COMPAT=m.
> 
> ERROR: "__kmalloc_track_caller" [net/xfrm/xfrm_compat.ko] undefined!
> 
> Other users of this symbol are 'bool' options, but changing this to
> bool would require XFRM_USER to be built in as well, which doesn't
> seem worth it. Go back to kmalloc().
> 
> Fixes: 96392ee5a13b9 ("xfrm/compat: Translate 32-bit user_policy from sockptr")
> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Cc: Maciej Żenczykowski <maze@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Alistair Delva <adelva@google.com>

Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>

Thank you!

--
          Dmitry
