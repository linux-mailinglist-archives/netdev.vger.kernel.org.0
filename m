Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794E429D94D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389509AbgJ1WuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389457AbgJ1Wsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:48:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2354FC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:48:51 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k1so1134188ilc.10
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Re/UT/lD1btXzKj5INuIQiPY14aiwsGew+s07I/GJQo=;
        b=X+9FjK/e2Bw7J8qRb/CJgAvsmeCtDe2QTNCSaa1q+bqXwQB1LLb3epkC0xtQyptONc
         EGbz7Ik4XOmZTH3i6rUNIXupLGd9c9ISDGGCpspPpKrDH4kz9yU1gyKvEhbgbeKJKotN
         bGfSR+z27dU56tKdJ+AzW0zGz2FmI5NAQagnRgtuQt5x02O8a8qgJ8kqFZH09RcYJ2VB
         jxZmmhid3e9n7cztfkTjnGuQKDGH1gmYPiv87vrZ+OogGVvhacdqGV9nlbuI4+Cx6GZh
         VrSuw2fEH0xP1A2mNy7zhinUVGqpU7I+0Wlu6gTXzHsLnI5+RFsAzqbDgT5t3fxn/sOC
         mGUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Re/UT/lD1btXzKj5INuIQiPY14aiwsGew+s07I/GJQo=;
        b=cYSibWwp/8hb4Yi1DZ38jpgBIDKqh7c4bYobVKFomWmav3rK9R2E1QYzoyniDV8/L/
         MOKQhBoWKg9Ab8IsWyx5YcMEP9sHzLYBslCukZfnmL8XrHoCVnp1JBJZqwc9aEP8c+UQ
         ae7w/BxJA4pJITwNSsC8sTxmXzkBPuhDmKGEn49bTRTiIuojh23jWcWzGZdgRhUA5Gfq
         MWJXlRpMjxBmih0gum9hWs4wTPTkgSuaQXJmk8R5PCNRQ1xE67pRCGPZWPbiyd3iCzxr
         zc2QrpinSArbfYJ+k1fh/kb1VMExbTsr9j7WVYDBhi7VUP2g0/wuIzWPVfTGGvossYcq
         BoyA==
X-Gm-Message-State: AOAM530G5ErYxr2ffn9d0dmOla9w8TqOBCGDndZPiqALlbrOA75JhTYr
        YZasS5AgaDth7o+Eu/FVLSPzBGn49vg=
X-Google-Smtp-Source: ABdhPJzYf0Rac+wIt9KothLGP4bY869mEMKuHLvtOu2ov8qWJMZ8FrgDsmmnSXBo6eQ8wR4jSgYVaA==
X-Received: by 2002:a6b:3c14:: with SMTP id k20mr4541772iob.12.1603853198931;
        Tue, 27 Oct 2020 19:46:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f994:8208:36cb:5fef])
        by smtp.googlemail.com with ESMTPSA id m2sm1669214ion.44.2020.10.27.19.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 19:46:37 -0700 (PDT)
Subject: Re: [PATCH net-next] net: l3mdev: Fix kerneldoc warning
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
References: <20201028005059.930192-1-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b25d48ef-aa8c-89e6-fa99-28155b548877@gmail.com>
Date:   Tue, 27 Oct 2020 20:46:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201028005059.930192-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 6:50 PM, Andrew Lunn wrote:
> net/l3mdev/l3mdev.c:249: warning: Function parameter or member 'arg' not described in 'l3mdev_fib_rule_match'
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/l3mdev/l3mdev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
> index 864326f150e2..e07292a4779e 100644
> --- a/net/l3mdev/l3mdev.c
> +++ b/net/l3mdev/l3mdev.c
> @@ -241,6 +241,7 @@ EXPORT_SYMBOL_GPL(l3mdev_link_scope_lookup);
>   *				L3 master device
>   *	@net: network namespace for device index lookup
>   *	@fl:  flow struct
> + *	@arg: store the table the rule matched with here.
>   */
>  
>  int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
> 

Thanks, Andrew.

Reviewed-by: David Ahern <dsahern@kernel.org>
