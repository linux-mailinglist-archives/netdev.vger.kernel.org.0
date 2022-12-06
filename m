Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC6E644C6C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLFTWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiLFTWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:22:06 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B167A3FB9B;
        Tue,  6 Dec 2022 11:22:04 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bs21so24946800wrb.4;
        Tue, 06 Dec 2022 11:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gy4u2QqjlsESIglatVGXv9U+WSgroaeagEnymVoeXC0=;
        b=NnqNiqHASH6XI+IicrMtDQi7DQzK3E6RV3xHf1//wIVH8JDGLaz5dMQrfKxZuu9CW9
         dRCIEH+tYNnG9ZNbBUbqF4xS2DA85nuX3y37XzA+ZR2xrwFxobwIkPuE6n5vv8hVyVcS
         91v7Y8fQugJMavPkfwrPOhBs2p9gBRAJu8pbZeGDP4JUuXNvfJeu6P841oSYxXb4Gj+s
         O1rM0y2RlUWBQosMOUHqMPMXCjBa39n31gqzJDjbMWj00VMym0R/h07gUZSQJ0P9ZQn4
         whGnZhukrl0AevpjFLy72DHTqH1NpBartsfKznFjHPW0qD4xXWU6HhnAoEwiACQ40z/k
         CLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gy4u2QqjlsESIglatVGXv9U+WSgroaeagEnymVoeXC0=;
        b=uGjgXUtaegD+wuvYo5p4iv2cNEtXFwZMOv0FlGo+O1Owa5YkbTCN4O0k8WwkjAZXU5
         k4mEml2oYy5cbFFHDv4b3g8ons10Il7sibTSrKjCwUT6XL4klpl3lki3Bd4DzBRYjzpd
         4/RbhAyClkbdAimFzt5DMeXPMlNixcUBZIwSknmNV7oYBVu0J76aKFYE4qBWFZUEQMGk
         fFfIpUUNWrtDMEBghkUHON8FWRqecX9iHxXYzDVLL0Atuq1Y1M3zIhgM/xbiaII2T9Vc
         25/xD7Lt6zDGu1FwOUHeOz/Y7t85E+883Az2JXEAZalQKWd9SCW0J+YG0uNOJ8J0hojW
         r+/Q==
X-Gm-Message-State: ANoB5pnPvFw0gBiU6xsg772F4XqdreehP9Dkqr6x4Fu2A854zUIHYARP
        N3OjKKlmsV6U31I1RvKK/a5NuB8FBrzjLr3fdV5InNvQ3uC/vA==
X-Google-Smtp-Source: AA0mqf4wfJi/ssowbx0aotrUEa008QlvWb4MqKTdUSGq0g+mO5eh9jAC5Vdb0yQ/4TZ1YlDiCnmkHMHXvnwI1YD2Rik=
X-Received: by 2002:adf:f94f:0:b0:241:f467:f885 with SMTP id
 q15-20020adff94f000000b00241f467f885mr38217458wrr.482.1670354522969; Tue, 06
 Dec 2022 11:22:02 -0800 (PST)
MIME-Version: 1.0
References: <20221206110207.303de16f@kernel.org>
In-Reply-To: <20221206110207.303de16f@kernel.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 6 Dec 2022 11:21:50 -0800
Message-ID: <CAA93jw6DYKvc4Mk64bap3FiBWXMvRBKB2hMupxnq_S8SxJNu7g@mail.gmail.com>
Subject: Re: driver reviewer rotation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 11:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Hi!
>
> As some of you may have noticed we have restarted a structured reviewer
> rotation. There should be an uptick in the number of reviews when you
> post patches.
>
> Here is some details, and background info.
>
> The majority of submissions we get are for drivers. We have tried
> to create a driver review rotation a while back, to increase the
> review coverage, but it fizzled out. We're taking a second go at it.
>
> The new rotation is limited in length (4 weeks) and focused on
> involving NIC teams (nVidia, Intel, Broadcom, plus Meta/FB to make
> it 4), rather than particular individuals. I picked the NIC vendors
> for multiple reasons - with small exceptions they send more patches
> than they review. Secondly they have rather large teams, which makes
> it easier to create a stable rotation - employees from the same org
> can load balance and cover for each other. Last but not least, I have
> a possibly unfounded belief, that in a vendor setting the additional
> structure of a review rotation is doubly beneficial as "organized
> efforts" are usually easier to justify to corporate overlords.

+1.

I am assuming this is principally ethernet?

Because it would be so wonderful if the developers of drivers for wifi
& 5g, (especially) on phones, and aps, and clients of all sorts, all
somehow were enabled to more regularly got together... to do something
other than commiserate.

I was looking over the 2016 make-wifi-fast project description (after
gfiber pulled out) the other day, wishing that somehow, some set of
corps that cared about good wifi and lte experiences would get
together to make it better for everyone.

https://docs.google.com/document/d/1Se36svYE1Uzpppe1HWnEyat_sAGghB3kE285LEl=
JBW4/edit#

And while it did get a bit better, the work remains kind of lonely. I
find sitting in a virtual shared videoconference to be faster (and
more fun) than reviewing code by yourself.

"Pain shared is decreased. Joy shared, increased." - Spider Robinson.

> Please feel free to reach out if you'd like to also be a part of
> a review rotation. We can start a second circle or double up one of
> the shifts... we'll figure something out. Also please reach out with
> any comments / concerns / feedback.
>

My principal thing on the ethernet front has been merely to try and
ensure subsystems like BQL are in new ethernet drivers. If there was
an AI other than me that could get "triggered" on that front that
would be great. BQL itself is showing its age, tho...

> FWIW any "corporate involvement" in the community makes me feel uneasy
> (and I hope that other community members share this feeling).
> So please don't view this as any form of corporate collusion or giving
> companies themselves influence. This is also not an indictment against
> the community members who are already investing their time in reviewing
> code, and making this project work...
>
> HTH



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
