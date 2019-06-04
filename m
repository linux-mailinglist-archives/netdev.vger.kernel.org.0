Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221AA34DF0
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfFDQrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:47:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41554 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbfFDQrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 12:47:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id 83so3866347pgg.8
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 09:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f2ES3kTiavhUyzOLb3MzT5LHrx6FzBon3Rtq3npOl74=;
        b=CULsKovvdsf9zEAbzLFsSw/CxJ3LVnFLxI1snQdV1ni7ME/LyVs7fSYreRBTg2Ek9C
         YiGDW6xVBAm/xdTXsIJDR1vH1lEUX2X6B8zGaPTGMFtElvilha+EeGiwjQJVZk7PLFrG
         nZsXu3EzX5U1XYgHuMnt3oB11H8hATX+MTAXKhBOuPAcl5PbGuLXbt+nxllqNZPfJevu
         ESFuP+eVCCBkeFIurlu0jSmnmX210FjVIx2MI2YzLlXSi08jZJoCC70zOPhXgsJdTXr5
         V/nhLF4gZG7W6UpgSRoXTjDTMN6TxUIteEus6S8ECcdwEd9TVy2DE2mERkR4RfDaqvNJ
         CFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f2ES3kTiavhUyzOLb3MzT5LHrx6FzBon3Rtq3npOl74=;
        b=oeNlXjI6I+lYpBlOXuMBb2XRof997KfSNRfjIJgcRCoquWdQveaSThTl3y1Jhsvh/+
         T7AsMl+BxNvGGh8cld0Mv+PuZer7qoNUAdFmsCv5fPQ2mH6ksw5irdK2kachW4kz3Wxf
         S7vCA0fhUP8kInDpDHeP7U1yebgf3VfP+ENZRp/bNljBH8UOa6DW/xJk0YGuVhQxhM3Z
         NNzAQhSGhUcpoR99DxTsohljAa8+ZKRwY5nP66j38PuCCHnxYHTflh3Lc2eIZIBEoE8T
         F8vNcFnqL/P36aAmW3oUPtvpsFLc2LGWo7E6boMZ1zg7TMtv+2OUTswBLjH5IXEm5cwz
         IcIw==
X-Gm-Message-State: APjAAAVnGtKyloq6NQ4LV6Ega32OxwZDRTvqO6gJcqTz2qQoRMpMWBf0
        afj+ig57LrRxdj/f/14ha4dtZA==
X-Google-Smtp-Source: APXvYqzgfJ4LY5ngI9QIZShPAynOLrqlVJTBtd2iw8jrrCtTbVZiguvLVQm3eVxYlLid7Uobr/gUdA==
X-Received: by 2002:a63:6848:: with SMTP id d69mr37273538pgc.0.1559666840027;
        Tue, 04 Jun 2019 09:47:20 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q125sm39859561pfq.62.2019.06.04.09.47.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 09:47:19 -0700 (PDT)
Date:   Tue, 4 Jun 2019 09:47:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH] devlink: fix libc and kernel headers collision
Message-ID: <20190604094718.0a56d7a5@hermes.lan>
In-Reply-To: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
References: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 18:32:27 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> Since commit 2f1242efe9d ("devlink: Add devlink health show command") we
> use the sys/sysinfo.h header for the sysinfo(2) system call. But since
> iproute2 carries a local version of the kernel struct sysinfo, this
> causes a collision with libc that do not rely on kernel defined sysinfo
> like musl libc:
>=20
> In file included from devlink.c:25:0:
> .../sysroot/usr/include/sys/sysinfo.h:10:8: error: redefinition of 'struc=
t sysinfo'
>  struct sysinfo {
>         ^~~~~~~
> In file included from ../include/uapi/linux/kernel.h:5:0,
>                  from ../include/uapi/linux/netlink.h:5,
>                  from ../include/uapi/linux/genetlink.h:6,
>                  from devlink.c:21:
> ../include/uapi/linux/sysinfo.h:8:8: note: originally defined here
>  struct sysinfo {
> 		^~~~~~~
>=20
> Rely on the kernel header alone to avoid kernel and userspace headers
> collision of definitions.
>=20
> Cc: Aya Levin <ayal@mellanox.com>
> Cc: Moshe Shemesh <moshe@mellanox.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Sorry this breaks the glibc build.


    CC       devlink.o
devlink.c: In function =E2=80=98format_logtime=E2=80=99:
devlink.c:6124:8: warning: implicit declaration of function =E2=80=98sysinf=
o=E2=80=99; did you mean =E2=80=98psiginfo=E2=80=99? [-Wimplicit-function-d=
eclaration]
  err =3D sysinfo(&s_info);
        ^~~~~~~
        psiginfo

I backed out the patch now (before pushing it).
Please fix and resubmit.
