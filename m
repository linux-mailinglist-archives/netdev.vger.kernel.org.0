Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A253CFFA3
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhGTP6P convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Jul 2021 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbhGTPxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 11:53:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9581C0613E3
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 09:33:55 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m5sgg-0001jJ-D6; Tue, 20 Jul 2021 18:33:42 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m5sgg-0002y4-0w; Tue, 20 Jul 2021 18:33:42 +0200
Message-ID: <e08d6e454be46033b6ec025afabd41f9a8381a62.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Date:   Tue, 20 Jul 2021 18:33:41 +0200
In-Reply-To: <CAMuHMdVFarkF49=Vvcv-6NLhxbLUE33PXnqhAiPxpaCNN7u4Bw@mail.gmail.com>
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
         <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
         <dc2de27b087c7030ea7e76dd31bb3d8bce18d97f.camel@pengutronix.de>
         <CA+V-a8v-54QXtcT-gPy5vj9drqZ6Ntr0-3j=42Dedi-kojNtXQ@mail.gmail.com>
         <CAMuHMdVFarkF49=Vvcv-6NLhxbLUE33PXnqhAiPxpaCNN7u4Bw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Tue, 2021-07-20 at 17:11 +0200, Geert Uytterhoeven wrote:
[...]
> I wouldn't bother with reset-names on R-Car, as there is only a
> single reset.
> 
> BTW, does there exist a generally-accepted reset-equivalent of "fck"
> ("Functional ClocK")?

Not really. There is "rst", which seems to be slightly more popular than
"reset". Some bindings use "core" to differentiate between the
functional reset and peripheral resets like bus or phy resets.

Ideally the reset-names would match the names of the reset inputs in the
IP core documentation (not the global names of the reset signals in the
SoC documentation). But more often than not they are not known.

regards
Philipp
