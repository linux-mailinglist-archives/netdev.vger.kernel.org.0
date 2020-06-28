Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C32220CAC1
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 23:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgF1Vgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 17:36:41 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:59466 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgF1Vgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 17:36:40 -0400
Date:   Sun, 28 Jun 2020 21:36:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1593380198;
        bh=611E1eaCtuc3naAABWAMEtUCV7hXLVNANRYQvXdlbqY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=UTd3whxYh7s/isoSItdvlX/u0+p9RL1tVcT6cVqLmV2fM+2pWJuoK1mjbkgePAIsw
         BUZPvL+CpRF38d64Kcpw5JohHQS+RklzXtrkPU19AVUJPhkHy7PD9Xbpwa/3UlhiLR
         Itof7vPnT5j8WzLJkFsUprx+yvO6c7htKAWmok4o=
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
From:   Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org
Reply-To: Colton Lewis <colton.w.lewis@protonmail.com>
Subject: Re: [PATCH v3] net: phylink: correct trivial kernel-doc inconsistencies
Message-ID: <6541539.18pcnM708K@laptop.coltonlewis.name>
In-Reply-To: <20200628093634.GQ1551@shell.armlinux.org.uk>
References: <20200621154248.GB338481@lunn.ch> <20200621155345.GV1551@shell.armlinux.org.uk> <3315816.iIbC2pHGDl@laptop.coltonlewis.name> <20200621234431.GZ1551@shell.armlinux.org.uk> <3034206.AJdgDx1Vlc@laptop.coltonlewis.name> <20200627235803.101718-1-colton.w.lewis@protonmail.com> <20200628093634.GQ1551@shell.armlinux.org.uk>
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

> We seem to be having a communication breakdown.  In review to your
> version 2 patch set, I said:
>=20
>    However, please drop all your changes for everything but the
>    "struct phylink_config" documentation change; I'm intending to change
>    all these method signatures, which means your changes will conflict.
>=20
> But the changes still exist in version 3.  What gives?

You said *drop all your changes* for *everything but* the struct phylink_co=
nfig change. I interpreted this to mean you wanted *only* struct phylink_co=
nfig. In context of your previous comments, I might have guessed you meant =
the opposite.



