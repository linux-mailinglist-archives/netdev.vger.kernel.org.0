Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7830A348350
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbhCXU7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238052AbhCXU70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 16:59:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2EF861A09;
        Wed, 24 Mar 2021 20:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616619566;
        bh=CvO16Php+LSKrebIn3eKeKJqJUlKnyMhF+uKSaiJxsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z75QFUuND2/N3oYguYuJDghMN+pYcW21T6GJW5kCWWv9NC0amLOdzwLLTT/phFxXf
         8sjp9K648/39IKuIhZ64DSbo0crjcm/5oHwqyQuxL0LMjQfluxerBZrKD+hx4eK9Y0
         pGPGnIWfmPY8ie6FYk83hB/1/z2DIPsokW2c6WQGnFUv5nVoBkzI3tpUJh1mfjGppF
         cMVaqNQuqCyR3bI1qEZM9S06W0nOCLmhXqsxfyXiuxu6osUxLxMlWfTSjcSIzCKNta
         MWKIoMaW/AEwGRDZkTstSw59qRj2bekbsfBFuEta2o5QdETWUnSR5hzR3iDoWHW71A
         yvqFBGff6/70g==
Date:   Wed, 24 Mar 2021 21:59:22 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        devicetree@vger.kernel.org, pali@kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: ethernet-controller: create a
 type for PHY interface modes
Message-ID: <20210324215922.74f64e5f@thinkpad>
In-Reply-To: <20210324200706.GA3528805@robh.at.kernel.org>
References: <20210324103556.11338-1-kabel@kernel.org>
        <20210324103556.11338-2-kabel@kernel.org>
        <20210324200706.GA3528805@robh.at.kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Mar 2021 14:07:06 -0600
Rob Herring <robh@kernel.org> wrote:

> On Wed, Mar 24, 2021 at 11:35:55AM +0100, Marek Beh=C3=BAn wrote:
> > In order to be able to define a property describing an array of PHY
> > interface modes, we need to change the current scalar
> > `phy-connection-type`, which lists the possible PHY interface modes, to
> > an array of length 1 (otherwise we would need to define the same list at
> > two different places).
> >=20
> > Moreover Rob Herring says that we cannot reuse the values of a property;
> > we need to $ref a type.
> >=20
> > Move the definition of possible PHY interface modes from the
> > `phy-connection-type` property to an array type definition
> > `phy-connection-type-array`, and simply reference this type in the
> > original property. =20
>=20
> Why not just extend phy-connection-type to support more than 1 entry?

Hmm, that would be even better, although it would complicate the
Russell's marvell10g patches a little if we want the code to be
backward compatible with older device trees.

I will look into this.

Marek
