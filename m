Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874542F5957
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbhAND0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbhAND0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:26:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB3D235FA;
        Thu, 14 Jan 2021 03:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610594754;
        bh=kDhl4UZgTl7TANhEOBqvBUAPUvIxY9nlALsoOq6JMSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SBehFEYQE8eMcPm45EzUOint4uR9gYTeGiCA9MGm71aRZwo+6skEhYHSA2xx9I4kV
         7iC5wJaZqsMtKWUTJPsrV636KJLCNQzOiDQlgcz1dqBV++2bCe/i+bjYV9bL3+yavw
         e91kqDgcoHpLpw766HG+8OYijOzaOd48ckfvno3NNnt2U1lb8Xuzb+bmuNkoK2XlcY
         xMWa8JE5RSnqDLo/RkCFG8G/9+/gCCcN6tNozAtKtUorP6OaG9RVziMf1ex/4texsN
         TGHwKUWq8EwRLFI6MXvEuqK3NRCuMBPYLWUpmKbRx3Cd9GlozPEpWkAc3VigwJKc9X
         /3jCs5xW5BuKA==
Date:   Wed, 13 Jan 2021 19:25:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 00/10] Configuring congestion watermarks on
 ocelot switch using devlink-sb
Message-ID: <20210113192552.7d06261d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111174316.3515736-1-olteanv@gmail.com>
References: <20210111174316.3515736-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 19:43:06 +0200 Vladimir Oltean wrote:
> In some applications, it is important to create resource reservations in
> the Ethernet switches, to prevent background traffic, or deliberate
> attacks, from inducing denial of service into the high-priority traffic.
> 
> These patches give the user some knobs to turn. The ocelot switches
> support per-port and per-port-tc reservations, on ingress and on egress.
> The resources that are monitored are packet buffers (in cells of 60
> bytes each) and frame references.
> 
> The frames that exceed the reservations can optionally consume from
> sharing watermarks which are not per-port but global across the switch.
> There are 10 sharing watermarks, 8 of them are per traffic class and 2
> are per drop priority.
> 
> I am configuring the hardware using the best of my knowledge, and mostly
> through trial and error. Same goes for devlink-sb integration. Feedback
> is welcome.

This no longer applies.
