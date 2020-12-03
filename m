Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FFE2CD990
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgLCOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLCOuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:50:14 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63621C061A4E;
        Thu,  3 Dec 2020 06:49:34 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so2126667wrb.9;
        Thu, 03 Dec 2020 06:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PbnNTRLQSbEPf4GWwSeO8ArVoDFMPjXku4O6HzyA2QY=;
        b=d7vRuzDC0zrhgnLbtOM5oW/ycePCNVNqBo0mUEogHy1jarJL3WsNrRYYSFOx3qBodv
         6nkhiicSsPMf8bc+wKRT4eXWYsoLEH2YLhe5lyxc4sc3tKgquOrDqfpIMbmRbpioNSfl
         WzPYEG1cILDohfVCWr9FzvlcnldZxEWEy5knoRQu3Dr5x1GanHQIhypNmn+27zBEz8/V
         ttVpiAa29/BdwGm5yVB5CchMSrD936Gd6pvNfR3d+Ln07v9aAvfWxubu+x26BAUylbKh
         2LW50Wmlmhndut4sCLJBEC1DUGZonxZnCKrIsmd/k9h8pBOGoM8ZGwouIeEZHla9NOn+
         3Evg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PbnNTRLQSbEPf4GWwSeO8ArVoDFMPjXku4O6HzyA2QY=;
        b=AbabQz0kZrldwK12IKLdeIGK0jrJ8PrcFVBX3jHQbf88sbcGcYFZSEUOWkASo0EEUO
         LX/3wcpCgAt2cQT5n6lDWxUih2wMy13zfaEqZGSFBAcn4fYgbwgOQeZwVBPpgJJQ6jhE
         2QeGSVaoWgyq7kK/lhWhYwhpuV9KxeKKAgkiWJk7mTYbCjOzVbH8TO8fZPWAvHts5Noo
         xNKyhI3BsytiMNW1VWDzI34xWDMMck3B5yz4uDl/zSDtwNSmHIVlMBGl6Zg+zAeh79Qy
         wz2yTRChK8FLoK2DlYwTzgEkmYnjwROxAj7aeGo5sUGWLvRoPjT5KyelmKQqDgmNJ+Ds
         tCkQ==
X-Gm-Message-State: AOAM533AecO3CzuT7vK4CRI3y3rO/LXI421JKM3rRN4LVCVgsrqF1lET
        jXdCoD8TsTRAWyfmpdDHMs/UXTeuuVVkwI9ZS70=
X-Google-Smtp-Source: ABdhPJzGj0jdvbohM1HTwru2ZWH1XPWDwTahzKos8nheL72Xyhab3Ue38Jm0SHRCyWtPdConOWrCvxpiOCLp3l+sqQk=
X-Received: by 2002:a5d:5741:: with SMTP id q1mr4077718wrw.160.1607006973101;
 Thu, 03 Dec 2020 06:49:33 -0800 (PST)
MIME-Version: 1.0
References: <20201203144343.790719-1-anders.roxell@linaro.org>
In-Reply-To: <20201203144343.790719-1-anders.roxell@linaro.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 3 Dec 2020 15:49:21 +0100
Message-ID: <CAJ+HfNg97HtDciv_z8F6Gs5Yncuua2Gx27HLxCYBNmA9Bk1jxg@mail.gmail.com>
Subject: Re: [PATCH] dpaa_eth: fix build errorr in dpaa_fq_init
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     madalin.bucur@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 at 15:46, Anders Roxell <anders.roxell@linaro.org> wrote=
:
>
> When building FSL_DPAA_ETH the following build error shows up:
>
> /tmp/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c: In function =E2=80=
=98dpaa_fq_init=E2=80=99:
> /tmp/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:1135:9: error: too fe=
w arguments to function =E2=80=98xdp_rxq_info_reg=E2=80=99
>  1135 |   err =3D xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq->net_dev,
>       |         ^~~~~~~~~~~~~~~~
>
> Commit b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
> added an extra argument to function xdp_rxq_info_reg and commit
> d57e57d0cd04 ("dpaa_eth: add XDP_TX support") didn't know about that
> extra argument.
>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>
> I think this issue is seen since both patches went in at the same time
> to bpf-next and net-next.
>

Thanks Anders!

Indeed, when bpf-next is pulled into net-next this needs to be applied.

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net=
/ethernet/freescale/dpaa/dpaa_eth.c
> index 947b3d2f9c7e..6cc8c4e078de 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -1133,7 +1133,7 @@ static int dpaa_fq_init(struct dpaa_fq *dpaa_fq, bo=
ol td_enable)
>         if (dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_DEFAULT ||
>             dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_PCD) {
>                 err =3D xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq->net_=
dev,
> -                                      dpaa_fq->fqid);
> +                                      dpaa_fq->fqid, 0);
>                 if (err) {
>                         dev_err(dev, "xdp_rxq_info_reg() =3D %d\n", err);
>                         return err;
> --
> 2.29.2
>
