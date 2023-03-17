Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACE56BF309
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjCQUsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCQUsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:48:18 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CC2EC7B;
        Fri, 17 Mar 2023 13:48:16 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id v27so5599086vsa.7;
        Fri, 17 Mar 2023 13:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679086095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ee6J0WOIDLoOleb4NPcisF64humPRCG8+jx5pR9784s=;
        b=FiA1BFSKJ1Zm32K8S3NjXmdJiDWVf6tWvWC8aIi8359dhX+d4u2poBgZwvY+0+OaCJ
         FUQyVv9bYORuNG47yNR/wvwAOqjd3SQ6JTEX0ObUo4tOyhV1SYLbiTrAPFDyTFbfC0DO
         XJMZx8EzuQkzzof5S7HFmnifwXcIsHMSr5gp870QVWzODgt++aArVy0kM4rUSaaW3lkM
         nbCCDRO5bQBeC35xDFgxwAzADm/WXN2HLyHBIi7QrzNx06TQRTFXpDCEWNGWAeCf/p8s
         8mZdI4skZUxD1uyGaHFYweJUcMYJAtGC+K31nB6Za230mkz4ILjJWpeb/PyVBUhSlcSQ
         i6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679086095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ee6J0WOIDLoOleb4NPcisF64humPRCG8+jx5pR9784s=;
        b=iqMwi9/bSo3F3dzr83rAHrxwyJcEdi1erfc3eReMsYWalVKN4ijowNiapU2yLxHBsx
         W6jtLuYsZDbd9nTslwgJgUSfTnDeFsYXxI8RsAwokvwdSfc1bSinyS2aAQRmSXqh1nxP
         26oajOYUpCePSS2HQyBup+MMsYOLnqv8l+OkWRPhaQ75vFG087N7efrFp3yxDu/i3QEO
         8P8p9s7HF0Ife4un3s/wXF1ux2Wu3cHcXEeZx2n63zxSQiTrHXE6t/b7cJgUul/FrpEB
         /PWjuxz1wBAl6NbceQ/zLaVqto6/dHoicJfF5kmYF7UPeOAveHn1bY+Q2Lxq57YA5t9P
         t3GA==
X-Gm-Message-State: AO0yUKUMBu3mKm7+AunJ7NSyqujG8hHLCyDQWbMSXDYbsCTGBmVBuKKW
        U2MJ07xoUMCnD31az+D/6/mYemCevBV2IwQr3eQ=
X-Google-Smtp-Source: AK7set/fdXhElNWqm+48s4YpD/+UsAFBGmgv8ebcZ6jVSE6b0PSV+9CZppp1FztOGDz/GVR3njU+whT3LpuVbBYoJek=
X-Received: by 2002:a67:c811:0:b0:423:d4af:dfda with SMTP id
 u17-20020a67c811000000b00423d4afdfdamr23149vsk.2.1679086095600; Fri, 17 Mar
 2023 13:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
 <CABBYNZ+DM+DKYVb-EqRX+WwW2hCrcVeMh29PVjqTM0WW2+HBuw@mail.gmail.com> <ZBTQu4RXHHbVRJTA@corigine.com>
In-Reply-To: <ZBTQu4RXHHbVRJTA@corigine.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 17 Mar 2023 13:48:03 -0700
Message-ID: <CABBYNZJG3T+v=RdQBuW-zvDDCQpqdkn3K=fP3NkPECJQdLbo9A@mail.gmail.com>
Subject: Re: [PATCH v13 0/4] Add support for NXP bluetooth chipsets
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On Fri, Mar 17, 2023 at 1:42=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Fri, Mar 17, 2023 at 01:00:11PM -0700, Luiz Augusto von Dentz wrote:
> > Hi Neeraj,
> >
> > On Thu, Mar 16, 2023 at 10:22=E2=80=AFAM Neeraj Sanjay Kale
> > <neeraj.sanjaykale@nxp.com> wrote:
> > >
> > > This patch adds a driver for NXP bluetooth chipsets.
> > >
> > > The driver is based on H4 protocol, and uses serdev APIs. It supports=
 host
> > > to chip power save feature, which is signalled by the host by asserti=
ng
> > > break over UART TX lines, to put the chip into sleep state.
> > >
> > > To support this feature, break_ctl has also been added to serdev-tty =
along
> > > with a new serdev API serdev_device_break_ctl().
> > >
> > > This driver is capable of downloading firmware into the chip over UAR=
T.
> > >
> > > The document specifying device tree bindings for this driver is also
> > > included in this patch series.
> > >
> > > Neeraj Sanjay Kale (4):
> > >   serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
> > >   serdev: Add method to assert break signal over tty UART port
> > >   dt-bindings: net: bluetooth: Add NXP bluetooth support
> > >   Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
> > >
> > >  .../net/bluetooth/nxp,88w8987-bt.yaml         |   45 +
> > >  MAINTAINERS                                   |    7 +
> > >  drivers/bluetooth/Kconfig                     |   12 +
> > >  drivers/bluetooth/Makefile                    |    1 +
> > >  drivers/bluetooth/btnxpuart.c                 | 1297 +++++++++++++++=
++
> > >  drivers/tty/serdev/core.c                     |   17 +-
> > >  drivers/tty/serdev/serdev-ttyport.c           |   16 +-
> > >  include/linux/serdev.h                        |   10 +-
> > >  8 files changed, 1398 insertions(+), 7 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/n=
xp,88w8987-bt.yaml
> > >  create mode 100644 drivers/bluetooth/btnxpuart.c
> > >
> > > --
> > > 2.34.1
> >
> > If there are no new comments to be addressed by the end of the day I'm
> > planning to merge this into bluetooth-next.
>
> FWIIW, as someone involved in the review of this series, I am fine with t=
hat.
> Even though I have only supplied tags for some of the patches;
> those for which I feel that it is appropriate.

Thanks for the feedback and the review as well.


--=20
Luiz Augusto von Dentz
