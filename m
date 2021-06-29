Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0BF3B6BAA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhF2A0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232073AbhF2A0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 20:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 732C761CF4;
        Tue, 29 Jun 2021 00:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624926219;
        bh=f4wlMVrJoHI+NL1idxlmKF/5RXEb+XMGFjbxCrypME8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GrpwPj74jycIPFYPZmiDgtFoJrZso3obOOnff4uc4l3aabifcsTh1cJlK+63Lya+f
         8qK39zkK6B7G6RpV7yMxgege84Tuz36hGYTFcsqCiNo+FynozPPte0PQIbrxEgt1aQ
         okNqMpJ+NErsc2OkS911FdB/SnkJFH63m22vdCC/PvbmupDGMm70V0b0OlXZt4JgDB
         izHJzBnOVlEnXw99i8F6XvGu/O9neJfKEwttia4Sx2/eGc0cOcF99FDqLayqAP89Mo
         Jn6HdQpMB86c4aFsuwo4Q6n+HmWD6L8MftzoU31IwqJT4tCmF0svbnLIXJiYQpZa+5
         QAvQc/OP+eoOg==
Date:   Tue, 29 Jun 2021 02:23:35 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with
 plain RGMII interface
Message-ID: <20210629022335.1d27efc9@thinkpad>
In-Reply-To: <CADujJWWoWRyW3S+f3F_Zhq9H90QZ1W4eu=5dyad3DeMLHFp2TA@mail.gmail.com>
References: <20210628192826.1855132-1-kurt@x64architecture.com>
        <20210628192826.1855132-2-kurt@x64architecture.com>
        <20210629004958.40f3b98c@thinkpad>
        <CADujJWWoWRyW3S+f3F_Zhq9H90QZ1W4eu=5dyad3DeMLHFp2TA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Jun 2021 19:09:49 -0400
Kurt Cancemi <kurt@x64architecture.com> wrote:

> I=E2=80=99m sorry if I proposed this wrong (I am new to the kernel mailin=
g list), I
> acknowledge that this is probably not the way to fix the problem, I wanted
> to discuss why my fix is necessary. In the cover email I explained that I
> used (in the device tree) =E2=80=9Crgmii-id=E2=80=9D for the =E2=80=9Cphy=
-connection-type=E2=80=9D and the
> DPAA memac correctly reports that the PHY type is =E2=80=9CPHY_INTERFACE_=
MODE_RGMII_ID=E2=80=9D
> but without my patch the RX and TX delay flags are not set on the
> underlying Marvell PHY and I receive RX and TX errors on every network
> request. Maybe there is some type of incompatibility between the Freescale
> DPAA1 Ethernet driver and the Marvell PHY?

Which driver again?
  drivers/net/ethernet/freescale/dpaa
or
  drivers/net/ethernet/freescale/dpaa2
?
