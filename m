Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7E6F1309
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345225AbjD1ILL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345644AbjD1ILJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:11:09 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B086B211C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:11:06 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9A74A1BF206;
        Fri, 28 Apr 2023 08:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682669465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uhbSvaBgl5HlUfBxZKSBPc/b+ZNFmzBNGs8o0a8S2RM=;
        b=QvzzzrR+fQPslTh5oBKuXyZmvc9o23UgoGzNqtxxigHpMu0rMgLfo1zv+ndpyYSb/BYQWx
        Pe6RoRmj7xaLjt+RnN68ChX2ETdkUaRx82aBlwzDiI3rypMfDzwemGk9Yt3Mz04TWkuJcg
        22qdzAmxap5fB2ngmb0biJuD5hzviipmmBu5lSuyWK6TVgq8uqjyx9dgX9Fjk+WxxHW4vx
        ONmXeBQ7UX2T453V6XqB2IqxE/SL+YoFyQdIcsnD6HCSI2hYxqIa+zTY616CpM0yg8QSHb
        f5OWEvdKYiTskJqh2wW30Hsi+PtexnfX7iQ7zmZWHPoGR+Q2nhZoqPZzORO18Q==
Date:   Fri, 28 Apr 2023 10:11:03 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
Message-ID: <20230428101103.02a91264@kmaincent-XPS-13-7390>
In-Reply-To: <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
References: <20230423032437.285014-1-glipus@gmail.com>
        <20230426165835.443259-1-kory.maincent@bootlin.com>
        <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
        <20230427102945.09cf0d7f@kmaincent-XPS-13-7390>
        <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 22:57:27 -0600
Max Georgiev <glipus@gmail.com> wrote:

> Sorry, I'm still learning the kernel patch communication rules.
> Thank you for guiding me here.

Also, each Linux merging subtree can have its own rules.
I also, was not aware of net special merging rules:
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html


> On Thu, Apr 27, 2023 at 2:43=E2=80=AFAM K=C3=B6ry Maincent <kory.maincent=
@bootlin.com>
> wrote:
> >
> > On Wed, 26 Apr 2023 22:00:43 -0600
> > Max Georgiev <glipus@gmail.com> wrote:
> > =20
> > >
> > > Thank you for giving it a try!
> > > I'll drop the RFC tag starting from the next iteration. =20
> >
> > Sorry I didn't know the net-next submission rules. In fact keep the RFC=
 tag
> > until net-next open again.
> > http://vger.kernel.org/~davem/net-next.html
> >
> > Your patch series don't appear in the cover letter thread:
> > https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
> > I don't know if it comes from your e-mail or just some issue from lore =
but
> > could you check it? =20
>=20
> Could you please elaborate what's missing in the cover letter?
> Should the cover letter contain the latest version of the patch
> stack (v4, then v5, etc.) and some description of the differences
> between the patch versions?
> Let me look up some written guidance on this.

I don't know how you send your patch series but when you look on your e-mail
thread the patches are not present:
https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/

It is way easier to find your patches when you have all the patches of the
series in the e-mail thread.

Here for example they are in the thread:
https://lore.kernel.org/all/20230406173308.401924-1-kory.maincent@bootlin.c=
om/

Do you use git send-email?
