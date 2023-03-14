Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423046BA28C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjCNWdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjCNWcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:32:53 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74449498AD
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 15:32:46 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id y5so1098396ybu.3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 15:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678833165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71hNDImo50UDsdmGMKaBbNUEM2XUtxv0EHO8ZeCw4RA=;
        b=P5iih/MSTlPOhw418Mr/kwj+wepLC9O72rOSoFau6SpcruwUTwMxQVjewnWj8FtMbd
         tQzTNv//xANtJF+rIFNXtnVuczS++kgQjEFxgcr4TmbuVuIo6gmw6AnDUH6DJzb0vOV+
         +O1/CiiPWjKFlgdhj3RRTCp0zc8zsdqGtKpEvIHmAga8elPsSzFN2LlBOfOQy88j2dNU
         u3pAkglT+vZ+ojFJbV3E0UGhYdJrIipoub853x98wNNwfB4ChJPKMzKcgfqdjqGiIsnM
         hXtLeSlaPz9FCbgP7QHNBeNVWsyqhF3ouaDCmn1/VbqJ4kGnqXuNhyxIwV/rae5oNhcR
         bE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678833165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71hNDImo50UDsdmGMKaBbNUEM2XUtxv0EHO8ZeCw4RA=;
        b=DAfYfSyUl87BvGPUagAjUHMufiCE2yIESZQZMMFEgiISIUcquYAb5EbTvX9+Sp4Cp5
         6Tes9GNQNPJ8cvF/93ncdcni7I6UtJ6tofFEIV7Y0J18iIr3MafTRTA3EcWZEvQq7JFr
         QnXZ9tZvtz9p0Y+a1cZZoFaEpRIV9WrsWJX/Jpf4tvYfOt7J+7y1VPD0J2JaTTxBm9Mx
         iMyl/KON1Ml1W66u1cqULyHOqm+ko2eV8wDwqi2n0KJYqCdC3n9cDUhAAIQj+RiVPOZy
         KaYkbShBQowa868qLDtmDqglf0cswJthPkF/DEDxE9XfRTjRQiKuEf8Y26b4d+TAKC+y
         aSsA==
X-Gm-Message-State: AO0yUKXAp9yq/TszsFKlpImsp27Rrnfo4pC5v5ibl+LnKT5ebpRQpE50
        uFUjaAGc9OCOD41coRcjB64fqyeNHHzrJs+OCBm8GQ==
X-Google-Smtp-Source: AK7set/TvMw9Q/zaEYXvhAdp562bPDVYmqv7Qxy6KUGCJwrd4ywo8yozu8JKAVnhH/6cB1E/uiQwmbqL1rNJsuR6GpY=
X-Received: by 2002:a05:6902:d2:b0:a8f:a6cc:9657 with SMTP id
 i18-20020a05690200d200b00a8fa6cc9657mr19856648ybs.7.1678833165647; Tue, 14
 Mar 2023 15:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230314065802.1532741-1-liuhangbin@gmail.com> <20230314065802.1532741-2-liuhangbin@gmail.com>
In-Reply-To: <20230314065802.1532741-2-liuhangbin@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 14 Mar 2023 18:32:34 -0400
Message-ID: <CAM0EoM=Wcs46vnE81aCt2W8baxi91m8y+t0bzUPL5PEm7PQLDw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] Revert "net/sched: act_api: move TCA_EXT_WARN_MSG
 to the correct hierarchy"
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 2:58=E2=80=AFAM Hangbin Liu <liuhangbin@gmail.com> =
wrote:
>
> This reverts commit 923b2e30dc9cd05931da0f64e2e23d040865c035.
>
> This is not a correct fix as TCA_EXT_WARN_MSG is not a hierarchy to
> TCA_ACT_TAB. I didn't notice the TC actions use different enum when addin=
g
> TCA_EXT_WARN_MSG. To fix the difference I will add a new WARN enum in
> TCA_ROOT_MAX as Jamal suggested.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal


> ---
>  net/sched/act_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 34c508675041..fce522886099 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1596,12 +1596,12 @@ static int tca_get_fill(struct sk_buff *skb, stru=
ct tc_action *actions[],
>         if (tcf_action_dump(skb, actions, bind, ref, false) < 0)
>                 goto out_nlmsg_trim;
>
> +       nla_nest_end(skb, nest);
> +
>         if (extack && extack->_msg &&
>             nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
>                 goto out_nlmsg_trim;
>
> -       nla_nest_end(skb, nest);
> -
>         nlh->nlmsg_len =3D skb_tail_pointer(skb) - b;
>
>         return skb->len;
> --
> 2.38.1
>
