Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B34E3254B9
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhBYRsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhBYRsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 12:48:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B506964F3B;
        Thu, 25 Feb 2021 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614275282;
        bh=0vFnIVei25vrCuzhScupdoj1nWs8I3FBSpr2w/s3tUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JNVnyD9Vv0zWy8GLsKJhscIOsZMZKGUyZga6+QWRua2CC5jqQg8gS5YYm4/XrTGrF
         YJL0ejKi1esxp/DDhBms/bvA8YYfR58MbwZX7yr0EGT/go7jmWf9kOvfBLiIe00Z8i
         yXs5vjqYd+6NbI5DPSC1MOYuvpE6Sz/wVH/gsKysODm0MognBZhD7QtU2qdH8eqBYy
         Y7R2rz75rJ28Zy31qy3c95wmgY4tG1K4tDbA1Nj/GOUXdrQR+LO4pgbgcqCNk+rOy5
         5nIXqzsVXygdM31ZCv9kV1wF8ABXlWX3YiVZHw8uZ8SrqIRQvpPSLxLWw1XqSNSa8N
         DyUltOXIiP/Gg==
Date:   Thu, 25 Feb 2021 09:48:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH net] net: broadcom: bcm4908_enet: fix NAPI poll returned
 value
Message-ID: <20210225094800.04fdd2b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dac1dd32-6b92-f863-7f01-c8131ddd96d2@gmail.com>
References: <20210224151842.2419-1-zajec5@gmail.com>
        <20210224151842.2419-2-zajec5@gmail.com>
        <dac1dd32-6b92-f863-7f01-c8131ddd96d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 09:06:18 -0800 Florian Fainelli wrote:
> On 2/24/2021 7:18 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >=20
> > Missing increment was resulting in poll function always returning 0
> > instead of amount of processed packets.
> >=20
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> =20
>=20
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controller
> driver")

Applied, thank you!
