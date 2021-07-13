Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E363C6B52
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 09:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhGMHke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 03:40:34 -0400
Received: from mx-lax3-2.ucr.edu ([169.235.156.37]:8335 "EHLO
        mx-lax3-2.ucr.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhGMHkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 03:40:33 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2021 03:40:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626161864; x=1657697864;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=Uy3h8jSbfs/h+jDYaxXZtCw4dzE0irLxzHb3QVi8SvA=;
  b=M1q3vWle0xUOVXvtVGKKzQxGKC1FKA4/dw512lxzLuDWMeLw/UhIpTY8
   PUhJpJr+8C8Ebk2Wc2x3hYeFOlDmvK9//SoEzafgLtzAwSHonPVBcoYI6
   Iqn08otHWzwuqXYgcRk8iWs+exjg2QrlQjpXOqwLGlObzUaTUPpr1KSAP
   /8FKTv9i2MwQx0fAEgszwmq6bim0FajN+bnhBSF5j8QqjbwD4iV1coQZ2
   Rk+rqdzWvEkRNpTzr+TjQuslJUPoFrZWXG/7x1M1QfuawByW0I710A1EF
   RsegzLhVNX5fsO//5MskKbUPJfhYXSneKmGOsm3Rxsy24IQQ/C1L/PtAU
   Q==;
IronPort-SDR: l1QjJMp1rLxGL2MjasTXzIq9bgm4UOtURImyNDx5g09cdmL1fGMay13pieze1csoZyHzEBZXVG
 EP1dzWNNch/7+zpKn5HXZkSKrsAxxFubAqwnfM+rYeVj1uNJ8lZi8PaG+2mjG1ObWTyIsZjw0C
 +r3MAj1eoxSmZ2xOozB3DxO/ozNuiEjzzkh5b3XOeRtG3dCq5kC9POJ9epbCM6uDMtfuFrgtZR
 BCDSprpRz8I6ZbFjJkSBVA0IHvF1x5/YGH1IoQwpr5O1knvNXOYfF/y/8nEXnAxmCpWdfG46tR
 FEs=
X-IPAS-Result: =?us-ascii?q?A2GjAgAsQO1gdMenVdFaHgEBCxIMQIFOC4N4bIRIkVwDl?=
 =?us-ascii?q?huFP4F8AgkBAQEPQQQBAYRUAoJ5AiU0CQ4CBAEBAQEDAgMBAQEBBQEBBgEBA?=
 =?us-ascii?q?QEBAQUEAQECEAFvhS9GgjgpAYNtAQEBAxIRBFIQCwsNAgImAgIiEgEFARwGE?=
 =?us-ascii?q?yKFV5tTgQQ9izJ/M4EBiCEBCQ2BYxJ+KocJhmIngimBS4EFgWo+h1uCZASDG?=
 =?us-ascii?q?UxVOFuBP0BTAQEBnwqadoIPAQYCgwocnjQrg2ORV0KQWC2UR6BihUkQI4E4g?=
 =?us-ascii?q?hUzGiV/BmeBS1AZDod/hiwWjkwkLzgCBgoBAQMJh2cBAQ?=
IronPort-PHdr: A9a23:iEcRkRSPnOA38OHj3KxO4xqvmNpsoqSfAWYlg6HPa5pwe6iut67vI
 FbYra00ygOTBcOCt7ka1aKW6/mmBTVRp87Z8TgrS99lb1c9k8IYnggtUoauKHbQC7rUVRE8B
 9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUhrwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9I
 RmosQndrNQajIRtJqswyxbCv39Ed/hLyW9yKl+fghLx6t2s8JJ/9ihbpu4s+dNHXajmZaozU
 KZWDC4hM2A75c3rsQfMQA6S7XYCUWsYjwRFDRHd4B71Qpn+vC36tvFg2CaBJs35Uao0WTW54
 Kh1ThLjlToKOCQ48GHTjcxwkb5brRe8rBFx34LYfIeYP+dlc6jDYd0VW3ZOXsdJVyxAHIy8a
 ZcPD/EcNupctoXxukcCoQe7CQSqGejhyCJHhmXu0KI13eQuEwHI0gIjEdwTrnrbsM74NLsOX
 e2v0KXE0SnPYvFQ1Dzg6IbIaBchofSUUL1xcMre004vGB/FjlqOr4zuIjCa1uMQs2OG6OdhW
 uOui2k6qw1tvzSixNwhipTViYIP0FzL6zh2wJssKNC+VUV0bsKqHoFKuCGGK4t5XNkiQ2dwt
 Ss11LAKpZC2cSoJxZkmyRPRZPyJfoqK7x7/VOucPzR1iXN4db+xhxi/8ketxOPyW8S2zlpGs
 jZIn9jCuH4NyxDe7NWMRPhl/kq5xzqDywTe5vtHLE00j6bXNp8sz7wqmpYOtUnOGin7k1jsg
 qCMbEUr4O2o5vziYrXhu5CTKZd5ihr7MqQygsy/Bvk4MhQWU2ib5+u80Lrj8FX8QLpQj/02l
 rDVsJfbJcgGv6K5DRJZ34In5hqlADem19MYnXYDLF1bYh6Ik4/pO1TWLPD5C/ewnUisnS91y
 /zaOrDtGJbAI3jZnLv8fLtw6VRQxBc3wN1b/55UD6sOIPP3Wk//rtzYCRo5PhS7wufmD9V9y
 58SVX+ND6KCLaPdrUWI6vgxLOaReY8ZoCz9JOQ95/7ykX85nkcQfa+30psLdX+3AOpmLl6HY
 XrjnNgBC30GvgkgQ+zwjl2NTzpTa2y1X6Im6TFoQL6hWKjZS4/lo5zJiCihE5J+ZXpBA1DKG
 nDtIdaqQfAJPRKTK8hqkjECHYqmVsd1xQOpqVejlJJ6JfCS9yEF48GwnONp7vHewElhvQd/C
 N6QhiTUFzkcow==
IronPort-HdrOrdr: A9a23:VydHh6B8tcbo/HTlHemX55DYdb4zR+YMi2TDGXoBMCC9E/bo7/
 xG885rsCMc5AxhOk3I3OrwW5VoIkm8yXcW2/h0AV7KZmCP01dAbrsD0WKI+UyGJ8SRzJ866U
 6iScVD4R/LZ2SSQfyU3OBwKbpP/OW6
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="53784583"
Received: from mail-oi1-f199.google.com ([209.85.167.199])
  by smtp-lax3-2.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2021 00:30:37 -0700
Received: by mail-oi1-f199.google.com with SMTP id n84-20020acaef570000b029022053bcedd7so14753378oih.17
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 00:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDD2Q+fBWLzKLVqo6MihicdQ+2ekQXHH6v82dt1m7ug=;
        b=BQiop+lXWrFoks6f4Ls+hT38aU0kRJOngcybQ0Sziai5KONwctbH71sUahc7CNAwCh
         dYwAtH//3VDGl5G2+4bCegbaF/e5/410TrdhhMpHc0XkeRH99akzy82rEyitnqN+6s/a
         E4W+IYkwPirT7T+u43YSznhMpe9Kt5W01pyIWrUurHdhvsfRXtAiNeVDOysImyNKSTn1
         maUG6Z75HzAKxGkhCODD2lI8ZkormIiXJKPA+nWdRtrwLiR3Ue6OmT3qd+X+PJFMY/Er
         8o/wPtQLXq+xtP/a6plvingLQ5a0cjwv/jhxj0m9lYlrA34r3VEeBRv2MS+fzu/ikywc
         HkPQ==
X-Gm-Message-State: AOAM533a6pyF+v50AetKAT6kPfqQeyPGeivucXTXyJEmFyqed/3GqmDS
        9dQY0EzFu1Lv4mxh/rtRyslyItIEUQf375HZQkYdG61hM6ERoJ5v5eMQCUGJ9h5EPVervXngDg4
        RAOvG9vUbaaHrqp19Cim+hIf11c07FT1a9Q==
X-Received: by 2002:a05:6830:1604:: with SMTP id g4mr2357899otr.57.1626161436684;
        Tue, 13 Jul 2021 00:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV3NlabbiVN4+hSJ2ftBWmY3gwiUebuedfsGMLB8buEyZLOA0TyY1lXUMhXESUXtUWj6GuSM/9a0TgGVowM5Y=
X-Received: by 2002:a05:6830:1604:: with SMTP id g4mr2357887otr.57.1626161436495;
 Tue, 13 Jul 2021 00:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
 <YO0Z7s8p7CoetxdW@kroah.com>
In-Reply-To: <YO0Z7s8p7CoetxdW@kroah.com>
From:   Xiaochen Zou <xzou017@ucr.edu>
Date:   Tue, 13 Jul 2021 00:30:34 -0700
Message-ID: <CAE1SXrv2Et9icDf2NesjWmrwbjXL8067Y=D3RnwqpEeZT4OgTg@mail.gmail.com>
Subject: Re: Use-after-free access in j1939_session_deactivate
To:     Greg KH <greg@kroah.com>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

j1939_session_destroy() will free both session and session->priv. It
leads to multiple use-after-free read and write in
j1939_session_deactivate() when session was freed in
j1939_session_deactivate_locked(). The free chain is
j1939_session_deactivate_locked()->
j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
To fix this bug, I moved j1939_session_put() behind
j1939_session_deactivate_locked() and guarded it with a check of
active since the session would be freed only if active is true.

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index e5f1a56994c6..b6448f29a4bd 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1018,7 +1018,6 @@ static bool
j1939_session_deactivate_locked(struct j1939_session *session)

        list_del_init(&session->active_session_list_entry);
        session->state = J1939_SESSION_DONE;
-       j1939_session_put(session);
    }

    return active;
@@ -1031,6 +1030,9 @@ static bool j1939_session_deactivate(struct
j1939_session *session)
    j1939_session_list_lock(session->priv);
    active = j1939_session_deactivate_locked(session);
    j1939_session_list_unlock(session->priv);
+   if (active) {
+       j1939_session_put(session);
+   }

    return active;
 }
@@ -2021,6 +2023,7 @@ void j1939_simple_recv(struct j1939_priv *priv,
struct sk_buff *skb)
 int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
 {
    struct j1939_session *session, *saved;
+   bool active;

    netdev_dbg(priv->ndev, "%s, sk: %p\n", __func__, sk);
    j1939_session_list_lock(priv);
@@ -2030,7 +2033,10 @@ int j1939_cancel_active_session(struct
j1939_priv *priv, struct sock *sk)
        if (!sk || sk == session->sk) {
            j1939_session_timers_cancel(session);
            session->err = ESHUTDOWN;
-           j1939_session_deactivate_locked(session);
+           active = j1939_session_deactivate_locked(session);
+           if (active) {
+               j1939_session_put(session);
+           }
        }
    }
    j1939_session_list_unlock(priv);

On Mon, Jul 12, 2021 at 9:44 PM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jul 12, 2021 at 03:40:46PM -0700, Xiaochen Zou wrote:
> > Hi,
> > It looks like there are multiple use-after-free accesses in
> > j1939_session_deactivate()
> >
> > static bool j1939_session_deactivate(struct j1939_session *session)
> > {
> > bool active;
> >
> > j1939_session_list_lock(session->priv);
> > active = j1939_session_deactivate_locked(session); //session can be freed inside
> > j1939_session_list_unlock(session->priv); // It causes UAF read and write
> >
> > return active;
> > }
> >
> > session can be freed by
> > j1939_session_deactivate_locked->j1939_session_put->__j1939_session_release->j1939_session_destroy->kfree.
> > Therefore it makes the unlock function perform UAF access.
>
> Great, can you make up a patch to fix this issue so you can get credit
> for finding and solving it?
>
> thanks,
>
> greg k-h



-- 
Xiaochen Zou
PhD Student
Department of Computer Science & Engineering
University of California, Riverside
