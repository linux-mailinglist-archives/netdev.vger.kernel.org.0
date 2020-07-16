Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3BD222C6A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgGPT6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgGPT6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 15:58:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC28207BC;
        Thu, 16 Jul 2020 19:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594929520;
        bh=mYRH/5QLHw+w16h0hpdjBq1ciqTth9K6GxuOKWCyVjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KqjRrJyLpBQceJOVImWVAGwnOdAmm6131saHYUeRsnFKZmYzYpKbDf7x0PhtzU7ff
         qItFHVo6433DIPDtcS3uoZKuJZ3N2GSRZ+cfOzl3uMukt+w6aRCDTYovyIKVH7MY2m
         m1CzXVwXHXKk/ldQmlsV8x4vZuHtfWpwiCxO0vGA=
Date:   Thu, 16 Jul 2020 12:58:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: rethink Kconfig
 dependencies again
Message-ID: <20200716125837.45205c42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200712212833.1892437-1-olteanv@gmail.com>
References: <20200712212833.1892437-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 00:28:33 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Having the users of MSCC_OCELOT_SWITCH_LIB depend on REGMAP_MMIO was a
> bad idea, since that symbol is not user-selectable. So we should have
> kept a 'select REGMAP_MMIO'.

Applied, thanks.
