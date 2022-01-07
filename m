Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CC7487148
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiAGDhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239785AbiAGDhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:37:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABDDC061212
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 19:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7293BB824D1
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 03:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEE4C36AE5;
        Fri,  7 Jan 2022 03:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641526637;
        bh=EUJ/7r1ns6I5EUB47n+Ivn4KQRXWDZiM4sD+Pz3L72k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E6VxV8BSPcCtDsfBJph8h7jlUYjd2NcQCz+EFBBk8SUYkmIxf3xCyCWUFMj2P0W0E
         pvqMxmHzzwV4/ASgw+yhHfF/TOpQWo+f2KVmJCC6jXyMpXkRCn9m3hgh9cK2tsmurz
         0sLAXV3FyfP8lkH3Lx86fwfhg3PErgm9P5LfSBL0ynpO+v3w3D+64xK2o1x4f34BoC
         dH0Pn9/72BmR+tftB+rU3dtuZmFRk9nP2ZXFgChpR6K9gnQ3mVTT1ty4UEulfZZI/f
         BSY6pmUmUCBU4S6KQX+njmKRn5k/mrefYNXT3VPhBOsj8D2nYhsQFvJLwz1LRSvfww
         574LvqO6DTNTQ==
Date:   Thu, 6 Jan 2022 19:37:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v4 09/11] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Message-ID: <20220106193715.3b606b10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220105031515.29276-10-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-10-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jan 2022 00:15:13 -0300 Luiz Angelo Daros de Luca wrote:
> Instead of a fixed CPU port, assume that DSA is correct.
>=20
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>

Transient build warning here:

drivers/net/dsa/realtek/rtl8365mb.c:1808:23: warning: unused variable 'cpu'=
 [-Wunused-variable]
        struct rtl8365mb_cpu cpu;
                             ^
