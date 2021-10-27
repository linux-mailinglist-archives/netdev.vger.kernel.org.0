Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C1C43CEC3
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhJ0QdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhJ0QdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38F0D60F6F;
        Wed, 27 Oct 2021 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635352239;
        bh=E2Y1dk1tuv2ILRbay2wqNUPjbrIt1GoIxWDzKO9vS/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AJrQtu6UJHg7B2uif3n30sVFwu95sKx8UVIgQyC8u1xgzrwuthfVzKiB+5zWDgG/1
         PcsfNp8ywR2vkDHKvq8nRB/2uCS1PyT2IjRx6KmEup4AOoFovJgRQRFT2WHjIoNyzA
         okZ4bPPjLX4XV1n+2G31aW1aGgEImweIWoV3HLY26nQhePEerqdzQ+bGTrb/L5Kim7
         Q97xByPlBZhU+5K6KO63MbXE3tWa1ckKZQN2Urbju41J/qeCrUc2GyJ1P+pbNX6Rtc
         hk6WGmQNIfWkMFvt1GJU3kLJZZITC5ZNJDPe45nt+31omsohMIt+3LXvJcZsfrZTZK
         X6Lj6HLoWNLVw==
Date:   Wed, 27 Oct 2021 09:30:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Jan =?UTF-8?B?S3VuZHLDoXQ=?= <jan.kundrat@cesnet.cz>,
        netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: Re: [PATCH net-next 3/4] igb: unbreak I2C bit-banging on i350
Message-ID: <20211027093036.3c60a207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025175508.1461435-4-anthony.l.nguyen@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
        <20211025175508.1461435-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 10:55:07 -0700 Tony Nguyen wrote:
> From: Jan Kundr=C3=A1t <jan.kundrat@cesnet.cz>
>=20
> The driver tried to use Linux' native software I2C bus master
> (i2c-algo-bits) for exporting the I2C interface that talks to the SFP
> cage(s) towards userspace. As-is, however, the physical SCL/SDA pins
> were not moving at all, staying at logical 1 all the time.

So targeting net-next because this never worked?
