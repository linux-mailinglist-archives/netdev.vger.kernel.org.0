Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6961CBC21
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgEIBij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEIBij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 21:38:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0AD220708;
        Sat,  9 May 2020 01:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588988318;
        bh=gwOZ1oah0hrReukzsAEe6p9nW/KuAdPecnfJMvH3yh8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kVQJQpqr68YFTPFaXQ6QAaCQTuCaVp9MRGqupqCp40EqCjhYxTvclQXIN5etmX6Ot
         MC6ycKAu/nRsHQai8kfcK4dX/gwv0liCqqueN98d8nPwxSJPcB89nKdYEdT2rG7f/V
         ej/AxkTOB+Ym7t9Y0dqFUKdEZmw1rEXHl/N7As5o=
Date:   Fri, 8 May 2020 18:38:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
Subject: Re: [PATCH net] r8169: re-establish support for RTL8401 chip
 version
Message-ID: <20200508183837.42465dfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02afcc32-7cf3-d024-10c4-fdc1596f15f6@gmail.com>
References: <02afcc32-7cf3-d024-10c4-fdc1596f15f6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 08:24:14 +0200 Heiner Kallweit wrote:
> r8169 never had native support for the RTL8401, however it reportedly
> worked with the fallback to RTL8101e [0]. Therefore let's add this
> as an explicit assignment.
>=20
> [0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D956868
>=20
> Fixes: b4cc2dcc9c7c ("r8169: remove default chip versions")
> Reported-by: Camale=C3=B3n <noelamac@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!

> This fix doesn't apply cleanly on 4.19, let me know whether you can
> adjust it, or whether I should send a separate patch.

I don't see b4cc2dcc9c7c in v4.19, looks like it landed in v5.0. No?
