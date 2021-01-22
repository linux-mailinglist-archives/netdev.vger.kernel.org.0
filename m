Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692B52FFB6C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbhAVDuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:50:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbhAVDuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 22:50:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E6E722CAE;
        Fri, 22 Jan 2021 03:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611287371;
        bh=v1e8o/XSf2bWk8/tO8FsBM5XYcWWiB9nGGDBSiBEqXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LNKmgcSj7qMKiUNikr/DJRb8kiFMEdafqMMI01XeTLVvskndnNqydXdg3QY2YcnWx
         Ei3LtF6dz7d8bIVlOzxxcWidhtUnoMS7Wp5p0TWfiiKmZjZrph55d8gNdf4Kq0TzkG
         zQQLdvooy5Um7m4ZN35mHBNtpuX6XUGofiIHr1LyG48qlcup4Mp72AL1amxuHDGCXj
         a+YIJ4cKzOhIpUEa9NKDP1ZMH0wLGBF8fSGqPlWMKC7buK4qlKyOVe6i947dRw0995
         YbaQFTRZSs/ds08S2UkC9vskpIjqLHWtZu3BTWdVffsAWFrtLxKJHkE81yg0tSwqpr
         HiGRx72xFu9Nw==
Date:   Thu, 21 Jan 2021 19:49:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove aurora nb8800 driver
Message-ID: <20210121194929.13ce1a20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <yw1x8s8mz90t.fsf@mansr.com>
References: <20210120150703.1629527-1-arnd@kernel.org>
        <yw1x8s8mz90t.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 13:58:42 +0000 M=C3=A5ns Rullg=C3=A5rd wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The tango4 platform is getting removed, and this driver has no
> > other known users, so it can be removed.
> >
> > Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>
> > Cc: Mans Rullgard <mans@mansr.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de> =20
>=20
> Acked-by: Mans Rullgard <mans@mansr.com>

Applied, thanks!
