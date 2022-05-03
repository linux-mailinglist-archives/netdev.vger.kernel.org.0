Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605595187E4
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbiECPLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237895AbiECPLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:11:03 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD193A5D1;
        Tue,  3 May 2022 08:07:25 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id DCEF030B294B;
        Tue,  3 May 2022 17:07:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=4P1L2
        McRFcrXjxO7ZhfB8SkAYy+Wz107djIKnsuzQ8w=; b=ibNg1fvSzVenJE8mislPb
        mMPjFDuTppdbFCVkq5SqvzUxfxh3nXotqpYokniv+99dvuPRFqJBzvA7neVzVfrn
        Bjlzi4nb+0saXR5a2AzqiomQ14doe9ux5rZRz4PF4D65KRHmvMlMkHPbqOCItMe3
        Ed19miLuYU6vezl5HAWpiK9CB7kKLg/jHaBRqzmWemFeZ13ECejslwvRPR2ZtXbf
        wzr1GTYDnG9BfDZP0IARyjpvPKXB6IiIUor7CHY7borZA6g3wChYOgOZtFmRMB/w
        xcDM5DG+xIR+o3EeqwJIAqyA+I066ZIMnAkH5+H1OiM5qLwxpcpS1DL4+QR7CTlc
        A==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 6555E30ADE4B;
        Tue,  3 May 2022 17:07:22 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 243F7M6l003342;
        Tue, 3 May 2022 17:07:22 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 243F7LcQ003341;
        Tue, 3 May 2022 17:07:21 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v8 5/7] can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
Date:   Tue, 3 May 2022 17:07:21 +0200
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz> <4d5c53499bafe7717815f948801bd5aedaa05c12.1647904780.git.pisa@cmp.felk.cvut.cz> <CAMuHMdXY_sHw4W8_y+r1LMhGM+CF7RQtRFQzEC8wYKYSR98Daw@mail.gmail.com>
In-Reply-To: <CAMuHMdXY_sHw4W8_y+r1LMhGM+CF7RQtRFQzEC8wYKYSR98Daw@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202205031707.21405.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Geert,

On Tuesday 03 of May 2022 13:37:46 Geert Uytterhoeven wrote:
> Hi Pavel,
> > --- /dev/null
> > +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> >
> > +/* Match table for OF platform binding */
> > +static const struct of_device_id ctucan_of_match[] = {
> > +       { .compatible = "ctu,ctucanfd-2", },
>
> Do you need to match on the above compatible value?
> The driver seems to treat the hardware the same, and the DT
> bindings state the compatible value below should always be present.

I would keep it because there will be newer revisions and releases
of the core and I consider "ctu,ctucanfd" as the match to generic
one with maximal attempt to adjust to the version from provided
info registers but identification with the fixed version
"ctu,ctucanfd-2" ensures that some old hardware which is
in the wild is directly recognized even at /sys level
and if we need to do some workarounds for autodetection
etc. it can be recognized.

I understand that in ideal world that should never be required
if we keep compatability right and if there is really new major
completely incompatible revision we would need to use new
identifier anyway. But we and the world is not perfect, so
I would keep that safety option.

May it be there are designs with 5 years old IP core version
in the wild and may it be even with this ID.... May be they
need some version specific adjustment... Yes version should be
readable from IP, hopefully, but that was experimental version
and I am not sure how much register map changed from that days
(can be analyzed from GIT if support request appears).
You know how it works with feebacks when chain of subcontracted
companies does integration for carmaker etc...

For example there appears questions and interest to update it to actual
Debian for LinCAN after ten or 15 years of silence because that
or origina CAN drivers solution works somewhere...

So I am personally more inclined to keep versionned ID.

Best wishes,

Pavel


