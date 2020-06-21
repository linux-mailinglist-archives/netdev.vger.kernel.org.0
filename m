Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3CE202D9A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 01:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbgFUXCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 19:02:42 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:25464 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgFUXCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 19:02:41 -0400
Date:   Sun, 21 Jun 2020 23:02:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592780559;
        bh=d+6ukS/VLEXkmCnogukxLf8O85wjJsTS0BzKyBSGYrU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=E1dwsrIcjPU2vMPZ6EaHbKhjOiKTRduoK3mC5gRCE15VDa2pvqQ8gkVYAG3QTE6iC
         rJxRKmPic4qMbjgAGVbS3dI/VO7GSYd0K4IrarotUYCBVD207UAflcjujUlhpAoAZO
         4eqxfaHEXufMAycBL0/hizzRqvmAzynwJ59FwS/M=
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
From:   Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Reply-To: Colton Lewis <colton.w.lewis@protonmail.com>
Subject: Re: FWD: [PATCH 3/3] net: phylink: correct trivial kernel-doc inconsistencies
Message-ID: <3315816.iIbC2pHGDl@laptop.coltonlewis.name>
In-Reply-To: <20200621155345.GV1551@shell.armlinux.org.uk>
References: <20200621154248.GB338481@lunn.ch> <20200621155345.GV1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, June 21, 2020 10:53:45 AM CDT Russell King - ARM Linux admin wro=
te:
> > ---
> >   */
> >  struct phylink_config {
> >  =09struct device *dev;
> > @@ -331,7 +333,7 @@ void pcs_get_state(struct phylink_config *config,
> >   *
> >   * For most 10GBASE-R, there is no advertisement.
> >   */
> > -int (*pcs_config)(struct phylink_config *config, unsigned int mode,
> > +int *pcs_config(struct phylink_config *config, unsigned int mode,
> >  =09=09  phy_interface_t interface, const unsigned long *advertising);
>=20
> *Definitely* a NAK on this and two changes below.  You're changing the
> function signature to be incorrect.  If the documentation can't parse
> a legitimate C function pointer declaration and allow it to be
> documented, then that's a problem with the documentation's parsing of
> C code, rather than a problem with the C code itself.

I realize this changes the signature, but this declaration is not compiled.=
 It is under an #if 0 with a comment stating it exists for kernel-doc purpo=
ses only. The *real* function pointer declaration exists in struct phylink_=
pcs_ops.

Given the declaration is there exclusively for documentation, it makes sens=
e to change it so the documentation system can parse it.



