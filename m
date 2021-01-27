Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1986D3052F8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhA0GAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235448AbhA0DSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 22:18:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E95206B2;
        Wed, 27 Jan 2021 02:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611712952;
        bh=qjKPSvq2/sXduQY1iPiLfKOsENOPlhHdSK6mnPq1Uvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bWQPt9KLXBZV0JQbqgPOfj6zbIiNKC1DZEyML0iXrWUHvWCszrQJV6h+cccJmsu+R
         +MLy3Iun/xK4cQPCl6MCZETZg8TwFGRPGG3tW7iRnGemnNHg+ANiJrG/oXw/b3trjI
         erGI1n8bjlFkiwXjvNYORbBr0cUBvhI+/hssZKPOwQcj6utU/fHcWkF9HNmjXaGHN8
         5X7svdUVDD0zCRmDPZ6cupaGLXMM8Abg/uCekxsBmvBmAG1ce0DUOjUvjhU8xc6EAF
         nadEx8091CWAsiQbTpz2moRU8Wm8znUBgMWZkfDt+i2evFXJnXZHRNa+U4lq3CBAT7
         B9mteYRxBRYjQ==
Date:   Tue, 26 Jan 2021 18:02:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH net-next 1/2] net: usb: qmi_wwan: add qmap id sysfs file
 for qmimux interfaces
Message-ID: <20210126180231.75e19557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87wnw1f0yj.fsf@miraculix.mork.no>
References: <20210125152235.2942-1-dnlplm@gmail.com>
        <20210125152235.2942-2-dnlplm@gmail.com>
        <87wnw1f0yj.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 17:14:28 +0100 Bj=C3=B8rn Mork wrote:
> Daniele Palmas <dnlplm@gmail.com> writes:
>=20
> > Add qmimux interface sysfs file qmap/mux_id to show qmap id set
> > during the interface creation, in order to provide a method for
> > userspace to associate QMI control channels to network interfaces.
> >
> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com> =20
>=20
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

We got two patches adding new sysfs files for QMI in close succession -
is there a sense of how much this interface will grow over time? It's
no secret that we prefer netlink in networking land.
