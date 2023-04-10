Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621AE6DC9F5
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjDJRYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 13:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjDJRYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 13:24:24 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A18A211B;
        Mon, 10 Apr 2023 10:24:23 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id be27so5971364ljb.12;
        Mon, 10 Apr 2023 10:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681147461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alr3/NC/xqr7by0S7jenMm75M6TKrdJg+U01GXyCPxw=;
        b=mXFAO5ZX6AATVbMfUNqNPYTH75KMtsDUSwzfV1QS+vKRk9XElWiHEO0qCWMR9IcGfk
         kGXac17vuVYg4g2JtGlmPGxOXE9pwwNs2/20ojEKokYXdJKlwRX8MFyLpWgOUAR99fkk
         M0PIM6c7ZeP7+wyAGZaV/9h5ZDaN1VKFgk2mhIJNjIgWe07E2QW7z1yfsIPKJh/e3xNb
         03joZeSe/PXG5XhVMQoAN5cWeoBI5ToYx52Rkiyf3kvA5W0cOsiomRjsms40s2Pxypw4
         asC2Gw+jLnFn3ZT5vYsAkyWdoEBWpkEW8k/nFP18qD3S2iEhaPp1lbLmSn96F8H+9RcV
         lwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681147461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alr3/NC/xqr7by0S7jenMm75M6TKrdJg+U01GXyCPxw=;
        b=6ZGvqQAcOPEAZj+vr14CpSqyG1lsbX2FEb/MrW9Ly631pDUgCDo8/mNb7AYuaMJiYk
         Krm/CjAiETY2D5DYpm9AxR+6l6eOw3STTN0CY24/slMXvYa8qC3DoukDlW6Gy0+zucmG
         pamf/Y+FCVUgOlQwesfrQa3FC+jkTRtA2Mdgde6eSrlA8CIRerWpl7KOCLyi5YfnGHpY
         VVfCn9tYa+HuTAVtopH5k9XmmTivYflAqqqKsXk3S3FwuR87GPD+vbOSq3S4BtsLzBrE
         q7yrGD2RHxNR5WtBxK7LK73fhs2m604BGzSP8eKD4HsFEqfW7Bj+pQJIMxK0yjuYF4lz
         6/aw==
X-Gm-Message-State: AAQBX9cR9emy/V/WgIKYrW5e+k8Yu651EH5+ZVlKTmwISK73fuRPPSdV
        glvLily2/DmQPOWRkMC4Rjl9pwKJVP4e24c4jgQxJV3N
X-Google-Smtp-Source: AKy350a/LzAl8LMYl0fSGjxfn/3IR3K1bbRMRPk1xu9CiJRBbp3MsYu3q798QpcOKNWejhUlqLA0d646fCLq+tjD1X0=
X-Received: by 2002:a2e:6e13:0:b0:29a:9053:ed21 with SMTP id
 j19-20020a2e6e13000000b0029a9053ed21mr3088520ljc.8.1681147461106; Mon, 10 Apr
 2023 10:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230407193201.3430140-1-luiz.dentz@gmail.com> <20230407183310.3bfc4044@kernel.org>
In-Reply-To: <20230407183310.3bfc4044@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 10 Apr 2023 10:24:08 -0700
Message-ID: <CABBYNZ+TSmRrCpZGH3KXoV-_UQWw2=sRMdz5SFPFMXH4JN3QjA@mail.gmail.com>
Subject: Re: pull-request: bluetooth 2023-04-07
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Apr 7, 2023 at 6:33=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Fri,  7 Apr 2023 12:32:01 -0700 Luiz Augusto von Dentz wrote:
> > The following changes since commit b9881d9a761a7e078c394ff8e30e1659d74f=
898f:
> >
> >   Merge branch 'bonding-ns-validation-fixes' (2023-04-07 08:47:20 +0100=
)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git=
 tags/for-net-2023-04-07
> >
> > for you to fetch changes up to 501455403627300b45e33d41e0730f862618449b=
:
> >
> >   Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp} (2=
023-04-07 12:18:09 -0700)
> >
> > ----------------------------------------------------------------
> > bluetooth pull request for net:
> >
> >  - Fix not setting Dath Path for broadcast sink
> >  - Fix not cleaning up on LE Connection failure
> >  - SCO: Fix possible circular locking dependency
> >  - L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}
> >  - Fix race condition in hidp_session_thread
> >  - btbcm: Fix logic error in forming the board name
> >  - btbcm: Fix use after free in btsdio_remove
>
> Looks like we got a Fixes tag issue (Fixes: Fixes: 8e8b92ee60de... )
> and clang is not on-board:
>
> net/bluetooth/hci_conn.c:1214:7: warning: variable 'params' is uninitiali=
zed when used here [-Wuninitialized]
>             (params && params->explicit_connect))
>              ^~~~~~
> net/bluetooth/hci_conn.c:1203:32: note: initialize the variable 'params' =
to silence this warning
>         struct hci_conn_params *params;
>                                       ^

Looks like Ive applied the wrong version of some patches, will send
the correct one sortly.

--=20
Luiz Augusto von Dentz
