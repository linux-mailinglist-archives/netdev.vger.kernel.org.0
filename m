Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B21E56B850
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbiGHLSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiGHLSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:18:52 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23BC88F1D
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 04:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=+nD4DS8oXyEly5aIOtgm4gxwma+XmZ8gZLIcYuW4KRw=; b=FHP22ExkFj3UrAOaRCKAYj2RJe
        C3Jp31UVB1Bnb357JrSlZRh1ewErJE9xzobxfYgT6P+3gBeQwIks2yPSRGTniW0ClGn5ngOkHOxN/
        bI0eDY3C/WK7Aa75FhWbn+Y+aD5fAi5h/d/lU6y4SkldFwIA1KDbmNNttYQK/fGdulyBbobiW5u7X
        WTriliP8iRV0U2OSXrNMCvoctGNzo3S9AfLyU5Pp3bfOs8Jq+i7klJlSXOS4XZFERyBRGO/+kHo/N
        xQ5xdCCy1nYcC48FJSL8YhN5Msd8kC5pd7JycF2gaPjPrhxiqfxwtSilI9J92p1xAIIDwZFSCogQF
        qRcXB2xwPGUgeM42yrX3iy36ER3Dx7/LEh3Ca1O2VSlGH6jtIHNouBHMSotrlwTp2Kc8+iI+UhcHl
        BjXNrAcZeOIi8d2YjE94m1a80yXKa+QNir/9fMiwc46lUc8t+PMPM2vZn+2kiP/GeodGBvYtqHqGA
        XgBZudtRxSWKSAFMUGacsIsNkBPwKHlWiJOyTvMNHELLL8o/VRCpl01ZDD9mDnqx4X5dz2fq9SXlz
        +5nrvvLGR48pSJ6TZ4kAzMhiS0fzdyTK4WYblTl2i/Zymb9X4GW4gLRn77OYJb6KvQJyMOYdOnyNF
        MjtBqSALMRsg+tPGp2uISS8ngZpp29KGmDLaLaBB8=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>
Cc:     Greg Kurz <groug@kaod.org>, Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Date:   Fri, 08 Jul 2022 13:18:40 +0200
Message-ID: <1690835.L3irNgtgWz@silver>
In-Reply-To: <CAFkjPTngeFh=0mPVW-Yf1Sxkxp_HDNUeANndoYN3-eU9_rGLuQ@mail.gmail.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <YseFPgFoLpjOGq40@codewreck.org>
 <CAFkjPTngeFh=0mPVW-Yf1Sxkxp_HDNUeANndoYN3-eU9_rGLuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Freitag, 8. Juli 2022 04:26:40 CEST Eric Van Hensbergen wrote:
> kvmtool might be the easiest I guess - I=E2=80=99m traveling right now bu=
t I can
> try and find some others.  The arm fast models have free versions that are
> downloadable as well.  I know I=E2=80=99ve seem some other less-tradition=
al uses of
> virtio particularly in libos deployments but will take some time to rattle
> those from my memory.

Some examples would indeed be useful, thanks!

> On Fri, Jul 8, 2022 at 11:16 AM Dominique Martinet <asmadeus@codewreck.or=
g>
>=20
> wrote:
> > Eric Van Hensbergen wrote on Fri, Jul 08, 2022 at 10:44:45AM +1000:
> > > there are other 9p virtio servers - several emulation platforms suppo=
rt
> >=20
> > it
> >=20
> > > sans qemu.
> >=20
> > Would you happen to have any concrete example?
> > I'd be curious if there are some that'd be easy to setup for test for
> > example; my current validation setup lacks a bit of diversity...
> >=20
> > I found https://github.com/moby/hyperkit for OSX but that doesn't really
> > help me, and can't see much else relevant in a quick search

So that appears to be a 9p (@virtio-PCI) client for xhyve, with max. 256kB=
=20
buffers <=3D> max. 68 virtio descriptors (memory segments) [1]:

/* XXX issues with larger buffers elsewhere in stack */
#define BUFSIZE (1 << 18)
#define MAXDESC (BUFSIZE / 4096 + 4)
#define VT9P_RINGSZ (BUFSIZE / 4096 * 4)

[1] https://github.com/moby/hyperkit/blob/master/src/lib/pci_virtio_9p.c#L27

But on xhyve side I don't see any 9p server implementation:
https://github.com/machyve/xhyve/search?q=3D9p
Maybe a 9p server is already implemented by Apple's Hypervisor framework. I=
=20
don't find this documented anywhere though.

Best regards,
Christian Schoenebeck


