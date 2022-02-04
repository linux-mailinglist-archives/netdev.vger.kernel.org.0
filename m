Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A04AA4AF
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348258AbiBDX4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiBDX4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:56:01 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF27FD84F2A8
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 15:55:58 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id p5so23075122ybd.13
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 15:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hU7+++80ZQGVtClKOSpjWvtkInG8OIuUAkAd6zDx/3s=;
        b=lsaXSh+1gvGwFFQcoUdEabpse1je3SsV9NXSRZb4leG+5j0b/Um/j951A9MY/tnmPH
         EC7Dj0651kGkuAunvT6QHFBwaC3PnpZ6qdsW7WHHq9wqpq8wW3dhDOGf+58lpGdyxqhw
         2mHBqHg44BWQ2mG5ed1IT/Atj6t7LJr9IpYiiO6GxajvDpW/27Qaxk4Mfs3WqfIQTb38
         ZLHaRdbdbUiYT9QZX/vdyKCu3DHcxICH1D6ksTYcc2p1tMqZTYrXkqxS1NpkCPuWEMcZ
         gwaVt4ae7znvvk+JCPJb1YQrkISQkBldXv8h3c9oDvBQUtYR6Fs6h7HSLjv9AU9RO92S
         Qe0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hU7+++80ZQGVtClKOSpjWvtkInG8OIuUAkAd6zDx/3s=;
        b=BLPj+tyIlZq3xkoo+PX3NwqdRoo3kKxdFOKmvlSLvha/4cDP2tmKxI4O1k8o3+k898
         gAYEP0BUpeJFEDcw5uIuoeGmo19Kvm+v/KZPBqFHE2t0Pt+F6BxNuu8cROd4fQI05d7Z
         EDEL7TNYO/CqCHCxw8aTqec5giuAKIO5KvIUYb7P0isS2NW2m1zdigNeQys8yhpbDwdy
         MXrTKZHHfeNcp9lL9ngSftGFnJ9dmhK+bW+LWbh3ODcidcDc6w2KEmn94wM8hvp1reUj
         UGnYe7wqPa52bigMqIqrfol5MCuotAlWq5omr/Qqzx3it8mxl6y1IT5L7c+cvnvlQDFN
         y+6Q==
X-Gm-Message-State: AOAM531Iq7/ryhe//tZJuxUp2VKWcPTi2MZ0B6Bw+Ir1BVpHWo3KhAM/
        BgfmeETDY5XDN6dOXkIBLRYgTsRxQdT+aIRcb8nf7A==
X-Google-Smtp-Source: ABdhPJyLQ6IXC9HHW/GwkQBib4dAsuTPdKyues5W6TXkcgTRb3jMMh55Yvh1/T9JcfFJCKDbVaYjcpVhP/+j3EL4bnM=
X-Received: by 2002:a81:9f12:: with SMTP id s18mr364774ywn.448.1644018958270;
 Fri, 04 Feb 2022 15:55:58 -0800 (PST)
MIME-Version: 1.0
References: <20220204155927.2393749-1-kuba@kernel.org>
In-Reply-To: <20220204155927.2393749-1-kuba@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 5 Feb 2022 00:55:47 +0100
Message-ID: <CACRpkdbfbKNzbSt_TiFq4Ji6zq1tLetW3f9=GjsFJypbihMU-g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: don't default Kconfigs to y
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 4:59 PM Jakub Kicinski <kuba@kernel.org> wrote:

> We generally default the vendor to y and the drivers itself
> to n. NET_DSA_REALTEK, however, selects a whole bunch of things,
> so it's not a pure "vendor selection" knob. Let's default it all
> to n.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Fair enough,
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
