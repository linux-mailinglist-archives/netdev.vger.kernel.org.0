Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA9337C58C
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhELPlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 11:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235091AbhELPfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 11:35:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 455F961C3E;
        Wed, 12 May 2021 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620832672;
        bh=zB2G4t5ozyJ72g68BGRplKf2lQRTS6CtRvJ7FVX3NWE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DBjrvZcbfODq6o/u3ovhcKp34o3mQ/2g2kqOKbw7rqi0UbJcuDmNkgLMMy0M05dFs
         mwfV7fdqIvkaHvs5FkFIxP3pQ5mW2wuelKsM0Zg1XI928MZ1g6hDtwlC/lZ6mTYtDn
         L0yXyxJPdKzjgMXD6Vs/vdQOXuvQV+DBBKSwRDhM/LlZ9x9/DV6Qnq7MjBym4Ue3He
         LklNFflnfSaW1SCikrvqRJriPDliUiNhIaGm2pb/3nXItDzT/4/obeOPpO0NPN/v0m
         Pwish5sD0axq4vDEIuCSUJZyKrnPcy3P6Nd30IKN+fHXybC5E+QSyK+xdLgaNeWw/l
         +EUyGcBOd8VUw==
Date:   Wed, 12 May 2021 17:17:41 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
Message-ID: <20210512171741.2870bcbc@coco.lan>
In-Reply-To: <YJvi1L2ss5Tfi+My@mit.edu>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
        <YJvi1L2ss5Tfi+My@mit.edu>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, 12 May 2021 10:14:44 -0400
"Theodore Ts'o" <tytso@mit.edu> escreveu:

> On Wed, May 12, 2021 at 02:50:04PM +0200, Mauro Carvalho Chehab wrote:
> > v2:
> > - removed EM/EN DASH conversion from this patchset; =20
>=20
> Are you still thinking about doing the
>=20
> EN DASH --> "--"
> EM DASH --> "---"
>=20
> conversion? =20

Yes, but I intend to submit it on a separate patch series, probably after
having this one merged. Let's first cleanup the large part of the=20
conversion-generated UTF-8 char noise ;-)

> That's not going to change what the documentation will
> look like in the HTML and PDF output forms, and I think it would make
> life easier for people are reading and editing the Documentation/*
> files in text form.

Agreed. I'm also considering to add a couple of cases of this char:

	- U+2026 ('=E2=80=A6'): HORIZONTAL ELLIPSIS

As Sphinx also replaces "..." into HORIZONTAL ELLIPSIS.

-

Anyway, I'm opting to submitting those in separate because it seems
that at least some maintainers added EM/EN DASH intentionally.

So, it may generate case-per-case discussions.

Also, IMO, at least a couple of EN/EM DASH cases would be better served=20
with a single hyphen.

Thanks,
Mauro
