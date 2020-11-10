Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50932ADAB4
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgKJPnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbgKJPnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:43:52 -0500
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F61206A1;
        Tue, 10 Nov 2020 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605023031;
        bh=uCEkPHk3i5H3QXvOGo5NpwKxkLBk3zQGpI0v+bfF5kk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vUsSLgCMmvi6fyrJsiFhX0ycHitwB47PBU2zHPa48AAmdWRMzeIavY86JaHFAvNK8
         aYO36n4BJpbmE/lPeIFn+Eo2PgG76k/66cOCtuXftWioei4K1lhTZDanH941yK0Fn8
         Hz9A8MHSbJNac8nEC5XTJ3k2iDtzAfM6mlXjFNDw=
Received: by mail-oi1-f170.google.com with SMTP id m17so14823694oie.4;
        Tue, 10 Nov 2020 07:43:51 -0800 (PST)
X-Gm-Message-State: AOAM531EfV4XAZGm4NQIRD3K70Ya++Zi+rot9sIdrDE7NWkVaJ/C1LC4
        mud6MeCDDjXAMJCxChm4SoIra4clXgUmT0HHwA==
X-Google-Smtp-Source: ABdhPJz7STEfC4g7LX/bvaOov8G9BfxKI6JR4ciSxAAsm7c9wXNQJwAZ0wJLz2CcbRHNKUNUCVcrce9bIoJy3ifnc6M=
X-Received: by 2002:aca:fdd4:: with SMTP id b203mr3219209oii.152.1605023030597;
 Tue, 10 Nov 2020 07:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20201022075218.11880-1-o.rempel@pengutronix.de> <20201022075218.11880-3-o.rempel@pengutronix.de>
In-Reply-To: <20201022075218.11880-3-o.rempel@pengutronix.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 10 Nov 2020 09:43:39 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKSdGAY03HK1SBGec-j4S0cmm-mntJ8e0ujHVX4E3dnMw@mail.gmail.com>
Message-ID: <CAL_JsqKSdGAY03HK1SBGec-j4S0cmm-mntJ8e0ujHVX4E3dnMw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dt-bindings: can: flexcan: convert fsl,*flexcan
 bindings to yaml
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 2:52 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> In order to automate the verification of DT nodes convert
> fsl-flexcan.txt to fsl,flexcan.yaml
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Link: https://lore.kernel.org/r/20201016073315.16232-3-o.rempel@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  .../bindings/net/can/fsl,flexcan.yaml         | 135 ++++++++++++++++++
>  .../bindings/net/can/fsl-flexcan.txt          |  57 --------
>  2 files changed, 135 insertions(+), 57 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt

Why did this go into v5.10-rc3? It's not a fix and now a fix is needed:

/builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/clock/imx5-clock.example.dt.yaml:
can@53fc8000: compatible: 'oneOf' conditional failed, one must be
fixed:
 ['fsl,imx53-flexcan', 'fsl,p1010-flexcan'] is too long
 Additional items are not allowed ('fsl,p1010-flexcan' was unexpected)
 'fsl,imx53-flexcan' is not one of ['fsl,imx7d-flexcan',
'fsl,imx6ul-flexcan', 'fsl,imx6sx-flexcan']
 'fsl,imx53-flexcan' is not one of ['fsl,ls1028ar1-flexcan']
 'fsl,imx6q-flexcan' was expected
 'fsl,lx2160ar1-flexcan' was expected
 From schema: /builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
/builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/net/can/fsl,flexcan.example.dt.yaml:
can@2090000: fsl,stop-mode: [[4294967295, 52, 28]] is too short
 From schema: /builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
