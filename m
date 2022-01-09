Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480AE4887B6
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 06:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiAIFXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 00:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiAIFXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 00:23:05 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B472C06173F;
        Sat,  8 Jan 2022 21:23:05 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id i3so29146947ybh.11;
        Sat, 08 Jan 2022 21:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Varh2KpZisFfNCnQZj7woasFSawJlKM5czdAIPJ3JMU=;
        b=RG311M8bNP8LTvcyUZwF3n+dPVi5M/7hQYqwVtKTVHywMjI9sqS0O86DATBGEcEhyi
         31dnf1BSYZPw/J3m7VAz00z8Px1TsMtbX4FUP7DsY6M0KNpYL2/bzU2jdzr1E1EPjR1h
         wdIENIyxWSbExKosjxYj9kuIJ3iPZWTB9rlqJO/xcwJYvDjLu3zeNlHug/2HWi5FI8eH
         4qCh0FCW7O/V8w/9cRq/ifJ7FuiGYeKbwFzGg5k4ax3ychMxMU1FF6ChfKhEPsjRIHA8
         35Vioo1wqX87a43Ww/mceSqmODFfsNwGmaP/5Mq4kTA/RFT7VHQzliHpAMV3ou0YDfXr
         Xu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Varh2KpZisFfNCnQZj7woasFSawJlKM5czdAIPJ3JMU=;
        b=CGrOyDxFUJO1FSDa9xD1YqQi7BLpX5jmMT/H9mufYa3bA6DxB2n0eenLm0t7E5meG6
         L2cfZgfjnmhJxlePXVLH2WjEsHxweTwPOTrBIoEMYg9UUnOfusRzuNQlsvyxaowk0BKR
         9u352gv0iG+JDn30FHGx6T0CmamC7EUyZcYsGk8VUVcGi+XRKwegzI2xsq7K3M0pWCsH
         WbT72y9KYjFvSxzC90EUxvp0uY2Ss1TkT10pE343IfCCvt+Z9fyRKbloQZEvvdjF3V2F
         OscC3eIdRQCtYJUf4ocNMmgLo4ElldWjBfZHu/g7r+ZCa5xaxuY6nSqgjvYtgGULpIoW
         SYkw==
X-Gm-Message-State: AOAM530YA2QpdKyZP3aiy4pxvN9o73mj1BUq6pQvhBCHrmHhteYhGw8+
        DM2WJiqbcBImVljQQlH80H2ZHjCuUeDyoskojiRRrLGU
X-Google-Smtp-Source: ABdhPJwkl+ZGA9QLf8joJPqJxBdwtm/iajJcKnYRXgtXZ8Ga33b+IvHl61GAmEey5tCgt3S972P015IcjWeTJk4ZIws=
X-Received: by 2002:a05:6902:1149:: with SMTP id p9mr62756822ybu.398.1641705783012;
 Sat, 08 Jan 2022 21:23:03 -0800 (PST)
MIME-Version: 1.0
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
 <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org>
In-Reply-To: <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Sat, 8 Jan 2022 21:22:51 -0800
Message-ID: <CABBYNZLaOgPFRvv_h=pyXChnP=y205yrm_cnP=F3TVBrXv-qVQ@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Sat, Jan 8, 2022 at 6:41 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Jakub,
>
> >> The following changes since commit 710ad98c363a66a0cd8526465426c5c5f83=
77ee0:
> >>
> >>  veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54 +=
0000)
> >>
> >> are available in the Git repository at:
> >>
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-nex=
t.git tags/for-net-next-2022-01-07
> >>
> >> for you to fetch changes up to b9f9dbad0bd1c302d357fdd327c398f51f5fc2b=
1:
> >>
> >>  Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt() (2022-01=
-07 08:41:38 +0100)
> >>
> >> ----------------------------------------------------------------
> >> bluetooth-next pull request for net-next:
> >>
> >> - Add support for Foxconn QCA 0xe0d0
> >> - Fix HCI init sequence on MacBook Air 8,1 and 8,2
> >> - Fix Intel firmware loading on legacy ROM devices
> >
> > A few warnings here that may be worth addressing - in particular this
> > one makes me feel that kbuild bot hasn't looked at the patches:
> >
> > net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for =E2=
=80=98hci_le_ext_create_conn_sync=E2=80=99 [-Wmissing-prototypes]
> > 5143 | int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct hci=
_conn *conn,
> >      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> this we have to fix with a patch since none of the commits were touching =
this. It really must have slipped through earlier.

Just sent a patch fixing the warning, once that is applied I will
create a new tag and send the pull request.

> > Also this Fixes tag could be mended:
> >
> > Commit: 6845667146a2 ("Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL c=
heck in qca_serdev_probe")
> >       Fixes tag: Fixes: 77131dfe ("Bluetooth: hci_qca: Replace devm_gpi=
od_get() with devm_gpiod_get_optional()")
> >       Has these problem(s):
> >               - SHA1 should be at least 12 digits long
> >                 Can be fixed by setting core.abbrev to 12 (or more) or =
(for git v2.11
> >                 or later) just making sure it is not set (or set to "au=
to").
>
> I fixed that now and re-pushed the tree. Funny part is that I always chec=
k that the Fixes SHA1 is actually valid, but I never thought about checking=
 that it is at least 12 digits long. I totally missed that and keep it in m=
ind going forward.
>
> Regards
>
> Marcel
>


--=20
Luiz Augusto von Dentz
