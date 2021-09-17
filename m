Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A802340EFE4
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 04:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbhIQC7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 22:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243134AbhIQC7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 22:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7741261029;
        Fri, 17 Sep 2021 02:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631847508;
        bh=cE96NOR55hgL/dwgCCI119UNQ8YtXvwjGhSiOXq7gPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vHBtb93khE7sHRzjcgVRvTTLQOd7QQYP6dkgGskWyL4VTAANgt1Dw7ftMEHanFSBI
         fWVegmiL5pMmjOXuzymRkgV7n3xy3pjNC0rSEh+NPZHxn05QRB6npCFwBFNZkjNfgE
         N6JUnzyM9fMIJzSXKzJiygFrCCqxgRvK62/zcwEHcR/RoEIbsRaTYG44vPixRr1krc
         ljCmObONkSgK09FkZfAE6eH7SlmYe/1WK1Jyaw89pSa0IVm+5/8txq24brrlDBL1S0
         EVe6jfdC7LPo/8btYzmdbC0oCnyhXxTbuFB72QTpAWzuI3gy2CofQPa38GEszFAaRI
         XUnWIZT0/JpzQ==
Date:   Thu, 16 Sep 2021 19:58:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
Message-ID: <20210916195826.4edd50e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916120354.20338-1-zajec5@gmail.com>
References: <20210916120354.20338-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 14:03:50 +0200 Rafa=C5=82 Mi=C5=82ecki wrote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>=20
> This has been tested on:
>=20
> 1. Luxul XBR-4500 with used CPU port 5
> [    8.361438] b53-srab-switch 18007000.ethernet-switch: found switch: BC=
M53012, rev 0
>=20
> 2. Netgear R8000 with used CPU port 8
> [    4.453858] b53-srab-switch 18007000.ethernet-switch: found switch: BC=
M53012, rev 5 =20

Applied, thanks!
