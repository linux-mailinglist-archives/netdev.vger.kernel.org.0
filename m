Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEE5539D10
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244129AbiFAGMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbiFAGMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:12:46 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F04C5622F;
        Tue, 31 May 2022 23:12:44 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 89CE91C0003;
        Wed,  1 Jun 2022 06:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654063963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pgNnL42DuxQG2qtH9c9Cdu2K2rsnlUhIwKxh7QIXUqg=;
        b=NvhOlABr3h5P3ynQ3lfFv9RpXtBSCF9bRc0eUMZPjFGDW7fnPofh0RYmPPKy0hrRvVjvI4
        PI/q1N0hccKYUfU91pzM7Z75KbA+0deCa/XypvF8xTdiehNNLalZ/6mJGqk1SdbeiQfFym
        Z2Vm+AHg1sabx1/jyn8hxjCAlHi/sJ9gs6cqNisJVaZjSDHWCVUVQOhVfvzl2bHuN8OE4T
        jDZLFOvLZV0oT51W6s62G5E1g1PNqISIrfOKMTloY1dZQieHZ1BhQFoeGqcddRWrkT23rn
        wgcH+1r70NZpbaHGCWnoKikKE1r1zhCjP9ryADTcdLUkPpuqELB9PIhFgcdLlA==
Date:   Wed, 1 Jun 2022 08:12:40 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH wpan-next v4 00/11] ieee802154: Synchronous Tx support
Message-ID: <20220601081240.5b86b281@xps-13>
In-Reply-To: <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
        <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Tue, 31 May 2022 23:30:25 -0400:

> Hi,
>=20
> On Thu, May 19, 2022 at 11:06 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Hello,
> >
> > This series brings support for that famous synchronous Tx API for MLME
> > commands.
> >
> > MLME commands will be used during scan operations. In this situation,
> > we need to be sure that all transfers finished and that no transfer
> > will be queued for a short moment.
> > =20
>=20
> Acked-by: Alexander Aring <aahringo@redhat.com>
>=20
> There will be now functions upstream which will never be used, Stefan
> should wait until they are getting used before sending it to net-next.

That's right.

Thanks for all the feedback so far!
Miqu=C3=A8l
