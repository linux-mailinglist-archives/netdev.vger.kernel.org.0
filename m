Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B047E306865
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhA1AIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231305AbhA1AIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:08:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3BD164DD1;
        Thu, 28 Jan 2021 00:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611792457;
        bh=NA1TfdNYUjjvv1456ylV+kfOD0RvaGd5uF+u315BJ8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BSt+otgbLkZGTeop7xro0XZqeq5lHBYry0Vv8kWRgh1SG8+OFyPI7Fpf2YZzN16MR
         0gbdbCS8XxUTpdiK67TYEz0lnz/7+kr1dx35ktSRIqTTU3xBf+gzB/hj2y5DGwIqSF
         Ryf+RRRkaxZe3uMDWGmtBtowJ+lpkjL7JKDbJ+xq8cZvDLWPQJAKepBzvRjom1Sbdj
         aPiIPEUB8oG3ExXkScVH/BK9X2SGu5UelCG11VumC7BiBepaJNb3Xlee98RpVkggUM
         dRpKDZennfOoNLLm+CIM9y/B2xx96EtIYq4aUCXRxXFkgBj7hWemQ+nowDZ4kn/JPy
         suwKlESSMkj7w==
Date:   Wed, 27 Jan 2021 16:07:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v11 0/3] AX88796C SPI Ethernet Adapter
Message-ID: <20210127160735.59b08224@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125165406.9692-1-l.stelmach@samsung.com>
References: <CGME20210125165421eucas1p21049ed87217b177c3711c7b5726bd085@eucas1p2.samsung.com>
        <20210125165406.9692-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 17:54:03 +0100 =C5=81ukasz Stelmach wrote:
> This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
> found on ARTIK5 evaluation board. The driver has been ported from a
> v3.10.9 vendor kernel for ARTIK5 board.

This one doesn't apply to net-next cleanly, please rebase + repost.
