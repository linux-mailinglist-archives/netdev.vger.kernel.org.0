Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D023A04C9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbhFHT6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbhFHT5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:57:43 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0959C061789;
        Tue,  8 Jun 2021 12:55:36 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id h15so2135025ybm.13;
        Tue, 08 Jun 2021 12:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/t4yN4xonrpvGro68OJA55McluDF08k6qcDswauRnlo=;
        b=dYMJnH0WxmJ/J03wTzxDhINFfnGQxwZ7yJ9Bu3nIP7KZ7HiMGjoLA15wV/4G5pm0J6
         uZWSTVzWiI5wqD7jSlUqkA4MmVE/ZxIHqnEQXiULcfRjF9YpcaEk/01sd1nH5MZ3Bmiu
         /0JCprVoiUHE3pfbEejdLGZUmaqLKx8N1m18koifQnVT+lReBPaYqSO6X1i9PWcpwwGk
         CBz+/zDlRgukN40e3Qz8r5t0aaDE+y0SHEH0KzlPWZq1yUu5usF+0KzgtoWGNablUNn/
         4935Hig9q/EsnKRIyRhgFQ5fWcq2vq73mikkQqrHFuwwcPELh1qGCMSlaCNwHl/MZr4a
         +qPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/t4yN4xonrpvGro68OJA55McluDF08k6qcDswauRnlo=;
        b=gMC7x41KDXALiIZ8/j22ph3kpHYoCXQflnWBVNsDlYHhV7u7xdKukrgWnjFcpG4WBw
         1HiQu9tt0SkqrSHsSaLmaeki5zD2F96JfINi3uSlGvBzG3wJuPz0fCgWVYqmBCY8b0wL
         gbIsQxvw5097DZTmMAyDgTcBCeYwkW/p+X4ngCtm6jVN3rpoPjA/GtVkeqnvP+P12ZWF
         HClzpkzSIb5jX8gq8DOpcnw/mJPNlF8jU4442DrYG1TeNu5mx5e4I0f7yxxkhcZxQmNi
         KYlDK/EUg7fcGJZG6K0qS3kIpxDxE+qYSJT+xgm1gKs8FWkRDKJjDTKfuR+EBaHnUiqx
         4wtg==
X-Gm-Message-State: AOAM5338yIX/i6aYElGw4nH5Rjv6Y6mdl4FTzgmOb4hlU++6ZjAhbTZ2
        +P0VbHQGpq67APMGk8gQzj0g+vKoJf4gqVU0NnXYvSG3
X-Google-Smtp-Source: ABdhPJzb5o5CO1/QjhjKY9Ilvl299N1frs04NCGWX1IduZn40UV3iBWlB0Nf8ZXCGYUDKuYs5MZMRQOPlnz802n1VwY=
X-Received: by 2002:a25:a466:: with SMTP id f93mr32516748ybi.264.1623182135043;
 Tue, 08 Jun 2021 12:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210603215249.1048521-1-luiz.dentz@gmail.com>
 <CABBYNZJqBbq0pMRt9w7XLLw0MnxmavokT2t6_PqwGVf4YfdnNA@mail.gmail.com> <9A9CD860-79EC-4B3C-BF2E-8038352B946B@holtmann.org>
In-Reply-To: <9A9CD860-79EC-4B3C-BF2E-8038352B946B@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 8 Jun 2021 12:55:24 -0700
Message-ID: <CABBYNZJ4w9K_R7J-EcnWn+fvfWDs81PemRNmZWKOHmqWD6yUiw@mail.gmail.com>
Subject: Re: pull request: bluetooth 2021-06-03
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 8, 2021 at 12:21 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Luiz,
>
> >> The following changes since commit 62f3415db237b8d2aa9a804ff84ce2efa87=
df179:
> >>
> >>  net: phy: Document phydev::dev_flags bits allocation (2021-05-26 13:1=
5:55 -0700)
> >>
> >> are available in the Git repository at:
> >>
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git=
 tags/for-net-2021-06-03
> >>
> >> for you to fetch changes up to 1f14a620f30b01234f8b61df396f513e2ec4887=
f:
> >>
> >>  Bluetooth: btusb: Fix failing to init controllers with operation firm=
ware (2021-06-03 14:02:17 -0700)
> >>
> >> ----------------------------------------------------------------
> >> bluetooth pull request for net:
> >>
> >> - Fixes UAF and CVE-2021-3564
> >> - Fix VIRTIO_ID_BT to use an unassigned ID
> >> - Fix firmware loading on some Intel Controllers
> >>
> >> ----------------------------------------------------------------
> >> Lin Ma (2):
> >>      Bluetooth: fix the erroneous flush_work() order
> >>      Bluetooth: use correct lock to prevent UAF of hdev object
> >>
> >> Luiz Augusto von Dentz (1):
> >>      Bluetooth: btusb: Fix failing to init controllers with operation =
firmware
> >>
> >> Marcel Holtmann (1):
> >>      Bluetooth: Fix VIRTIO_ID_BT assigned number
> >>
> >> drivers/bluetooth/btusb.c       | 23 +++++++++++++++++++++--
> >> include/uapi/linux/virtio_ids.h |  2 +-
> >> net/bluetooth/hci_core.c        |  7 ++++++-
> >> net/bluetooth/hci_sock.c        |  4 ++--
> >> 4 files changed, 30 insertions(+), 6 deletions(-)
> >
> > We are hoping we could merge these before the release.
> >
>
> I think it already reached Linus=E2=80=99 tree.

Sorry for the noise, I didn't realize it had been merged already.

--=20
Luiz Augusto von Dentz
