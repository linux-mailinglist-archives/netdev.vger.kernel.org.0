Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0356643E530
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhJ1Pek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhJ1Pej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7867B61073;
        Thu, 28 Oct 2021 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635435132;
        bh=K7MCf7+jBobo1vA8IYSHyih9/L73bzqPOpkci+23fqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qOJpNfAR/Qu2XOqjh6Y/Ft8CCVnN2TyKaPVwf5rHLrpjkevV6g0fxgC3qYUMblLNg
         HWoB/TmrF6Lw0xmOCCwT0DxqLufeLzqgu/3RNlctAYQdVggUjP4vj74Ygi66TYaDJZ
         q+4pKJXguaqKeunQuv7qXjxp9uIz6P1pnlT7xDI90SfUznXlcWr9AvB8AudsYYKdjb
         JWzIwQtHXgG492upi1OhSnWJKG3NnKKsESmAJhlgiOlTXXOroHdOiR1cgb1vDC7d4s
         5GvVdCgd5E2vd/PHTc8K31Cze/Ga0d1jmcOeh0FX7yotC1rBnv1he0UeQTTp0cRr+Z
         KV4JqtDxBzIBA==
Date:   Thu, 28 Oct 2021 08:32:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "jan.kundrat@cesnet.cz" <jan.kundrat@cesnet.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Brelinski, Tony" <tony.brelinski@intel.com>
Subject: Re: [PATCH net-next 3/4] igb: unbreak I2C bit-banging on i350
Message-ID: <20211028083211.2c0cb03f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bd6dc27167a3bb143772d2ef114de7bf4242aee9.camel@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
        <20211025175508.1461435-4-anthony.l.nguyen@intel.com>
        <20211027093036.3c60a207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bd6dc27167a3bb143772d2ef114de7bf4242aee9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 15:25:55 +0000 Nguyen, Anthony L wrote:
> On Wed, 2021-10-27 at 09:30 -0700, Jakub Kicinski wrote:
> > On Mon, 25 Oct 2021 10:55:07 -0700 Tony Nguyen wrote: =20
> > > From: Jan Kundr=C3=A1t <jan.kundrat@cesnet.cz>
> > >=20
> > > The driver tried to use Linux' native software I2C bus master
> > > (i2c-algo-bits) for exporting the I2C interface that talks to the
> > > SFP
> > > cage(s) towards userspace. As-is, however, the physical SCL/SDA
> > > pins
> > > were not moving at all, staying at logical 1 all the time. =20
> >=20
> > So targeting net-next because this never worked? =20
>=20
> Correct. Would you prefer I send this patch via net instead?

I think net-next will be fine here. Only patch 1 needs rejigging then.
