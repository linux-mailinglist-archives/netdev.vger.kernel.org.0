Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328AD58881F
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiHCHmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbiHCHmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:42:47 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB23F21824
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 00:42:42 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-324293f1414so128543787b3.0
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 00:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KCC1H22JfcFImFZ8f0/O3OvqoGicHHaYF6oOYt/EeNg=;
        b=LKDP6HYoD8gOHFhVvDAqBjfzNneb5oJAdTQQPGsnUZQ4ARkPv9mOuO98zVOUSCQC8t
         RgGYIfmeIOdI5hr5u4KfY+TISS1uglXNW1FkWOMrBe9y3zcUXVTb73Y29uGeRoOpJu5I
         nBAO1JxRM1VzjY7nFC21oYS+V3LA25oFwu8MDnzU/L+uUP/zHdEXVtHcq1UVXCDOYiig
         OoJpLIq+QjTl3uPNiaSav+uE/EKfDHIxRuGavFetxeR8B3rEgT2mEiqaSez62PVBnNa0
         RWCY0SU4ht8E9rT39rAIt//aMHZagmCqFXlM59FpE+lR5U9+BJAr87pOK/KHGXlp5lGB
         62kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KCC1H22JfcFImFZ8f0/O3OvqoGicHHaYF6oOYt/EeNg=;
        b=mejp6k+/ILN/Nlp5bB14E0RE8ZumLgHLJcW1ZBfnMDFRpcjNMhyxIOZTntRnDufxWr
         BOgilmN+sBCYkuQ3vU9vQSlNGHYzghN7vEGNmUlHT2mF5KBh0A+tCubbwhzj+J4BWhS2
         6BT7JcjLriACSHcdVH2Oj+3CSal+vlaVz2kG0aKLH287vqTMzVffQx0+M9yK03vzV5I0
         OMrCs7TWHWNVPz1isVczX2ey1LY2vIq0S0Pmc7EeW0J1KuFmCM0vx0MIEEKaNC/Gark4
         13pHkTIXBVhJ4AA5iDFuWrEbRoZZtKNOqX3LyPiZUEqBPoE1Xj+odUTdGH9MYjYuAq+w
         WTmg==
X-Gm-Message-State: ACgBeo1qaHCX5Aqocgrxj3zmDzkn1kOgtfF56xEqzL8EW0x70VggmPZH
        vBLeFwPNesL9FDtEuALBBd0n/gwbEj6thY0PlcJzudYpNIzphdh6
X-Google-Smtp-Source: AA6agR7L9rliVyJ4YzP7LfPWbRwPNWb50DdUKo95gURH0wNt0ydiIT/0OaD9ijOV9atpnPVnuvrTmfDgANf/+tjySKA=
X-Received: by 2002:a81:1204:0:b0:322:7000:4ecb with SMTP id
 4-20020a811204000000b0032270004ecbmr21960785yws.47.1659512561838; Wed, 03 Aug
 2022 00:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220802151932.2830110-1-broonie@kernel.org>
In-Reply-To: <20220802151932.2830110-1-broonie@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 3 Aug 2022 00:42:30 -0700
Message-ID: <CANn89iJ0pRrHQa+c4Rq3kC80zdjT86CAOecMKchURrRuNqMzMg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     broonie@kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 2, 2022 at 8:19 AM <broonie@kernel.org> wrote:
>
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   net/ax25/af_ax25.c
>
> between commit:
>
>   d7c4c9e075f8c ("ax25: fix incorrect dev_tracker usage")
>
> from the net tree and commit:
>
>   d62607c3fe459 ("net: rename reference+tracking helpers")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> diff --cc net/ax25/af_ax25.c
> index 5b5363c99ed50,bbac3cb4dc99d..0000000000000
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@@ -102,7 -102,8 +102,8 @@@ again
>                         ax25_disconnect(s, ENETUNREACH);
>                         s->ax25_dev = NULL;
>                         if (sk->sk_socket) {
> -                               dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
> +                               netdev_put(ax25_dev->dev,
>  -                                         &ax25_dev->dev_tracker);

This part seems wrong.

Commit d7c4c9e075f8c only changed the two spots, one in ax25_release()
and one in ax25_bind()

> ++                                         &ax25->dev_tracker);
>                                 ax25_dev_put(ax25_dev);
>                         }
>                         ax25_cb_del(s);
> @@@ -1065,7 -1066,7 +1066,7 @@@ static int ax25_release(struct socket *
>                         del_timer_sync(&ax25->t3timer);
>                         del_timer_sync(&ax25->idletimer);
>                 }
> -               dev_put_track(ax25_dev->dev, &ax25->dev_tracker);
>  -              netdev_put(ax25_dev->dev, &ax25_dev->dev_tracker);
> ++              netdev_put(ax25_dev->dev, &ax25->dev_tracker);
>                 ax25_dev_put(ax25_dev);
>         }
>
> @@@ -1146,7 -1147,7 +1147,7 @@@ static int ax25_bind(struct socket *soc
>
>         if (ax25_dev) {
>                 ax25_fillin_cb(ax25, ax25_dev);
> -               dev_hold_track(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
>  -              netdev_hold(ax25_dev->dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
> ++              netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
>         }
>
>   done:
