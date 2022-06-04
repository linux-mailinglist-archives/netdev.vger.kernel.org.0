Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65B653D7C5
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbiFDQca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 12:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiFDQc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 12:32:29 -0400
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937D22CCAB;
        Sat,  4 Jun 2022 09:32:27 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id w2so18731814ybi.7;
        Sat, 04 Jun 2022 09:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u1iTXsUBZY4rOPgodw6cyeMHMVRQnYdLbaVth9Uz2Lo=;
        b=iOj1PnYlQN2hXYJfmyGMmKvMG8fR82WSZe3IY5ezDeASW4nc5L1hGJNR19RJbD5Xzz
         qaPDJM707ytD5jLJJT+jK5Ivst9ZRkaX0KRu9u9Q3y7OOGy0AjW30QGUm2xGiRq00vFB
         5EKVuk7lL8DhEzDD/nkzu6isUi2CYmNKH43IEek78SFEMmgs/4VLhaeY/MUPD2G/cH8U
         Q2zCFXhShteTroyxgaEvqoRaDmVlqRQvKzWXeAbRiOhnnsOz13bDOs5gilJMMtd+gouq
         /e7r7ei0DPzZSh5sJ6gUUIkqZkOXdCR8fcYzZjLZ4soYHVuw+duk2eXY2z7irDeyrZPR
         B1EA==
X-Gm-Message-State: AOAM533gdlE6XFlHsbx0T/xVG8BsnEiF/kEhRQqFyegHOaPLAEAbbvCA
        fqxFcny6BuXrK7K4ns+0T2+cytewLVyEhTOtrFI=
X-Google-Smtp-Source: ABdhPJyNmKTDde0VcHd04GhxlN3kUsWv1n9QPvSxGy7iPiUvCW0/iO6JQhDFpJIAy7Cx7lfgbJ7xwo/EYrHv+XaBmIw=
X-Received: by 2002:a25:ad58:0:b0:65c:e3e5:e813 with SMTP id
 l24-20020a25ad58000000b0065ce3e5e813mr16127790ybe.151.1654360346868; Sat, 04
 Jun 2022 09:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
 <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
 <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de> <CAMZ6RqJ7qvXyxNVUK-=oJnK_oq7N94WABOb3pqeYf9Fw3G6J9A@mail.gmail.com>
 <20220604151859.hyywffrni4vo6gdl@pengutronix.de>
In-Reply-To: <20220604151859.hyywffrni4vo6gdl@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 5 Jun 2022 01:32:15 +0900
Message-ID: <CAMZ6RqK45r-cqXvorUzRV-LA_C+mk6hNSA1b+0kLs7C-oTcDCA@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun. 5 juin 2022 at 00:18, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 04.06.2022 23:59:48, Vincent MAILHOL wrote:
> > > > Fine, but I need a bit of guidance here. To provide a tag, I need to
> > > > have my own git repository hosted online, right?
> > >
> > > That is one option.
> >
> > This suggests that there are other options? What would be those other
> > options?
>
> 2. git.kernel.org (most preferred)
> 3. github.com (have to ask Davem/Jakub)
>
> > > > Is GitHub OK or should I create one on https://git.kernel.org/?
> > >
> > > Some maintainers don't like github, let's wait what Davem and Jakub say.
> > > I think for git.kernel.org you need a GPG key with signatures of 3 users
> > > of git.kernel.org.
> >
> > Personally, I would also prefer getting my own git.kernel.org account.
>
> See https://korg.docs.kernel.org/accounts.html

Thanks for the link. I will have a look at it tomorrow (or the day
after tomorrow in the worst case).

Meanwhile, I will send the v5 which should address all your comments.


Yours sincerely,
Vincent Mailhol
