Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0979650DB4A
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 10:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiDYIiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 04:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiDYIhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 04:37:54 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E80562A18;
        Mon, 25 Apr 2022 01:34:50 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j2so25778740ybu.0;
        Mon, 25 Apr 2022 01:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMct1g7Ft5UceXrNYXqhHIPwAR2NJ5Bl6cV1qu2HA+s=;
        b=pawqGCb62CA9LZy9KYSWQr+wNtuNsvOMTzJj04AtcEKjab7zDneGzZoEhQ5tLP5+mh
         SXoPJUr9yxbnYUesH6qGtXzF9J3hmcJkTOO5pxjH9ea0J72HG/mVuYudCVJZU7Fw/BGJ
         S47M3gBlxYGdTPHHGZAAkC/PzdFl1s5n+RoZKbau278vsOoR9DDYr1bYl5YxtxDw1VZ7
         4ZSfgzhuc0ckgTlTQGgp0IP0adicTfsfZc3i15EF5Gvcm3GxuGCxdQowdUbdhnq/TxPw
         ZVWUnD7gWLLFNWJAk8JKAcjOWGD+zlprXEpd4wtIJ6EX9bKAL0/0g4J6in6cmLuVQq9H
         i+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMct1g7Ft5UceXrNYXqhHIPwAR2NJ5Bl6cV1qu2HA+s=;
        b=3uzSIefSwv3bx7pZiBEjNhUdd04Q8+zP+rSpKUilg1sJJNjap+55qnZKB2DWRU0O8I
         s6dDp3dsLa4LptVcc7+xvLYviIflWqRDzsrZ+rqIy9/l2v2It/40h1XvdE4Wan/HwyiA
         CepTxqXqqAzDM/rhNoaitoLwosGvT8aFGBid+/F+aP4WeR2myM59kbh3nwVpf+X924xu
         ksuXZhIYteOT7WUjaVW2GsTfTL1nGiIQhDiXQ0Ll8XySg9v/uVFZqFGsg2ggqfxqK3J1
         A02dPtrQgJtAAQFHy6XIfScOWkLzkbD5yGL72VIGT46rKjCc11nmEG01JXXKjD4bQqOi
         fKXg==
X-Gm-Message-State: AOAM533hVixSNL6irFPRXB7RnVMw0i/TTKoVcUybgPUdJNiWnkQh/i2B
        J8yOQO9/OqTMQujxYXXSPU982pWaUCQqGgghu4j9+hAyzJIiLA==
X-Google-Smtp-Source: ABdhPJwoU8fVXjAPFACL8qCTQui91owZ7n7IXVAQf6AOGhmSA/9tyl3xVm1SoRuOcqKI1C+RQSY9qsuj6BAFTlaaW+I=
X-Received: by 2002:a25:e705:0:b0:645:781a:f870 with SMTP id
 e5-20020a25e705000000b00645781af870mr14561812ybh.630.1650875689469; Mon, 25
 Apr 2022 01:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz> <1fd684bcf5ddb0346aad234072f54e976a5210fb.1650816929.git.pisa@cmp.felk.cvut.cz>
 <CAMZ6RqJ1ROr-pLsJqKE=dK=cVD+-KGxSj1wPEZY-AXH9_d4xyQ@mail.gmail.com> <202204251010.39032.pisa@cmp.felk.cvut.cz>
In-Reply-To: <202204251010.39032.pisa@cmp.felk.cvut.cz>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Mon, 25 Apr 2022 17:34:38 +0900
Message-ID: <CAMZ6RqJsg5V-4oDpXOQiNDPCLYGE5+h54xsq2=eMJo_8iqqswQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] can: ctucanfd: remove PCI module debug parameters
 and core debug statements
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 25 Apr 2022 at 17:10, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> Hello Vincent,
>
> On Monday 25 of April 2022 09:48:51 Vincent Mailhol wrote:
> > On Mon. 25 Apr. 2022 at 14:11, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> > > This and remove of inline keyword from the local static functions
> > > should make happy all checks in actual versions of the both checkpatch.pl
> > > and patchwork tools.
> >
> > The title and the description say two different things.
> >
> > When looking at the code, it just seemed that you squashed
> > together two different patches: one to remove the inlines and one
> > to remove the debug. I guess you should split it again.
>
> if you or somebody else confirms that the three lines change
> worth separate patch I regenerate the series.

I was just troubled that the title was saying "remove debug" and
that the body was saying "remove inline". I genuinely thought
that you inadvertently squashed two different patches
together.

I just expect the body of the patch to give extended explanations
of what is in the title, not to introduce something else, and
this regardless of the number of lines being changed.

> The changes are not based on third party patches but only
> on indications reported by static analysis tools.
> Remove of inline in the local static functions probably
> does not even change code generation by current compiler
> generation. Removed debug outputs are under local ifdef
> disabled by default, so only real change is step down from
> option to use module parameter to check for possible
> broken MSI causing the problems on PCIe CTU CAN FD integration.
> So I thought that single relatively small cleanup patch is
> less load to maintainers.
>
> But I have no strong preference there and will do as confirmed.
>
> By the way, what is preference for CC, should the series
> be sent to  linux-kernel and netdev or it is preferred for these
> local changes to send it only to linux-can to not load others?
> Same for CC to David Miller.

I used to include them in the past because of
get_maitainer.pl. But Oliver pointed out that it is not
necessary. Now, I just sent it to linux-can and Marc (and maybe
some driver maintainers when relevant).

> Best wishes,
>
>                 Pavel
> --
>                 Pavel Pisa
>     phone:      +420 603531357
>     e-mail:     pisa@cmp.felk.cvut.cz
>     Department of Control Engineering FEE CVUT
>     Karlovo namesti 13, 121 35, Prague 2
>     university: http://control.fel.cvut.cz/
>     personal:   http://cmp.felk.cvut.cz/~pisa
>     projects:   https://www.openhub.net/accounts/ppisa
>     CAN related:http://canbus.pages.fel.cvut.cz/
>     Open Technologies Research Education and Exchange Services
>     https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home
>
