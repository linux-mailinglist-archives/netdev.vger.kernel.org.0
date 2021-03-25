Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB5F3495C4
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhCYPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhCYPgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 11:36:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40FFA61A28;
        Thu, 25 Mar 2021 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616686579;
        bh=iXLJUbLeZf3N+b6vJE7Eyfvv+/wl69CaEHXddCgSX6I=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=YqNk20kiHK/MWtfw0T7svde2CSkA2j7CXpF+mjevmoa+6GF+Jcbsp8bAxEnF51Yku
         0EFHxFVWJCO8LCEQkDMPa8B9WO38MrDkkTtrdBRpIM2meeQhdhgb/1jQbjbgR4GS99
         6c8KZYExhAK7j360jTn2Y8cxozPYFF4baKh9Yk2w2q+qkJBwK0ct+zAXSrEPB98Vuf
         JPQgbnKJwpCOTpYOlYe7+yRUxOHR79PDJK6uCxTzSnuTQkGwapX1hp8vCK5aDw9vMU
         cUPyEI9Ek78ENslPAq7zQzgqES6XEagSQQQGVmobRd9UEV52b/+yeJDWJwv0OUHhHj
         D6E1ermvs/XFg==
Date:   Thu, 25 Mar 2021 16:36:14 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact
 model
Message-ID: <20210325163614.11dc81f7@thinkpad>
In-Reply-To: <20210325131250.15901-12-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
        <20210325131250.15901-12-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 14:12:49 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> Print exact mode, one of

typo: model
