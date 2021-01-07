Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F212EC74E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbhAGAWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:22:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbhAGAWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 19:22:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F6A20784;
        Thu,  7 Jan 2021 00:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609978919;
        bh=1hTH4aiGaFydkPU5LX1E2AiCP09K7E/orjN2BSRMDWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NV2lJn5AGpA6EO9I9GlYFXt5ddT0nqZ1Qg9AT4EmjdpnBt4wvyFVn+Rw2gx8b6aHq
         5L9GUsJL+ic6utXjJQCVCg1O9VyjRbVjrfTPj4+V3rXewVg5zyHnlVcVNqDmCu7ycW
         7ximyGwNm5oacT0Pfx3PhubV9vqbDXRQs5jb81eJOvQpK6T84DktrHSIYw0h7PFXwu
         3l++IjU050DSMlgJDYrG3fVEnwoNongJCdeL44pZtY/hHTXgF7n/qcdte1Q2JctxeP
         KVhuFSZxQoF4mV2LH1M6+2wqZvqiZCdJ5bGQLlYL23CFownRXHyiTErLkdD4e/HKcR
         CW1W1xf42WMpQ==
Date:   Wed, 6 Jan 2021 16:21:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWC?= =?UTF-8?B?IE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH next] net: dsa: print error on invalid port index
Message-ID: <20210106162157.4e0d5690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/Y6o5SJBAeyBPHx@lunn.ch>
References: <20210106090915.21439-1-zajec5@gmail.com>
        <X/Y6o5SJBAeyBPHx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 23:33:07 +0100 Andrew Lunn wrote:
> On Wed, Jan 06, 2021 at 10:09:15AM +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >=20
> > Looking for an -EINVAL all over the dsa code could take hours for
> > inexperienced DSA users. =20
>=20
> Following this argument, you should add dev_err() by every -EINVAL.
>=20
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> =20
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
