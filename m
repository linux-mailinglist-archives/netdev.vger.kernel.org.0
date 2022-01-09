Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0996D488CD4
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 23:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbiAIWS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 17:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiAIWS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 17:18:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A208C06173F;
        Sun,  9 Jan 2022 14:18:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A447B80E47;
        Sun,  9 Jan 2022 22:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DD2C36AE3;
        Sun,  9 Jan 2022 22:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641766734;
        bh=0C4ifzjr8XFqmjzAovnOdf2W7x5qkaEO/0o+je5ywTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T/DNRXZgFBQmNGibrwGt+Ylu5t3YnoWZoGwNp2KKAe3BrKClLh2cHQmVQ+w0OqW2L
         TJiv8bKOVXb1XyyDbnzEOonaCvQzjDlUe8u8BnfrhSPgTlz5Ca0iOOHuiLPl1hSTlp
         HH5VGDQ/VzNtKZeQBAdB45BByEBN928bGLxTvoOkVjB1WrNIO4KjJViqmmNDoDhPE8
         qIAYc4Yww7TijUR8aQYWgyu2jGoyM98fMDjzJnN9pDk4qrXafvYHs4q8MFShsv9yWq
         Zv49btwaFzRG8p3LxurSo5cg105/CxkOj19t4qZdV137nFw2S1Vo9q07ZEeQX2Yngr
         If0l+LIsyFU9Q==
Date:   Sun, 9 Jan 2022 14:18:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
Message-ID: <20220109141853.75c14667@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org>
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
        <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Jan 2022 15:40:59 +0100 Marcel Holtmann wrote:
> >> The following changes since commit 710ad98c363a66a0cd8526465426c5c5f83=
77ee0:
> >>=20
> >>  veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54 +=
0000)
> >>=20
> >> are available in the Git repository at:
> >>=20
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-nex=
t.git tags/for-net-next-2022-01-07
> >>=20
> >> for you to fetch changes up to b9f9dbad0bd1c302d357fdd327c398f51f5fc2b=
1:
> >>=20
> >>  Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt() (2022-01=
-07 08:41:38 +0100)
> >>=20
> >> ----------------------------------------------------------------
> >> bluetooth-next pull request for net-next:
> >>=20
> >> - Add support for Foxconn QCA 0xe0d0
> >> - Fix HCI init sequence on MacBook Air 8,1 and 8,2
> >> - Fix Intel firmware loading on legacy ROM devices =20
> >=20
> > A few warnings here that may be worth addressing - in particular this
> > one makes me feel that kbuild bot hasn't looked at the patches:
> >=20
> > net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for =E2=
=80=98hci_le_ext_create_conn_sync=E2=80=99 [-Wmissing-prototypes]
> > 5143 | int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct hci=
_conn *conn,
> >      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~ =20
>=20
> this we have to fix with a patch since none of the commits were
> touching this. It really must have slipped through earlier.
>=20
> > Also this Fixes tag could be mended:
> >=20
> > Commit: 6845667146a2 ("Bluetooth: hci_qca: Fix NULL vs
> > IS_ERR_OR_NULL check in qca_serdev_probe") Fixes tag: Fixes:
> > 77131dfe ("Bluetooth: hci_qca: Replace devm_gpiod_get() with
> > devm_gpiod_get_optional()") Has these problem(s):
> > 		- SHA1 should be at least 12 digits long
> > 		  Can be fixed by setting core.abbrev to 12 (or
> > more) or (for git v2.11 or later) just making sure it is not set
> > (or set to "auto"). =20
>=20
> I fixed that now and re-pushed the tree. Funny part is that I always
> check that the Fixes SHA1 is actually valid, but I never thought
> about checking that it is at least 12 digits long. I totally missed
> that and keep it in mind going forward.

You're right. I think our patchwork build bot got confused about the
direction of the merge and displayed old warnings :S You know what..
let me just pull this as is and we can take the fixes in the next PR,
then. Apologies for the extra work!
