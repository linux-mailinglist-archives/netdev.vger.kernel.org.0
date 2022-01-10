Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF13488EBF
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiAJCqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiAJCqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:46:19 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EA4C06173F;
        Sun,  9 Jan 2022 18:46:19 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e198so11614651ybf.7;
        Sun, 09 Jan 2022 18:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xv8WkfiaNO0ohpZ5hRQwkRYJdi5HA+NuKgIBzC1OCqA=;
        b=Su2Tjw+HnjgiIzMu140LBwLcmgae8Uqiab0rKbIL7rsAfPTyWjTzOiY85/QALKSV0x
         9ayDiQtNHh5CjLPQA7TilUWObbOi77YqZhvK7aZEuOWngWPHoprF1hXHn1462wwmEL1f
         jdPJLf393dP5sav9nvW5b4bm3VFhk0mZAvmcgXBLq9PaB9yIWaoUJm3D10J5PJnFVwz3
         k9yhWi/yPBZcZ0RDIqRvJea0VngQwkHE5i092DIFWQ47dH36ATdzMuvbDCKpOJ4q+EtM
         5fzFsSU7umewb33TmH2NESyqQa+PrcC3aGibZhNl0V4HLhYaLHI5SJCOHxDcliNZ/sbv
         wkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xv8WkfiaNO0ohpZ5hRQwkRYJdi5HA+NuKgIBzC1OCqA=;
        b=1B+CkO9fZhwxkDDlf/VrFhzbVjhtvPZV3RSNSfuF0m9l1oszxdalOaeniXMiDoM9Si
         fkCiGsrAOHBhu8E8QSsoYf+BCY4JODGNsyvWU4cvT+FH1HSBh1JnSqCBFO1d93AyfKf0
         ayIF5cXdVgywA7s6RFOFRVLJsBJhVCsFpfS0Fir8UGnSX0Fo5onJbZUPUTX/bBMqJWkn
         aO0wyqJeNzPwW9XHYYffJLiejy5UtPxhg8l4Wxfw8cR/ccD1/Ng+kOmIK5u9bJys8ce+
         zF7nhDB2+g69MzkIVJRLLKBNp8zcWow73XDPUhaDEi82PQM3G0SUwF3vu00gQTHNppG1
         rl+Q==
X-Gm-Message-State: AOAM53328psbnpBEZntOLnj7OHD2ZM/GmWQI3WlgdxNM0llXIt4quKLv
        zzMsm9gSWhpa4BN+YrBEym+HYOobmqR8ZwwqLVY=
X-Google-Smtp-Source: ABdhPJwUaqi6xAiexaO9pnmYwz6De9u85eWRUr9kfOiKSX3Vw1CQ7+NDja6snXVxXNu/bcL+OVOPAF8hrQa031Me0Ms=
X-Received: by 2002:a5b:14a:: with SMTP id c10mr91577443ybp.752.1641782778095;
 Sun, 09 Jan 2022 18:46:18 -0800 (PST)
MIME-Version: 1.0
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
 <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org> <20220109141853.75c14667@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220109141853.75c14667@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Sun, 9 Jan 2022 18:46:05 -0800
Message-ID: <CABBYNZJ3LRwt=CmnR4U1Kqk5Ggr8snN_2X_uTex+YUX9GJCkuw@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sun, Jan 9, 2022 at 2:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 8 Jan 2022 15:40:59 +0100 Marcel Holtmann wrote:
> > >> The following changes since commit 710ad98c363a66a0cd8526465426c5c5f=
8377ee0:
> > >>
> > >>  veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54=
 +0000)
> > >>
> > >> are available in the Git repository at:
> > >>
> > >>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-n=
ext.git tags/for-net-next-2022-01-07
> > >>
> > >> for you to fetch changes up to b9f9dbad0bd1c302d357fdd327c398f51f5fc=
2b1:
> > >>
> > >>  Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt() (2022-=
01-07 08:41:38 +0100)
> > >>
> > >> ----------------------------------------------------------------
> > >> bluetooth-next pull request for net-next:
> > >>
> > >> - Add support for Foxconn QCA 0xe0d0
> > >> - Fix HCI init sequence on MacBook Air 8,1 and 8,2
> > >> - Fix Intel firmware loading on legacy ROM devices
> > >
> > > A few warnings here that may be worth addressing - in particular this
> > > one makes me feel that kbuild bot hasn't looked at the patches:
> > >
> > > net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for =
=E2=80=98hci_le_ext_create_conn_sync=E2=80=99 [-Wmissing-prototypes]
> > > 5143 | int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct h=
ci_conn *conn,
> > >      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > this we have to fix with a patch since none of the commits were
> > touching this. It really must have slipped through earlier.
> >
> > > Also this Fixes tag could be mended:
> > >
> > > Commit: 6845667146a2 ("Bluetooth: hci_qca: Fix NULL vs
> > > IS_ERR_OR_NULL check in qca_serdev_probe") Fixes tag: Fixes:
> > > 77131dfe ("Bluetooth: hci_qca: Replace devm_gpiod_get() with
> > > devm_gpiod_get_optional()") Has these problem(s):
> > >             - SHA1 should be at least 12 digits long
> > >               Can be fixed by setting core.abbrev to 12 (or
> > > more) or (for git v2.11 or later) just making sure it is not set
> > > (or set to "auto").
> >
> > I fixed that now and re-pushed the tree. Funny part is that I always
> > check that the Fixes SHA1 is actually valid, but I never thought
> > about checking that it is at least 12 digits long. I totally missed
> > that and keep it in mind going forward.
>
> You're right. I think our patchwork build bot got confused about the
> direction of the merge and displayed old warnings :S You know what..
> let me just pull this as is and we can take the fixes in the next PR,
> then. Apologies for the extra work!

Im planning to send a new pull request later today, that should
address the warning and also takes cares of sort hash since that has
been fixup in place.

--=20
Luiz Augusto von Dentz
