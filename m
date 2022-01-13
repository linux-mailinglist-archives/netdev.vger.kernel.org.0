Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C65548DC27
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiAMQpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:45:20 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:42863 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiAMQpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:45:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1642092287;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=eqEZwnnhqa9x5sUpmp5+dl8+luCawycK4EknAItN9o0=;
    b=f/TX8xb4MNyOSeZTVcP3hLR3JTn+t4iOXGSwd94rgi5oH+6ahWPTCOITmKq66XbtTB
    3XgED/0B43N+E7q95aDElRDWP1IdppfWy+f15q8l50ovEzckAQ8oJ6IW0gotcF/mwMP3
    5+gpw8fwe/i9jnKss1cXs4rAy52GKb+QuTdQqbX71SEGPMcZuRBLG1Rexx2Q/eVqwt7c
    gtul07yXn3vNx9LUgRfy+WQ648Xnc7JHgkunFIbxhc9Yb3fM4k//hOk2E7/O/kIKr884
    b+Tyap5P8i6vTA0qxlwUzB8fQ0MsBmLLF2mTKXY4qdGu6vytd37cRcIzuhdvx+2mGaSP
    //aw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCs/83N2Y0="
X-RZG-CLASS-ID: mo00
Received: from oxapp05-01.back.ox.d0m.de
    by smtp.strato.de (RZmta 47.37.6 AUTH)
    with ESMTPSA id a48ca5y0DGikQkB
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Thu, 13 Jan 2022 17:44:46 +0100 (CET)
Date:   Thu, 13 Jan 2022 17:44:46 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com
Message-ID: <1933768449.3343335.1642092286817@webmail.strato.com>
In-Reply-To: <20220112184327.f7fwzgqvle23gfzv@pengutronix.de>
References: <20220111162231.10390-1-uli+renesas@fpond.eu>
 <20220111162231.10390-3-uli+renesas@fpond.eu>
 <20220112184327.f7fwzgqvle23gfzv@pengutronix.de>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for r8a779a0 SoC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev33
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 01/12/2022 7:43 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > +#define IS_V3U (gpriv->chip_id == RENESAS_R8A779A0)
> 
> I really don't like this macro, as it silently relies on gpriv....and
> I really don't like this use of this macro in the other macros that lead
> to 2 or even 3 ternary operators hiding inside them. Is there any chance
> to change this?

Good point. I guess I should turn that into a function.

CU
Uli
