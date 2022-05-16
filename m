Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5CA528DF3
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 21:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345443AbiEPTbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 15:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345442AbiEPTba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 15:31:30 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED9717E30;
        Mon, 16 May 2022 12:31:27 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 735D730B2945;
        Mon, 16 May 2022 21:31:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=bxOMg
        wvqttgq9P/9WQqucB3rNYax4JIqpBYk4OHI+2Y=; b=cWfow5MnS9l8mZEBD4rnO
        0FPD7BIyeff9uSiJ0/BhSupm3Kh+l6VgeNeCTBNc8/tgsx9ZDGytLvraipGeY5Zq
        l1zqKtwkYUgHVfYkcRGuGGNojiz0RjX5/SXmbAl5SmmBnRoDlnZvhS2ww4HMQOcq
        OQeGOnpWvfFxR8YVnwpVnnxv9vss3Lz71sXB7xjiLqOCJrGj5/vHonBqHPiGjNhA
        Y+svEq5w+rdxjGPbu8NueIruX4Pg6hCcwWxYpwudSy462eg4KyqRf7LYoUa7d89g
        gvj0hMxEPNlDXHaBcNVf3XfUc6mwfzT+QGA1uP6yleP5PwBvI8JiPT/GWIPokwrT
        A==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id A639830B2942;
        Mon, 16 May 2022 21:31:25 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 24GJVPET031998;
        Mon, 16 May 2022 21:31:25 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 24GJVP0i031997;
        Mon, 16 May 2022 21:31:25 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Akira Yokosawa <akiyks@gmail.com>
Subject: Re: [PATCH net-next v2] docs: ctucanfd: Use 'kernel-figure' directive instead of 'figure'
Date:   Mon, 16 May 2022 21:31:02 +0200
User-Agent: KMail/1.9.10
Cc:     "Marc Kleine-Budde" <mkl@pengutronix.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com> <5986752a-1c2a-5d64-f91d-58b1e6decd17@gmail.com> <38d102ab-d0b6-3467-4dce-4a9d4aa9e39d@gmail.com>
In-Reply-To: <38d102ab-d0b6-3467-4dce-4a9d4aa9e39d@gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202205162131.02560.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Akira,

On Monday 16 of May 2022 13:24:49 Akira Yokosawa wrote:
> On Wed, 11 May 2022 08:45:43 +0900, Akira Yokosawa wrote:
> > Two issues were observed in the ReST doc added by commit c3a0addefbde
> > ("docs: ctucanfd: CTU CAN FD open-source IP core documentation.")
> > with Sphinx versions 2.4.4 and 4.5.0.
> >
> > The plain "figure" directive broke "make pdfdocs" due to a missing
> > PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
> > directive, which is an extension for kernel documentation, should
> > be used instead.
> >
> > The directive of "code:: raw" causes a warning from both
> > "make htmldocs" and "make pdfdocs", which reads:
> >
> >     [...]/can/ctu/ctucanfd-driver.rst:75: WARNING: Pygments lexer name
> >     'raw' is not known
> >
> > A plain literal-block marker should suffice where no syntax
> > highlighting is intended.
> >
> > Fix the issues by using suitable directive and marker.
> >
> > Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
> > Fixes: c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core
> > documentation.") Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > Cc: Martin Jerabek <martin.jerabek01@gmail.com>
> > Cc: Ondrej Ille <ondrej.ille@gmail.com>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > ---
> > Changes in v1 -> v2
> >  - no change in diff
> >  - added explicit Sphinx versions the issues were observed
> >  - picked Pavel's Acked-by
>
> Gentle ping to netdev maintainers.
>
> I believe this one should go upstream together with the
> offending commit.

I think that the patch is on the right route thanks
to Marc Kleine-Budde already, it is in the linux-can-next
testing

https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?h=testing&id=f898bbb9c92e33dcbe7ee29b8861b707c2cd509e

I hope that it would reach net-next after next
linux-can-next merge.

Best wishes,

                Pavel
-- 
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

