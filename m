Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60283FDDDF
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 16:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245059AbhIAOkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 10:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235318AbhIAOkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 10:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71ECC61056;
        Wed,  1 Sep 2021 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630507151;
        bh=D5wGLYTSwlKQg2nTJCKBweaZjEBj1zDsmWOCbdW3zCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hKsNdVTX3ib8l/OEsl7klXs/wLHtymQGtB7t5Zn2EjnhtMw9onkA8wY08w3jseE3Z
         KbOdEGgDL2QtXVqVhR8OyIoz3nMO/emiFNYOioj5riGiScftMX1apxUJMfVOSGIxi4
         B7dSR+6dORox/A+RrXSBYVTr/DEn+uxBNtwlNwf+CJHjc1SR2HsusNj3zU6uHrzlh5
         sqYQyIMnG6Fa2p+Wr+5RDN/PIBfM2PGVwor0KnkX87RpfngpyjzMcwuaWt2aZHpkCz
         wjcNae+985/+6GkdzeTCeqoG7EpXna2ki22BX0bm9h0wb7Kh64gkJxhSYrxUHGyBBH
         rqh1ltH4v7Wjw==
Date:   Wed, 1 Sep 2021 07:39:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     John 'Warthog9' Hawley <warthog9@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?6ams5by6?= <maqianga@uniontech.com>,
        "f.fainelli" <f.fainelli@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ming Wang <wangming01@loongson.cn>
Subject: Re: [PATCH] net: phy: fix autoneg invalid error state of GBSR
 register.
Message-ID: <20210901073910.047348b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YS95wn6kLkM9vHUl@lunn.ch>
References: <20210901105608.29776-1-maqianga@uniontech.com>
        <YS91biZov3jE+Lrd@lunn.ch>
        <tencent_405C539D1A6BA06876B7AC05@qq.com>
        <YS95wn6kLkM9vHUl@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Sep 2021 15:01:54 +0200 Andrew Lunn wrote:
> > > It looks like you are using an old tree. =20
> > Yes, it is linux-4.19.y, since 4.19.y does not have autoneg_complete fl=
ag,=EF=BC=8C
> > This patch adds the condition before
> > reading GBSR register to fix this error state. =20
>=20
> So you first need to fix it in net/master, and then backport it to
> older kernels.

Hm, the list is not seeing the emails you're responding to.

Gotta be something with uniontech's email server.

Adding John in case he can grok something from vger logs.
