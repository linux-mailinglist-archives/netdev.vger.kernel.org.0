Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CD42BA1BC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgKTFVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:21:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgKTFVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 00:21:24 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 755F32237B;
        Fri, 20 Nov 2020 05:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605849684;
        bh=DamdNeE8S3vr+HkxBAfA07bHOd4V6Q+Sf3GVGHmKRKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T4kTwO2H43onA7VrcwUAZfM3rdgtx5uFXe0fymKLUGwiS4+i4B6mLrJ21UWg2dJZK
         sY0uVFKXcnpZzf7BE2dNLQXG6WDOwV8/l/Y6cXSKFxTCbU8UQkWCV6xZupV1BChAmb
         WTZKxHZI473r6Nt6Y+XjLB8VvcnU1PraZy5vtNe0=
Date:   Thu, 19 Nov 2020 21:21:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
Message-ID: <20201119212122.665d5396@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <221941d6-2bb1-9be8-7031-08071a509542@gmail.com>
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
        <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
        <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
        <44a3c8c0-9dbd-4059-bde8-98486dde269f@gmail.com>
        <20201119214139.GL1853236@lunn.ch>
        <221941d6-2bb1-9be8-7031-08071a509542@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 23:09:52 +0100 Heiner Kallweit wrote:
> Am 19.11.2020 um 22:41 schrieb Andrew Lunn:
> >>>> Doesn't checkpatch complain about line length > 80 here? =20
> >>>
> >>> :)
> >>>
> >>> commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
> >>> Author: Joe Perches <joe@perches.com>
> >>> Date:=C2=A0=C2=A0 Fri May 29 16:12:21 2020 -0700
> >>>
> >>> =C2=A0=C2=A0=C2=A0 checkpatch/coding-style: deprecate 80-column warni=
ng
> >>> =20
> >>
> >> Ah, again something learnt. Thanks for the reference. =20
> >=20
> > But it then got revoked for netdev. Or at least it was planned to
> > re-impose 80 for netdev. I don't know if checkpatch got patched yet.

FWIW I had a patch for it but before I sent it Dave suggested I ask
around and Alexei was opposed.

And I don't have the strength to argue :)

I'll just tell people case by case when they have 4+ indentation levels
in their code or use 40+ character variables/defines, in my copious
spare time.=20

> At a first glance it sounds strange that subsystems may define own
> rules for such basic things. But supposedly there has been a longer
> emotional disucssion about this already ..

We do have our own comment style rule in networking since the beginning
of time, and reverse xmas tree, so it's not completely crazy.
