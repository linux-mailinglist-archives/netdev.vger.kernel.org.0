Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6229189712
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbgCRI2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:28:12 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44551 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCRI2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:28:07 -0400
Received: by mail-lj1-f195.google.com with SMTP id w4so11267308lji.11
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UzaS2e/XdZpUtzF616elOdAAPbhPZrej3K/evwYVIEM=;
        b=YQZyAox1qVRZw1QkCUb5HF0ehx5/zSENEbTNgYqxSu1U53i4/8ykPHc6HyuvRUwx3K
         +qQBIuTSJn4LSj961MijUmv/I2qY+6T9RY4d8B9y/Gj+99CZsl77yNfmLqrIxnvY0n4L
         q9TyitjevfqJwFXqgMCfn6f5wJgIejbXI1Qld3MnMvE2vo/d/SglXm69FyeUVFF4GPmc
         55G9BwXgaIVYYZaoENAbP2ljhHQfAx1Sla0cy5Qkq4TblJT4fLMcLqsOCgX8e4NS360h
         TwgtvR6t5qwKd9egoLLlFa1JiAHUuv1Gdz0m+eT4b+QWi51tyQU+xozKaMvIVOi4Bvu0
         lrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UzaS2e/XdZpUtzF616elOdAAPbhPZrej3K/evwYVIEM=;
        b=PKcMGM2YONyT7mZYVVT4CZ1X9774/be3TnlqWWlmKh4ch+BQ3Y3Y4NsA36IGVWR81T
         NDqJz0HeUfMYHTCgmogjjfqdls3FVC1b2dBGfnYdRVZ5STqmlQ72NYfJGSrapz+vD72R
         k0nu3IncsadH40/K92hK/j+xKARRhQQzP4s1AkA3mUy8YIS2rimawE9nNjFj4Dh2oOvB
         hOyBsDpGWvhZGf5wbbq9AXDvmTTfLkee1MhTZDfKAzdMyABZvASnzh51+b7C4WqZcm7c
         jatufjDKgvXQFitkfWoh5L1tdAYKjuk4syZPwkWJR/0D6qTiHWmet5orER9L+3n//5pJ
         ZesA==
X-Gm-Message-State: ANhLgQ1UoCICGQGBRqkooI5TZDBdbnJ59V+E4+RRfNr5HTxd8j3O3BXq
        w3MTqwMsvpTRWZVDHhkhSVwjsgDfZmaogW6ffZidtg==
X-Google-Smtp-Source: ADFU+vstaPio4DgQjZBcZ6ke0vdqic5ns/5uMmDF4KiVhTeFUCGYD6+i5x/xuLKooeFxPoxk6UpLTOxWif0VXPGmoqQ=
X-Received: by 2002:a05:651c:2007:: with SMTP id s7mr1764988ljo.214.1584520084172;
 Wed, 18 Mar 2020 01:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group> <VI1PR0402MB3600DC7BB937553785165C2AFFF70@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3600DC7BB937553785165C2AFFF70@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Date:   Wed, 18 Mar 2020 09:27:53 +0100
Message-ID: <CANh8QzwPmbfr1y9Yz7ctbannX3gOWZBQG1_xDM6xit=3ZXD+pg@mail.gmail.com>
Subject: Re: [EXT] [PATCH 0/4] Fix Wake on lan with FEC on i.MX6
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,


On Wed, 18 Mar 2020 at 07:28, Andy Duan <fugang.duan@nxp.com> wrote:
>
>
> The most of code is reused from nxp internal tree,
> If you refer the patches from nxp kernel tree, please
> keep the signed-off with original author.
>

Ok, looks like it was originally from you, should I add your current
email address or the one at the time (B38611@freescale.com)?

Actually I don't have the NXP tree but a Digi tree, which is probably
based on it.

I think, generally, this is a bit of a grey area.

While I would always keep a SoB if I base a patch on an old mailing
list patch submission (and contact the person if possible first to
ask) I'm not sure if a SoB from a "random git tree" indicates they
wish a mainline submission with their name (some people may want
credit and others not want to be considered responsible for bugs...).
I didn't see a submission of this version (with the gpr information
coming from the DT) on the mailing lists, only the initial version
using the platform callback that was NAKd (I may have missed it
though).

Regards,

Martin
