Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CC343DD06
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhJ1Inh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhJ1Ing (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 04:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E7660FC4;
        Thu, 28 Oct 2021 08:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635410469;
        bh=PUdkRpdaFEha0IDERCsBjCyXNk9SNrJRuw2ZVS11vQg=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=pGLY0B40ujbnWvf5mcmjamRMwiClspWqE8vYOO9MLBqXmJT5HMwBgX0thYrK/2Vug
         A/nFlv4xb26POczFU+/q2bMM0VqMN6BmcpPN0Zi8VHFEKikiG62rFvC26oA0bx5Sth
         YAqBWWUYeYEDXJIjXvOomYtKaPnrwSUyptEOhbPV07iOKmI3StjX1RP32STHEmeilo
         RCP+Y6XPzEygJ/YoHyslCqTVGE1GggH1XA5h0fnRBpucojWIWtqr+DLFoaDRDmfbxD
         BL0/1GO4CzSK7b5cVD2jFmrIs7u5hDYWme17UZ9rtmfG1N4sdXErjz70QBn2X0RUhP
         ZuNn7G9BevU7w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211028084520.4b96f93a@bootlin.com>
References: <20211027131953.9270-1-maxime.chevallier@bootlin.com> <163535070902.935735.6368176213562383450@kwain> <20211028084520.4b96f93a@bootlin.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [RFC PATCH net] net: ipconfig: Release the rtnl_lock while waiting for carrier
Cc:     David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Message-ID: <163541046633.3482.18345071972962863993@kwain>
Date:   Thu, 28 Oct 2021 10:41:06 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Maxime Chevallier (2021-10-28 08:45:20)
> On Wed, 27 Oct 2021 18:05:09 +0200
> Antoine Tenart <atenart@kernel.org> wrote:
> >Quoting Maxime Chevallier (2021-10-27 15:19:53)
> >>=20
> >> Fixes: 73970055450e ("sfp: add SFP module support") =20
> >
> >Was this working with SFP modules before?
>=20
> From what I can tell, no. In that case, does it need a fixes tag ?
> It seems the problem has always been there, and booting an nfsroot
> never worked over SFP links.

In that case I'd say targeting net-next is fine.

Antoine
