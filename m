Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF16241AAEE
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbhI1ItH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 04:49:07 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:27661 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239563AbhI1ItG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 04:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1632818824;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=gbQ3IMAvZc7aLDyCplOxZibt9MvPS8SVs44QxppKxOA=;
    b=gFiugyO1XIpCrAYcg8xIW2AhFwdl2RbtwCdPt4NTRkscDiDegdROOIVST81bAyCka/
    EUllEQJtKRKVGbJ1teX/P6NLpUZvnmiPjkgTCeyLIVvWwa2QN8shsnqhjrqU2aDN5ecF
    mxr7NL387Jowb+kxHSo0UrbsepeeegSnaY+kLYKaES6fdXDPSxB0nWRbbdN20gnKshb5
    6/9SIAvmt4D3mTlHD4snShtF6grlbJqGwSVR9mz76Yr0JXPSoyl/JRV7l9cOBsluRdOv
    wiRu+ctTA2zabJJ/0KIjE422OGTM2x6HMbraVm4IKBYt/Iiis9ir3waz2v0rKMspAs5P
    YjlA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fGl/w2B+Io="
X-RZG-CLASS-ID: mo00
Received: from oxapp02-03.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.33.8 AUTH)
    with ESMTPSA id c00f85x8S8l3dQz
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 28 Sep 2021 10:47:03 +0200 (CEST)
Date:   Tue, 28 Sep 2021 10:47:03 +0200 (CEST)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Wolfram Sang <wsa@kernel.org>, Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, yoshihiro.shimoda.uh@renesas.com,
        wg@grandegger.com, mkl@pengutronix.de, kuba@kernel.org,
        mailhol.vincent@wanadoo.fr, socketcan@hartkopp.net
Message-ID: <128093803.822456.1632818823845@webmail.strato.com>
In-Reply-To: <YU3+K5WQkBC2YBBy@ninjato>
References: <20210924153113.10046-1-uli+renesas@fpond.eu>
 <20210924153113.10046-2-uli+renesas@fpond.eu> <YU3+K5WQkBC2YBBy@ninjato>
Subject: Re: [PATCH 1/3] can: rcar_canfd: Add support for r8a779a0 SoC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev24
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 09/24/2021 6:34 PM Wolfram Sang <wsa@kernel.org> wrote:
> 
>  
> >  1 file changed, 152 insertions(+), 75 deletions(-)
> 
> Nice work, Ulrich. Compared to the BSP patch which has "422
> insertions(+), 128 deletions(-)", this is a really good improvement.
> 
> Did you test it on D3 to ensure there is no regression? Or are the
> additions in a way that they don't affect older versions?

The behavior of the driver on non-V3U systems is unchanged.

CU
Uli
