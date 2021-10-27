Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48EA43CE26
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbhJ0QBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238076AbhJ0QBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDEFC610A0;
        Wed, 27 Oct 2021 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635350348;
        bh=ysMNeky2jKYUgk939BZrgQAHwMOSjMPHxnF8pM2q1UU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GoWkFmMLYklXDmePbmPQ5B0X11MSB4aG+ObNmrLbSYOhMWbRRsiC4ygHafsq7OMBU
         lVUzAIqm9iOBob+eg+ys6+v1E0p3TbDbkC8Ew9qPMV8ptPyiPB0kxZ+4/pVwKWCkTN
         dV4wdrtqaEl3IPAO9o43NYuR5GvycFedr2XMx6yid9iWcJf0WjTD3lxdRmANh6ms7I
         ygTX4X9G+t22s4wSiaHSOi05S2XQ49LVbLv6uG+sbUfjLFmYS5VCaAq+n5grBSuaFT
         7twZRfTXeC/f0Yiz/xMGzW4gel4FX8xmOsgrV3S7uUiU/R2KhsVUOnUW9d0iofCz8V
         G3aoJMGOZH5Wg==
Date:   Wed, 27 Oct 2021 08:59:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-10-25
Message-ID: <20211027085906.54fdda26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <30be4834a75836d450995199b7675054561b1996.camel@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
        <30be4834a75836d450995199b7675054561b1996.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 15:51:58 +0000 Nguyen, Anthony L wrote:
> On Mon, 2021-10-25 at 10:55 -0700, Tony Nguyen wrote:
> > This series contains updates to i40e, ice, igb, and ixgbevf drivers.
> >=20
> > Caleb Sander adds cond_resched() call to yield CPU, if needed, for
> > long
> > delayed admin queue calls for i40e.
> >=20
> > Yang Li simplifies return statements of bool values for i40e and ice.
> >=20
> > Jan Kundr=C3=A1t corrects problems with I2C bit-banging for igb.
> >=20
> > Colin Ian King removes unneeded variable initialization for ixgbevf. =20
>=20
> I'm seeing this in Patchworks as accepted [1], but I'm not seeing the
> patches on the tree. Should I resend this pull request?

Sorry about that, let me take a look.
