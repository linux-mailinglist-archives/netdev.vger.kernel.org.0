Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD38D3EC414
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 19:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbhHNRUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 13:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238763AbhHNRUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 13:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF09560E97;
        Sat, 14 Aug 2021 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628961592;
        bh=R8asH1A2RMzbGJgzvQPSyTpfxnDQaqwg8AdA42XSwUg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mz/NhAmvs7vwKfpkOcsoofTxiHUgHo8x6lzWPqjqct8ZRV4p0rxVYgGrrFoVHtGbW
         ROGu39SLCig+RHP6NEKbkyhyIKZrmkmtJFKygLhUSH69Y5SMzspPAVspI+teFZY8QO
         AS35bV8d4XOQ3vFPj1KIHtPRTBO+Vt5Kda7Ronw5gETdan7l1pBSuS/1GUHpBdWVsZ
         VLAOQTGRVQ7S1ILfodpocbT75jo2BKI08rmNxVESP3/mW8qzADX+Dy4GEtImNROVM1
         aPW/KRclxKubURaq/YIQyyPL+ea/IdgMzVXyWgRoorV9UgTkarWoe5Y4Q2GEEStG0f
         Vbvr+U9iLB7pA==
Date:   Sat, 14 Aug 2021 19:19:40 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <20210814191940.1dc2ac4c@thinkpad>
In-Reply-To: <20210813084536.182381-1-yoong.siang.song@intel.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 16:45:36 +0800
Song Yoong Siang <yoong.siang.song@intel.com> wrote:

> Add Wake-on-PHY feature support by enabling the Link Status Changed
> interrupt.
>=20
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>

Hi Song,

I presume this is also tested.

The code look ok.

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
