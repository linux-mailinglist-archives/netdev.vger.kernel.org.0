Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F418C43A877
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 01:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhJYXuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 19:50:25 -0400
Received: from mout.gmx.net ([212.227.17.22]:56759 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235335AbhJYXuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 19:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635205677;
        bh=9ZzIzwFZHpLrRGh6ZqoCfRowYa6SvOfFS6MFS83wlgM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XPk3mu9yQ3awZUQm7z2LnCjGmhGTZz/jW1d9r2AWGurX0QBqieXXbFByLDr7EgP/K
         w47Ap1nnGQQ8OFFdPkVaNko/Jz/AD+UMWj/jFlOzWNvsA3j56nioRsgBMNCNDwh9xo
         hS+Mxqtj1OIIjz4QlphSH/CnK7ckGvmji502NocY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [91.64.35.151] ([91.64.35.151]) by web-mail.gmx.net
 (3c-app-gmx-bap12.server.lan [172.19.172.82]) (via HTTP); Tue, 26 Oct 2021
 01:47:57 +0200
MIME-Version: 1.0
Message-ID: <trinity-b6836216-b49e-4e59-80af-7b9c48918b19-1635205677415@3c-app-gmx-bap12>
From:   Robert Schlabbach <Robert.Schlabbach@gmx.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: ixgbe: How to do this without a module parameter?
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 26 Oct 2021 01:47:57 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YXcdmyONutFH8E6l@lunn.ch>
References: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
 <87k0i0bz2a.fsf@toke.dk> <YXcdmyONutFH8E6l@lunn.ch>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:54KcvzwVUzZn/GxSoPHIsHDWwdWKgDTAKIGa1RPX38bfhFylbMb/IIA5A8L/yd3hyAwRW
 ZRo36Jm+rR3/NrQCYzcWhU/Hwmh/AcPDaYl87uhONsyVDKugkD3RT2FSGhZNYWFY1gLY5DA2HCj2
 ALCDYVHj9Q8UwNJRfoKZFFzV30Mhf3HTUmiwKqgLEqYnlm0uvulUSIaeFDbLrsD5+4OzBzMowLSi
 d6950vHNgWav9E/oPnd/updpF4daT14kTGCkSJ+RN7u9ebdSyXqvQyMBw5WgimLSExWPoI19Ejp3
 q4=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TL1juFPjPLE=:0iUZILhTIWu8c5hSUSknJt
 nCgLGuKH93mJXxcgSB3Tvcp4XvgdH0H6cqYsVofuLE/0TFMq+0XLitdIVHKkb0jkwtuoaWAFM
 JQ6nj6PzrzTkH1yjAiT3BcLWeaIMJLusgU0uT3W/CcQOHJvrDbQBbtTWI60BJKlfGwRT11v07
 KgyWUK/DLk5p8Et8N9Xt/DSa3FahNQGQwnJP/EbyoX9yHr/LDMTkKS1We+Y3DzOXVdYkHGspB
 3MrsUafDPEIMv7wwQQKgEuibgbL2wozuz8yIPg5LDka4jnHvXBjSyx34HLkuyvIKmSe0dBH2q
 diIss2CwDcFGMCnYTX9oyYvssttnH5lov+3LfjkugxOJ/kyAM64cIkNisIfbklSPOik6RMic9
 TOTBlvouOMxXPWx9nLGAW71LJ/agyajgOpPX4yfZF0lUGKKsd0n1FjsdYo5lOx+M3dKdbF4cr
 MaTU7hZKlvkhazbouoPYvGbRJp+XpKHs0FXCZsK99OYUGHFPxTtaAe6YnNwSoAq9bbgT7p0Sy
 AOemt0jsS3bCuwRXTKoZHIqt/tjInQjFCQZoZWW7rB2XFs9w4YQsOnAvkmMKpyUB8hSMIMc9H
 CPh3nhsMs98Rm5b0Ulwo6rsI6tfpM8V4xO3GuPRh4rSX7APnwcobQfyiEPZm7M/ATMinrOPyC
 MCLzCwsCyk6dpBNj+gwy8k4xnidoM5vvuKo8pnDk/qLTzf7YHdrV15jECaDJBOWroIFHXxNsO
 k5Pgf77OWujRHgD51nuwdzbGtVTJJfNuUmsELeLQU6z7kaT1fLHBBVCiD+5xKC0jWBWMlzOpr
 ux+qTx/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:=C2=A0"Andrew Lunn" <andrew@lunn=2Ech>
> What is also useful is that you can put ethtool settings into
> /etc/network/interfaces=2E

Thank you very much, that was very helpful! I tried it, and indeed, I only=
 had
to add one line to /etc/network/interfaces (the first three lines below we=
re
already there):

# The primary network interface
allow-hotplug eno3
iface eno3 inet dhcp
     pre-up ethtool -s eno3 advertise 0x1800000001028 || true

And I found this to work just as well as the module parameter - the link c=
ame
right up at NBASE-T speed after boot=2E

This was on a Debian 11=2E1 setup=2E I suppose this may not work on all di=
stros,
but it works well enough for me=2E

So I realize using ethtool is a viable solution after all and the module
parameter is not needed=2E I'd still wish the ixgbe driver would default t=
o full
functionality and require the users with the "bad" switches in their netwo=
rks
to employ ethtool to cripple its function, but I suppose that'd be tough t=
o
sell to Intel=2E=2E=2E

Best regards,
-Robert Schlabbach
