Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A702506033
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbiDRX2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiDRX2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:28:16 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0F3201AD
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:25:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g20so19142059edw.6
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OAY9roQluBR/HPXNbf0AZodC76McxJL6e+UEQX7ux5A=;
        b=FD81+iWVMZ62tpjKpkz7Xzi+WZGOkWyk3vQEEViAPSTyxdRnLFKdTrT6YLagGEaGDR
         oyBHcgeJVmzPlbajLpEVm+M02W9kP81p3KiL86is2sfsnMIQs/hiFvTwPvBhOx7nvBPv
         SxoypjX49r6aJflZTOgL24M5mlLh5HKNS9ECRSCrhGSnGE4VpYk/qkapgDUQaB/oqtMA
         PXjZmnywkZxEtD3wgxuwFWRlslzpqM18PM424nO+aZBqHdE2UBbpdChbuUQu7+300DIz
         KqHqya9qeEQ3V/e6V6VaD6VRKvBMPx4ig5othm4pat4P7xzzvjbu2QGELmp9Q8NRA9v4
         ngkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OAY9roQluBR/HPXNbf0AZodC76McxJL6e+UEQX7ux5A=;
        b=kDHOWeUbJfSlgTDZlAPfKXeCTFtq/dT7lDYQtH38ThpLp+gjwDxCZCOb6mmgErlZQK
         XU0BCaz+e5xKDM6GhX+f90YNyDN/8MxsQ3SX8e422SUaZ58U18T1EaJyh0D/5VxQyR8z
         DFrmAwbSTZasDYPiWht3oiG9/zEJbKY4EkyCAm8/vY1N6HevFbS4rjERQ842vnjUjjfh
         MA3NsXjc395hnNt9mZBPil4mEqxRuR30xWw0HG9sVfDb+bExAMZWlUnqVgu9mHPZotHQ
         XWp0BvXHycWa2uwu5gVVTtxXbF7t1dCeYHQOvcKAQB/tg+3lbrQk7uJ+y0jRZmI5F2f7
         VICw==
X-Gm-Message-State: AOAM530ETco4QikHKAJB01sylw/1BfYjej6ZyZp0jfZrijEOXHco8Ne1
        I6QZsF3fnr2qAdXMhALCnKdgfrkVnEV5BR7+jhhr1Qu5
X-Google-Smtp-Source: ABdhPJwORQEUMQzOK0CW3TkOKigu6doL9o93c6V1tDNff09NTrRQwdGpnl5HWHSLuMUGzmfoYUrdAJaOsGJWL+kMdVQ=
X-Received: by 2002:a05:6402:2789:b0:423:fe09:c252 with SMTP id
 b9-20020a056402278900b00423fe09c252mr686746ede.11.1650324334843; Mon, 18 Apr
 2022 16:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220418080642.4093224e@hermes.local> <20220418221854.1827-1-gasmibal@gmail.com>
 <20220418161513.1448e5f9@hermes.local>
In-Reply-To: <20220418161513.1448e5f9@hermes.local>
From:   Baligh GASMI <gasmibal@gmail.com>
Date:   Tue, 19 Apr 2022 01:25:24 +0200
Message-ID: <CALxDnQZ+Lj0QJJR2BKgf+B8=24ZcqJMKw-SZX7n+apu10h8jfg@mail.gmail.com>
Subject: Re: [PATCH v2] ip/iplink_virt_wifi: add support for virt_wifi
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I didn't catch that !

Le mar. 19 avr. 2022 =C3=A0 01:15, Stephen Hemminger
<stephen@networkplumber.org> a =C3=A9crit :
>
> On Tue, 19 Apr 2022 00:18:54 +0200
> Baligh Gasmi <gasmibal@gmail.com> wrote:
>
> > +/*
> > + * iplink_virt_wifi.c        A fake implementation of cfg80211_ops tha=
t can be tacked
> > + *                      on to an ethernet net_device to make it appear=
 as a
> > + *                      wireless connection.
> > + *
> > + * Authors:            Baligh Gasmi <gasmibal@gmail.com>
> > + *
> > + * SPDX-License-Identifier: GPL-2.0
> > + */
>
> The SPDX License Id must be first line of the file.
