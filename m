Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBF72F04DE
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbhAJDUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:20:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAJDUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:20:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CDDD224F4;
        Sun, 10 Jan 2021 03:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610248799;
        bh=D9l2tB54sccaR1zDPHzPbGxBFLH5dsqeh3AWJIyGlH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IIeeJYwVzXSi5nwAnqStNAdz+wtR9UfInu3nKVykrs9p9qmM7b/qiT3KvTCdMoM+M
         vNVvoq8Xm4O4LanOU/po7ZtO7/ltijGy+MhjzkcrtK0jhuB+NM4I5Pdp1CXo/ZK586
         86i4CQdkwwwQ3/MRGdJ/YLlljfiYZZkMS9dXdoQ6D4yFQfSCu6TpkOukeByqy6j2+D
         6TGrsOs0T/y6KxKCHIfhZ0z1y2UrIykJWJmclpJmV0/cPLcIJCHJwOiEHJQ6pCGenX
         GX9hSdo/ao6Rau16LAghy1QD9VWZ8dSj8wcErQ5KetkIwlVm0scQFZj1Ji8qH5dUGg
         QQfbB4KP1baGA==
Date:   Sat, 9 Jan 2021 19:19:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V2 net-next 1/3] dt-bindings: net: convert Broadcom
 Starfighter 2 binding to the json-schema
Message-ID: <20210109191957.1ef47d28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106213202.17459-1-zajec5@gmail.com>
References: <20210106213202.17459-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 22:32:00 +0100 Rafa=C5=82 Mi=C5=82ecki wrote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>=20
> This helps validating DTS files. Only the current (not deprecated one)
> binding was converted.
>=20
> Minor changes:
> 1. Dropped dsa/dsa.txt references
> 2. Updated node name to match dsa.yaml requirement
> 3. Fixed 2 typos in examples
>=20
> The new binding was validated using the dt_binding_check.
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

Applied, I trust you'll follow up promptly if Rob finds anything wrong
with the DT parts :)
