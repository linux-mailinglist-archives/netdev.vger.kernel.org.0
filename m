Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6557D2A4F15
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgKCSjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgKCSjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 13:39:42 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 996752074B;
        Tue,  3 Nov 2020 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604428782;
        bh=6Xps4bIUFtPepouNBqtps60Iy2leilNlFonhy3YWMkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h248a77653NHUhqb1KV9+o4A1pWMp00jHEw2F/2qy6d8aGuWyFbzs5I/e/VObpLu/
         GLDn8k/OtOjSLHa+8/BmLvcd2b3BL/X1CPLxzFq2TflJocMmfFZdcyBR4SyeXFxm2C
         2u5QTZGEIChOwklxepD8Sg/3taUJAVzO3T3lSjkY=
Date:   Tue, 3 Nov 2020 10:39:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] ethernet: igb: e1000_phy: Check for
 ops.force_speed_duplex existence
Message-ID: <20201103103940.2ed27fa2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <36ce1f2e-843c-4995-8bb2-2c2676f01b9d@molgen.mpg.de>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
        <20201102231307.13021-3-pmenzel@molgen.mpg.de>
        <20201102161943.343586b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <36ce1f2e-843c-4995-8bb2-2c2676f01b9d@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 08:35:09 +0100 Paul Menzel wrote:
> According to *Developer's Certificate of Origin 1.1* [3], it=E2=80=99s my=
=20
> understanding, that it is *not* required. The items (a), (b), and (c)=20
> are connected by an *or*.
>=20
> >         (b) The contribution is based upon previous work that, to the b=
est
> >             of my knowledge, is covered under an appropriate open source
> >             license and I have the right under that license to submit t=
hat
> >             work with modifications, whether created in whole or in par=
t=20
> >             by me, under the same open source license (unless I am
> >             permitted to submit under a different license), as indicated
> >             in the file; or =20

Ack, but then you need to put yourself as the author, because it's
you certifying that the code falls under (b).

At least that's my understanding.
