Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135B24A03AC
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351679AbiA1WbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351661AbiA1WbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C72C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 958CDB80D28
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 22:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117ACC340E7;
        Fri, 28 Jan 2022 22:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643409074;
        bh=AcpuYL8stv1HAe6fogIIdtlGOkaLs8mNBJrUXNMZj5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K0H3qAEtcso/3Shebv9xg9zLRHy0QqWGaipBqu5OCiqHqbhgwsqob/m4fjmtV6H1m
         IoDHQL3v0pwoxRS3D110aYXIPHceChYEdHh9RG0JpEhV+PQt7zBfb/VfZ9yfa6Omdq
         Oc4LZfI4uJ5NurqJCJ9Jd1ZXoPdrx2ncH9805HDX6An6ywUiJP0eztVsy5BhH09gYd
         +imBa7kUSdm24i8+C9UHJmbnM/F9eCYjy0dttbke9stNFtsovfkdRYmatY00lN15KP
         /PSb/IJAC34puhhztb1og8U7Vo09wYbr4bdovvh4Somqei+1X2aEYSZDaef5/DjpOL
         UR5NpuJT1+ZgA==
Date:   Fri, 28 Jan 2022 14:31:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: make NET_DSA_MT7530 select
 MEDIATEK_GE_PHY
Message-ID: <20220128143112.35d9d03c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128170544.4131-1-arinc.unal@arinc9.com>
References: <20220128170544.4131-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 20:05:45 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
> properly control MT7530 and MT7531 switch PHYs.
>=20
> A noticeable change is that the behaviour of switchport interfaces going
> up-down-up-down is no longer there.
>=20
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>

Sounds like a fix, can we get a Fixes tag?
