Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BF92CFF17
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgLEVJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEVJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:09:46 -0500
Date:   Sat, 5 Dec 2020 13:09:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607202545;
        bh=VNQQQ1I4L8bWmsdkj2+mmJKpBHdI8XJGeONzlCmbN3I=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KseKTjstdz+20s3Qy4lavwM/ZkpQhbJssNEgiGqZbsxouJ+jVeeyj6KwMKWg92/eo
         dGjH2Wn31LfjlvG0Pg+0z5ZiItjn4hqkPGxtRDVjI6ngO/WN4GvnMN3kJJeZrN1aW+
         DHOmaVARgx7Ok+3DnluFlBwIkPxyzDam6KG3ZDSslFZOhX7o0eqg3ahw05wILVN9pB
         dJ95GTAqOaap0B8/EcHRnqLIt9iTMDBFsEvJRce0idO5Xz06FV/KjkKZCaRlm32mxX
         pBpq7leR8GCb6V8G5juvBmW+OsqhHH96g0dBdXRpIb+HnGWdDx2rbVTtXozIOJtUJI
         vbuhDCE6qQrVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>, linux-can@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net 3/3] can: isotp: add SF_BROADCAST support for functional
 addressing
Message-ID: <20201205130904.3d81b0dc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <ce547683-925d-6971-6566-a0b54146090a@pengutronix.de>
References: <20201204133508.742120-1-mkl@pengutronix.de>
        <20201204133508.742120-4-mkl@pengutronix.de>
        <20201204194435.0d4ab3fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b4acc4eb-aff6-9d20-b8a9-d1c47213cefd@hartkopp.net>
        <eefc4f80-da1c-fed5-7934-11615f1db0fc@pengutronix.de>
        <20201205123300.34f99141@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <ce547683-925d-6971-6566-a0b54146090a@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 21:56:33 +0100 Marc Kleine-Budde wrote:
> On 12/5/20 9:33 PM, Jakub Kicinski wrote:
> >> What about the (incremental?) change that Thomas Wagner posted?
> >>
> >> https://lore.kernel.org/r/20201204135557.55599-1-thwa1@web.de  
> > 
> > That settles it :) This change needs to got into -next and 5.11.  
> 
> Ok. Can you take patch 1, which is a real fix:
> 
> https://lore.kernel.org/linux-can/20201204133508.742120-2-mkl@pengutronix.de/

Sure! Applied that one from the ML (I assumed that's what you meant).

Thanks!
