Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A0148823B
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 09:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiAHHut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 02:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiAHHut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 02:50:49 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BC3C061574;
        Fri,  7 Jan 2022 23:50:49 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id p15so23212975ybk.10;
        Fri, 07 Jan 2022 23:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k8qD/yczrG2HpiMlJyIInRvUbSf3IaWe+LDsKOF0/CA=;
        b=p/ANXxRCZ/dm1zST+y6EENFhWZAX8HDLmY+wAHy9xV8stLqt89oFPQLo2VDP+xh1Tb
         gLGNs9FXt/myhCjk/rWLv1w6AcWDQ1fVsqwfxUNTW9UPAAq3XkASKKYIvhuIbWxG59u9
         tafLWOv//tBWAkv9YzPeUsuuc8a2CC4g79FOoMXSs1I1ih1Jwax5UBKHrp0DtG9FLQo8
         RnF633ZGbImdAXOPi5XbA7UGoQwkIa1noxhlYE7c0iSUUWAHEsW2ZeTnJLJDpBVuuKVN
         /ujdr5gaFZEl+3GEZE8WQkrl5C4DSOclk93olWmbh4wLjjdMAPMnJrjAd8NQwy/JfwNZ
         dYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k8qD/yczrG2HpiMlJyIInRvUbSf3IaWe+LDsKOF0/CA=;
        b=2c8nGAEJKhHiIkFyexNvLW3CQeBcIKw3eMql4dJ2hTGTYmTwI/LN5xpx6Svw4LZWOE
         mEs66HaggN3Md5OMkffSQW0Gin2tg8mZVdaRxp+Uq6QeEA3Isyfo7m5OAa6GWQ5APr2K
         pDHu5WK8xw84jzPntZZifeMzN/Y92ZnVEzau7RgYOOrROzMchejCt+bkZEaRUNPB7rGq
         IPiLAv2TlqlCyFoCd3XOnIdhSCHze3eHzhOzrRKKWnACYEWTLsn4+gnoPAwOSiMgZ3Zw
         ZT0orw4h27KWCqBQZsp3+ScWuEuJ5AvbPSxbeY8mGUPZhZRjM3KGQc4MMuQuVQE2h46Y
         kLnA==
X-Gm-Message-State: AOAM5338SFSYPRE7SBiyME0zg6T4PHTbkwcoRa8bCSyMIhVSJGipbIM5
        D8PZtPCymM31WbCGID6QHvCHfcVku8DKrnLf+Dk=
X-Google-Smtp-Source: ABdhPJwfhuKrgSW1XQ0U5j4edU44QQ6CG8VNLcjgL7XyaxafZkHTnCPCGQnUZ1cJ0HlSLcHDLqm9K1B1oOtmVlmz2P0=
X-Received: by 2002:a05:6902:72a:: with SMTP id l10mr7562291ybt.293.1641628248235;
 Fri, 07 Jan 2022 23:50:48 -0800 (PST)
MIME-Version: 1.0
References: <20220107210942.3750887-1-luiz.dentz@gmail.com> <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 7 Jan 2022 23:50:40 -0800
Message-ID: <CABBYNZJEZFwoQyAhXwpQsRB4c4jks4Yg9Sw9XLwPL7Pk3j_iMA@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
To:     Jakub Kicinski <kuba@kernel.org>, "An, Tedd" <tedd.an@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Jan 7, 2022 at 6:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  7 Jan 2022 13:09:42 -0800 Luiz Augusto von Dentz wrote:
> > The following changes since commit 710ad98c363a66a0cd8526465426c5c5f837=
7ee0:
> >
> >   veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54 +=
0000)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-nex=
t.git tags/for-net-next-2022-01-07
> >
> > for you to fetch changes up to b9f9dbad0bd1c302d357fdd327c398f51f5fc2b1=
:
> >
> >   Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt() (2022-01=
-07 08:41:38 +0100)
> >
> > ----------------------------------------------------------------
> > bluetooth-next pull request for net-next:
> >
> >  - Add support for Foxconn QCA 0xe0d0
> >  - Fix HCI init sequence on MacBook Air 8,1 and 8,2
> >  - Fix Intel firmware loading on legacy ROM devices
>
> A few warnings here that may be worth addressing - in particular this
> one makes me feel that kbuild bot hasn't looked at the patches:
>
> net/bluetooth/hci_sync.c:5143:5: warning: no previous prototype for =E2=
=80=98hci_le_ext_create_conn_sync=E2=80=99 [-Wmissing-prototypes]
>  5143 | int hci_le_ext_create_conn_sync(struct hci_dev *hdev, struct hci_=
conn *conn,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Interesting that it doesn't show up when I compile it, perhaps we need
to turn on some warnings?

> Also this Fixes tag could be mended:
>
> Commit: 6845667146a2 ("Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL che=
ck in qca_serdev_probe")
>         Fixes tag: Fixes: 77131dfe ("Bluetooth: hci_qca: Replace devm_gpi=
od_get() with devm_gpiod_get_optional()")
>         Has these problem(s):
>                 - SHA1 should be at least 12 digits long
>                   Can be fixed by setting core.abbrev to 12 (or more) or =
(for git v2.11
>                   or later) just making sure it is not set (or set to "au=
to").

Right, I will check with Marcel why we didn't end up fixing up in place.

>
> Would you be able to fix the new warnings and resend the PR or are you
> confident that there isn't much serious breakage here and follow ups
> will be enough?

I think we might want to do the fixup but the one lacking a prototype
I'm afraid was caused by the previous PR, anyway I will try to send a
fix for that over the weekend.

> FWIW to see the new warnings check out net-next, do a allmodconfig build
> with W=3D1 C=3D1, pull in your code, reset back to net-next (this will
> "touch" all the files that need rebuilding), do a single threaded build
> and save (2>file) the warnings, pull in your code, do another build
> (2>file2), diff the warnings from the build of just net-next and after
> pull.

Hmm, we might as well do that in our CI then, but isn't that gonna
cause all sorts of warnings in different subsystem/drivers to appear?
I get that the diff should come clean if we do this 2 stage builds
like you suggested but I'm not sure that is the best approach for CI,
what do you think @An, Tedd? I'd guess we could keep our minimal
config to keep building times in check but add a 2 stage build per
patch so we can detect if they produce new warnings.

--=20
Luiz Augusto von Dentz
