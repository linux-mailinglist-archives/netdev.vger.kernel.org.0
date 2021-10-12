Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE0D42A001
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhJLIgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234745AbhJLIgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 04:36:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6028E60EE5;
        Tue, 12 Oct 2021 08:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634027679;
        bh=uiIgJYfe/iTn2VdxsSI9io+djzqw1A10YAysIwHGQm0=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=WohYy1BOWH16LwXcG9ElRILqrYeMHbEw/01V8xLpAI+roJqlsthkeVGB8VM/6WIz3
         /CqnSPO0dUVYCU02YIWNCjdM5jkaof8+lUhd8X791+/RJKTverGbLuv4XlWN9t5d88
         AR7pLj8L2ArN+vshoEyThDoXCyOimx2nUluotQLZ6mSZsfxLJMj2zzBNou/rCCaDoZ
         Pq5HD9nuZjh8zO+HFlXElsLJ+7h/LKlJSgQ9YX6PL/WXfM+c8msxZKPFzczSnb5TbC
         +tldDRKgUo3DUtXGGz1dOJvocH4bdNsRJ+u7HpiIZesIH3qx6fEJ595Rdel/4Ps8QF
         GLngJkTdqMYdw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <163402758460.4280.9175185858026827934@kwain>
References: <20211011165517.2857893-1-sean.anderson@seco.com> <163402758460.4280.9175185858026827934@kwain>
From:   Antoine Tenart <atenart@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Message-ID: <163402767629.4280.18157743138611036250@kwain>
Date:   Tue, 12 Oct 2021 10:34:36 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Antoine Tenart (2021-10-12 10:33:04)
> Quoting Sean Anderson (2021-10-11 18:55:16)
> > As the number of interfaces grows, the number of if statements grows
> > ever more unweildy. Clean everything up a bit by using a switch
> > statement. No functional change intended.
>=20
> I'm not 100% convinced this makes macb_validate more readable: there are
> lots of conditions, and jumps, in the switch.
>=20
> Maybe you could try a mixed approach; keeping the invalid modes checks
> (bitmap_zero) at the beginning and once we know the mode is valid using
> a switch statement. That might make it easier to read as this should
> remove lots of conditionals. (We'll still have the one/_NA checks
> though).
>=20
> (Also having patch 1 first will improve things).

Patch 2 *
