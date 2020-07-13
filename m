Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B621DDA5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgGMQlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729751AbgGMQlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:41:01 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207D5C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:41:01 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d18so14232647edv.6
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mOu6GN+slsBAhHIGVG69lzKtdenfqSTBNEpbUiVasfs=;
        b=rN6+2Q4t7Elx7Ffz3Y7x48D5i4IzRzyVu1c1mUAtOi9kiq/sJT0lH3Qryk8VcVLUt4
         F4B9AZWJe6tXFrxr7Z6jR4ZJQv+pF8lAabtAzka9lj3t74axVfk9tzAO4fVz8Rx9jxmR
         CBcB5pFB+JDb41JdfAQN6/Wv+5oZzsLF9ru/jlz4fJeWHeXSAJWk47tmONU55NotJLvH
         tMI7CVqWB2zgyuaNfn2LsqFDFCbbSAUJdDT+o/Y3L15dXgvoUcr3Y1AZlnn+fqTDUNj6
         iqGI2l7xi/y2BV8NvQtBUwBaa5uegvHP4/vJQ7m+g/caKWz2IYw8qycMUWar1QjS8IjK
         P9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mOu6GN+slsBAhHIGVG69lzKtdenfqSTBNEpbUiVasfs=;
        b=Zg0/ymfcCgOn8q5xhxPre4j2VKP4keABeCNm0UrX/xT9wpp9jKlI/lLcWPUgUTS/xQ
         x42mCKkbZgb5ZYm1qpL6DjIZf+HXt4XmYP1aA8mFv8/sXCBuciLsz2xvr/x5D/rGh+Fr
         vbycOH8FXsapub/SiYLVJQEHS3y9pUnqp3RSXweISv5PsCt9a5b4coUTbgmOmra3sxPA
         LYfiDDW6LOi/O8IqBaKNVTxfjXnQBcsHBDlktq+3rxaJX92L6R6MUGUesDwxq/jFeJ5b
         PpNx16W3iAZeKuCDU2dwQD+bCSZh0spj+5dFmvYpouZOFx1Dxj4QK2ClZNwA1ByBvjnY
         hYtA==
X-Gm-Message-State: AOAM531vOdO6nvBO1DljRYf2icBCrCJUwcxvLSJd20ASXFbwf8FZ6YKz
        1hK58Od78x/NRA9fFm25uZ2pYwu6EcedN91cedI+
X-Google-Smtp-Source: ABdhPJwRRu5zdqqtrVqWAFw93tonXXoMPxDS7KIv/LFhCDILmmRVQBMdgluyZsZqj4xVF1PRyW+UrdYZ20R0QTeQRtU=
X-Received: by 2002:a05:6402:13d0:: with SMTP id a16mr245466edx.269.1594658459742;
 Mon, 13 Jul 2020 09:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200712231516.1139335-1-andrew@lunn.ch> <20200712231516.1139335-12-andrew@lunn.ch>
In-Reply-To: <20200712231516.1139335-12-andrew@lunn.ch>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 13 Jul 2020 12:40:48 -0400
Message-ID: <CAHC9VhQ+eZSUAmE9kTkcR1B6YwXDzD8LNXSQhH7yrcFhKHDERA@mail.gmail.com>
Subject: Re: [PATCH net-next 11/20] net: netlabel: kerneldoc fixes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 7:15 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Simple fixes which require no deep knowledge of the code.
>
> Cc: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/netlabel/netlabel_domainhash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good to me, thanks!

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
> index a1f2320ecc16..d07de2c0fbc7 100644
> --- a/net/netlabel/netlabel_domainhash.c
> +++ b/net/netlabel/netlabel_domainhash.c
> @@ -92,7 +92,7 @@ static void netlbl_domhsh_free_entry(struct rcu_head *entry)
>
>  /**
>   * netlbl_domhsh_hash - Hashing function for the domain hash table
> - * @domain: the domain name to hash
> + * @key: the domain name to hash
>   *
>   * Description:
>   * This is the hashing function for the domain hash table, it returns the
> --
> 2.27.0.rc2

-- 
paul moore
www.paul-moore.com
