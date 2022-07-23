Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D349157EA9E
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 02:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiGWA0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 20:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiGWA0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 20:26:13 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046EF2A409;
        Fri, 22 Jul 2022 17:26:11 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u12so2518762edd.5;
        Fri, 22 Jul 2022 17:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y90Q6x8OckhWx9wnLqKncqDxgqU5gmFRWX1rVGtKulE=;
        b=Kxeu03AwaXZtmkw7yqkGTDaIv2autAI3r8wiUmxRN7Y5j1ki4CZ+n1hUvx0mPj5fn8
         Bgu39ghrPqa67GgrcGLuU4+VoPdYOp9vhbluEGqm0GvZTGHo8PYka2803YWskxpJeBSH
         PTuz66badZRwcrPYcCJs2jIwcyZOuOhbczq3z4jJBVi8uxmm30WSGXpp79zIhNPN77Tt
         oVZOWhuGjTNitWdyscT5WWTFKtnrok0FENUBHDFDK48oPTUvumu1RaJ8wpq4n+r6MvNw
         iG0jHIlwooVmC2iwaXUUEu6bzadbGK+2b5BjfuEnsFLk78foVcsRDMVLT2x5wcnNr26D
         ns5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y90Q6x8OckhWx9wnLqKncqDxgqU5gmFRWX1rVGtKulE=;
        b=b2dwkJkdmsihhazSAG0ftj2b8X31mlDGM6h+JM1VV+NYK4iGdOVzxn98RsnlYVMtO/
         O6S769TfMGmJ+331AYJPBXDI1avsZMLsrr1x6UZBw04DzvkDEpCZvmFDBl38lFRvite1
         h3Xd8jEDsSYIkg5Yw1SPIlxvSKjXGIZeeXs41oTJDTE3LjzKdv/tlqyFawre3joTwcev
         VIGTIOKC62t/Xidrvj19JkvpU/0OB0hYwe9+eUslmocM0Mhfs48rmNdaKbnqIR4Jw/jV
         j+gkdkkKN1+KAUZPjqf42kqpdMdBPcxuvw3XdJVwJU3GN/8rk8V9cQEPywGphbK14zKI
         ya+g==
X-Gm-Message-State: AJIora9HTYk6yweUXHRec5Mz1BL3QkaEvtJSaXeAanLZ/BJ19wh6P9+T
        zHStJSUdVliSM4PU7YLk6cFuCWEumpuvVj4JxxqZgZT2wv0=
X-Google-Smtp-Source: AGRyM1tfEEkVoWkaInVfURuegk8+vVuPGGyleaVL7qH/xeHD0Sb4uvrH/ve/BokLNxhEh71WMm2ZmssJ9CIwAt5S3Zk=
X-Received: by 2002:a05:6402:4390:b0:43a:bc4b:8ab4 with SMTP id
 o16-20020a056402439000b0043abc4b8ab4mr2075444edc.283.1658535969195; Fri, 22
 Jul 2022 17:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220722205400.847019-1-luiz.dentz@gmail.com> <20220722165510.191fad93@kernel.org>
 <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com> <20220722171919.04493224@kernel.org>
In-Reply-To: <20220722171919.04493224@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 22 Jul 2022 17:25:57 -0700
Message-ID: <CABBYNZJ5-yPzxd0mo4E+wXuEwo1my+iaiW8YOwYP05Uhmtd98Q@mail.gmail.com>
Subject: Re: pull request: bluetooth-next 2022-07-22
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
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

Hi Jakub,

On Fri, Jul 22, 2022 at 5:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 22 Jul 2022 17:09:33 -0700 Luiz Augusto von Dentz wrote:
> > > I see two new sparse warnings (for a follow up):
> > >
> > > net/bluetooth/hci_event.c:3789:26: warning: cast to restricted __le16
> > > net/bluetooth/hci_event.c:3791:26: warning: cast to restricted __le16
> >
> > Crap, let me fix them.
>
> Do you mean i should hold off with pushing or you'll follow up?

Ive just fixup the original patch that introduced it, btw how do you
run sparse to capture such errors?

> > > Two bad Fixes tags:
> > >
> > > Commit: 68253f3cd715 ("Bluetooth: hci_sync: Fix resuming scan after suspend resume")
> > >         Fixes tag: Fixes: 3b42055388c30 (Bluetooth: hci_sync: Fix attempting to suspend with
> > >         Has these problem(s):
> > >                 - Subject has leading but no trailing parentheses
> > > Commit: 9111786492f1 ("Bluetooth: fix an error code in hci_register_dev()")
> > >         Fixes tag: Fixes: d6bb2a91f95b ("Bluetooth: Unregister suspend with userchannel")
> > >         Has these problem(s):
> > >                 - Target SHA1 does not exist
> > >
> > > And a whole bunch of patches committed by you but signed off by Marcel.
> > > Last time we tried to fix that it ended up making things worse.
> > > So I guess it is what it is :) Pulling...
> >
> > Yep, that happens when I rebase on top of net-next so I would have to
> > redo all the Signed-off-by lines if the patches were originally
> > applied by Marcel, at least I don't know of any option to keep the
> > original committer while rebasing?
>
> I think the most common way is to avoid rebasing. Do you rebase to get
> rid of revised patches or such?

So we don't need to rebase? There were some patches already applied
via bluetooth.git so at least I do it to remove them and any possible
conflicts if there were changes introduced to the bluetooth
directories that can eventually come from some other tree.


-- 
Luiz Augusto von Dentz
