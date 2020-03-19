Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363D218C36E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgCSXCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:02:50 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33529 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgCSXCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 19:02:50 -0400
Received: by mail-io1-f65.google.com with SMTP id o127so4180199iof.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hR+XK2zRPLgVTwAf7qPvlWm9tn+TvLr43X7/s0p04PY=;
        b=PY65ki+RCJ2Hnod7S2negtRzqojq+en0hmlTgsFf2Spqd+YZMSeesWkkP/9G79Dzia
         VjIOcPfMEK4TFX8IbR59tHC+EKSTLWj0g4z7Oi8X3mFNYopF7VsrjpSpAO4J9TpYzGWQ
         uPG2nksCJjaP/xWDBgabu9yEi0lPUDsJGH59ZGgeXSzFwajFAPsvK4yIkcTh0gYLwHtZ
         cIq5AnreXf4HO6M/f2tpZ3oKt6tzHBiXDWbtdfINNdShq3OZOVY8WqklWv4fwtJ7pvVF
         0EmS/1xmOrvU7iZlIhct83tSJLXOhLuNiWwhPNzgawgUndkzJMDpwsb/N2IqfuVkU9pt
         rs9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hR+XK2zRPLgVTwAf7qPvlWm9tn+TvLr43X7/s0p04PY=;
        b=ohljVzg9lRV8iQNEGxq/RUod7SX14zTV+dgjimM9nohAhJWrEi68ykm/EQykEAJdot
         XZhYlDBnWumg5r+sMbnmN2wmG5D3Dr/WDW8ycC3T3MwDxyWBIGrtGNKcCEXGiopjtCDl
         p1tIx49xNhcwa6Jk3dsjj2JahRZ/7nx/Ekb1Twdlj3dzAEngpAgfJ/FzG5USahOiWoMI
         2NUk9kxRDmj+pQyT43sR8UDu7SDRlgNCgbpN7GURh4M5DlXS03aEGOAEklcRd2p4GkfV
         zjhX3dX0AR2V1ixqVOy7q8KtpZN6VFNjl7L0G7RkUfc6xyQt5kdeaMJq3YojPIXyJkTX
         qEbg==
X-Gm-Message-State: ANhLgQ0UYYNGfp9x1KloQicIA7hrPxQOE52NfhWM3O/Tik2F3/3UIVkM
        00uHl5B+DkBGnsBTyCEMATzhu+Kr+cSfXrIpLdw=
X-Google-Smtp-Source: ADFU+vsMA7ybJUaT+Bez2lJMLfNZNroktp0vL8J60Q3DAq4E2sQDV9Z3g0kPKM7t4DNrrLNzL49ks/6eQedAKFCWW/Y=
X-Received: by 2002:a6b:f616:: with SMTP id n22mr4939892ioh.100.1584658968834;
 Thu, 19 Mar 2020 16:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi>
In-Reply-To: <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 19 Mar 2020 16:02:36 -0700
Message-ID: <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com>
Subject: Re: [RFC PATCH 28/28] tcp: AccECN sysctl documentation
To:     =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 2:44 AM Ilpo J=C3=A4rvinen <ilpo.jarvinen@helsinki.=
fi> wrote:
>
> From: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> ---
>  Documentation/networking/ip-sysctl.txt | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/netwo=
rking/ip-sysctl.txt
> index 5f53faff4e25..ecca6e1d6bea 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -301,15 +301,21 @@ tcp_ecn - INTEGER
>                 0 Disable ECN.  Neither initiate nor accept ECN.
>                 1 Enable ECN when requested by incoming connections and
>                   also request ECN on outgoing connection attempts.
> -               2 Enable ECN when requested by incoming connections
> +               2 Enable ECN or AccECN when requested by incoming connect=
ions
>                   but do not request ECN on outgoing connections.

Changing existing user-behavior for this default seems to be overly
optimistic. Useful for testing, but...

> +               3 Enable AccECN when requested by incoming connections an=
d
> +                 also request AccECN on outgoing connection attempts.
> +           0x102 Enable AccECN in optionless mode for incoming connectio=
ns.
> +           0x103 Enable AccECN in optionless mode for incoming and outgo=
ing
> +                 connections.

In terms of the logic bits here, it might make more sense

0: disable ecn
1: enable std ecn on in or out
2: enable std ecn when requested on in (the default)
3: essentially unused
4: enable accecn when requested on in
5: enable std ecn and accecn on in or out
6: enable accecn and ecn on in but not out

Do we have any data on how often the tcp ns bit is a source of
firewalling problems yet?

0x102 strikes me as a bit more magical than required and I don't know
what optionless means in this context.

>         Default: 2
>
>  tcp_ecn_fallback - BOOLEAN
>         If the kernel detects that ECN connection misbehaves, enable fall
>         back to non-ECN. Currently, this knob implements the fallback
> -       from RFC3168, section 6.1.1.1., but we reserve that in future,
> -       additional detection mechanisms could be implemented under this
> +       from RFC3168, section 6.1.1.1., as well as the ECT codepoint mang=
ling
> +       detection during the Accurate ECN handshake, but we reserve that =
in
> +       future, additional detection mechanisms could be implemented unde=
r this
>         knob. The value is not used, if tcp_ecn or per route (or congesti=
on
>         control) ECN settings are disabled.
>         Default: 1 (fallback enabled)
> --
> 2.20.1
>


--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
