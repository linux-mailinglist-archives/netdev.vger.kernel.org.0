Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF585EE237
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiI1QqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbiI1Qpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:45:41 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD8611157
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:45:11 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c7so14934655ljm.12
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=JU+MseAQlgCttB7UveIJRY2I7khFqs7LYRsfeIcYR6w=;
        b=ZAj3NhppjLRDmiGLh4OeituqeXuKS85gzeQ2aMZPlBMl3AcWHjnnfzjgfVRLvqtRmT
         nEbo8cWOo7a+K6NTXnRLe9SXZoU1CNlCXBv/RxjjjSgF6JLF+0ze6wyDeB5lnhHVjukn
         8xLr9RmJz43AiABYR/ZKZM40JzTLci2HTOsuw7l9jawzhcFMnfg9u5mzrgihwCfLrE7U
         aH81j3+fWRGi4le818Ojr58uwrMYTUCST6FdFvPvm5bxojDnXzRxEmfh9mI8HYPrmBpI
         YgiriMzDglVqe5va6grF4wpoNda1ZrD7aOgI2JB+LfI3Gu48A9JirGw6bXb7qV6uVui0
         di4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=JU+MseAQlgCttB7UveIJRY2I7khFqs7LYRsfeIcYR6w=;
        b=qrhoYKVGHeiagtIk+tMJyQdYJYzxvAMmlzQTYYviBmQtC4TsC/m91jrR4T6KbgcH2e
         5OKq9CQ6fkG7NPUjI6Tam2qMMeUIuNRZEjWVVuI8XlbS52mCy0nxRj5KLVFsYhLCL9id
         HfYl1IeCOxfESOrBkrNGqVhOf3HIet14M8rd/6kcIDqJqb6/lvgaZfX6kGAmTKfH5fc5
         xb9F7BOGKsR5q4D4ydZqzFvnIoGexk3Vaz6cv32O2vhrxGI7LKlnbVAA7Zo/ONZB6IME
         GBt9FcmSSoXFqaZYS8nKkfGjNIx0ni0Lx0BphVbXsjRF1Se0DiwJIIuwgB98vh8Ev8Xl
         25bA==
X-Gm-Message-State: ACrzQf3eg35+KAaCs4AHUeWQGMyIFLXI8yD8gMBtvoEopeEcFHkrEdWY
        Ew/HtD3U+IZudQj6FaIGSn1n/4LV/E47AtwdS4EkbXA5K/smzJMu
X-Google-Smtp-Source: AMsMyM5Rnc90nldwPHa98Ao8Ezat+v4vW2Koy7+/K3s8ZLcHktRgMILjX8kafNs3NCFkl7H2LLkWW84M1yFA9T7Jutg=
X-Received: by 2002:a2e:9018:0:b0:26b:defc:2a19 with SMTP id
 h24-20020a2e9018000000b0026bdefc2a19mr12055658ljg.470.1664383509407; Wed, 28
 Sep 2022 09:45:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220928161740.1267-1-claudiajkang@gmail.com> <CANn89i+tQPGj+2cjHEFMbYGqKG=icVa580_gVUYw7Fb2W9sgtA@mail.gmail.com>
In-Reply-To: <CANn89i+tQPGj+2cjHEFMbYGqKG=icVa580_gVUYw7Fb2W9sgtA@mail.gmail.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Wed, 28 Sep 2022 16:44:33 +0900
Message-ID: <CAK+SQuT+wQs=R=PFQQfdPcAPjK9q9oc+2HtSS+E1RKp1dq_vEw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: remove unused netdev_unregistering()
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,
Thank you for your review!

On Thu, Sep 29, 2022 at 1:35 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Sep 28, 2022 at 9:17 AM Juhee Kang <claudiajkang@gmail.com> wrote:
> >
> > A helper function which is netdev_unregistering on nedevice.h is
> > no loger used. Thus, netdev_unregistering removes from netdevice.h.
> >
>
> I think we could explain a bit more why we think this function was not
> really needed.
>
> It was added in commit 8397ed36b7c5 ("net: ipv6: Release route when
> device is unregistering")
> then later, commit 27c6fa73f93b ("ipv6: Set nexthop flags upon carrier
> change") removed the
> only user of this helper. The only possible/valid case where we access
> dev->reg_state
> is in notifiers, and notifiers already have access to the 'event',
> being NETDEV_UNREGISTER
> or NETDEV_DOWN...
>

I will send you a next patch after changing it according to your advice.

>
> > Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> > ---
> > v2:
> >  - v1 link : https://lore.kernel.org/netdev/20220923160937.1912-1-claudiajkang@gmail.com/
> >  - Remove netdev_unregistering().
> >
> >  include/linux/netdevice.h | 5 -----
> >  1 file changed, 5 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 9f42fc871c3b..66d10bcaa6f8 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -5100,11 +5100,6 @@ static inline const char *netdev_name(const struct net_device *dev)
> >         return dev->name;
> >  }
> >
> > -static inline bool netdev_unregistering(const struct net_device *dev)
> > -{
> > -       return dev->reg_state == NETREG_UNREGISTERING;
> > -}
> > -
> >  static inline const char *netdev_reg_state(const struct net_device *dev)
> >  {
> >         switch (dev->reg_state) {
> > --
> > 2.34.1
> >
