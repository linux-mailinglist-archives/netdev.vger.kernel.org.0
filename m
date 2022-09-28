Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B875EE1F6
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiI1Qfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiI1Qfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:35:31 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F8C5EDCB
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:35:25 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id u64so2797152ybb.1
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4tFtsj0z9d/FUmvrIlFOfxHDkdtD7aZzSuoKCHMdnZo=;
        b=DjoU13OamdBHfyF4xgdRCDn/2SOPmZLd/nr8bsC+9rzNGrCXUrWt2fTW3EFeN5c9I2
         G3UjvhGlQLX4fUbZ6moLSj2mXGRdrMwLrT2eVq2IRqKzJOdHXG/1Y4gNt4FLCjdVlhrO
         vve4irskh5h1hZs1F//5fUjGs9Ymg+HslNeJwmaZdP6JO3ONLgD4tmt1YdainvJiKCJE
         WNDj+WuwqarF+J2VDi/PkM9lJ+WWmU2iH+tDOXwFJQfZaSbEKKuLYsstuD/tLnEm+DEm
         RwGoRZcgOusQZWtZqB1thelTQ3xTHZomB3iZJ396sd5bx+VvphKVj84MS+Q4SVJdMM3A
         7CRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4tFtsj0z9d/FUmvrIlFOfxHDkdtD7aZzSuoKCHMdnZo=;
        b=KO67ECwhgo9L+WMeLuYjZajPWfRXvvvzTerietIeKKOgHbF61vy9jBcaLu0Zna2ZXF
         JyHwFvj3rhEb0QKQrSyh0MDrvJCMhaEUIi3vcJMAznYZglJjmojClttpQb7Pf+jyIELa
         d8sPS9GPU6LYm/Gp1RRiA+uvIxonaPYnkgwRBdOakB3m9wS/bbM6S1zF6mh2yfIylbVr
         of6YyQiLnGcf7STtuwrzHZ9kCHueUfD0FieyBXVvf5nQPQyOa5Aw6jPgfICbe7rtD8At
         r6FIlg4u/KIgg7kLsQVADhELeqQwauzZjK4HOvxD9lJEeuOzDpeNbhNxD501/RYsqh0N
         vzrQ==
X-Gm-Message-State: ACrzQf3uQ2hRCuPq23w3wNobIzB9XLt7KL3pD1ZysDm+nPFAT9Axd+kv
        QYuvhz7zWjtdmBqtvWnHskqFUh5N80bcrt1OAYewL3vp2Ml72A==
X-Google-Smtp-Source: AMsMyM7DYgzdgQiant36/V5jaSQdobRuNcBcj0dQ8rvufMcjd12lcMXk5RmKMuHIl6/az99f+Hk4Qw9dyph0fCHlh+s=
X-Received: by 2002:a05:6902:10c3:b0:6ae:98b0:b8b1 with SMTP id
 w3-20020a05690210c300b006ae98b0b8b1mr33146135ybu.231.1664382923192; Wed, 28
 Sep 2022 09:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220928161740.1267-1-claudiajkang@gmail.com>
In-Reply-To: <20220928161740.1267-1-claudiajkang@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Sep 2022 09:35:12 -0700
Message-ID: <CANn89i+tQPGj+2cjHEFMbYGqKG=icVa580_gVUYw7Fb2W9sgtA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: remove unused netdev_unregistering()
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 9:17 AM Juhee Kang <claudiajkang@gmail.com> wrote:
>
> A helper function which is netdev_unregistering on nedevice.h is
> no loger used. Thus, netdev_unregistering removes from netdevice.h.
>

I think we could explain a bit more why we think this function was not
really needed.

It was added in commit 8397ed36b7c5 ("net: ipv6: Release route when
device is unregistering")
then later, commit 27c6fa73f93b ("ipv6: Set nexthop flags upon carrier
change") removed the
only user of this helper. The only possible/valid case where we access
dev->reg_state
is in notifiers, and notifiers already have access to the 'event',
being NETDEV_UNREGISTER
or NETDEV_DOWN...


> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
> v2:
>  - v1 link : https://lore.kernel.org/netdev/20220923160937.1912-1-claudiajkang@gmail.com/
>  - Remove netdev_unregistering().
>
>  include/linux/netdevice.h | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 9f42fc871c3b..66d10bcaa6f8 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -5100,11 +5100,6 @@ static inline const char *netdev_name(const struct net_device *dev)
>         return dev->name;
>  }
>
> -static inline bool netdev_unregistering(const struct net_device *dev)
> -{
> -       return dev->reg_state == NETREG_UNREGISTERING;
> -}
> -
>  static inline const char *netdev_reg_state(const struct net_device *dev)
>  {
>         switch (dev->reg_state) {
> --
> 2.34.1
>
