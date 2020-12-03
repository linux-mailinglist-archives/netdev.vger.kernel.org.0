Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2363A2CCB92
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgLCBTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgLCBTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 20:19:35 -0500
Date:   Wed, 2 Dec 2020 17:18:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606958334;
        bh=PjQ2xJJDmV2fqK5cStOsN6fK1L0QGxnBctf9ZAELEeE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jSnJkGyDOAAt2KRvgC7529tMDWXc12XJmQbbQrsbQuUN/zd7JPvACWUJSwkB7CZsM
         R9Og2Tp+woPtGtfgC2w5Yb+XoBeRTYAIrI+auE+JuPcTQ7pecpMqXUgOSpo3vVjVh5
         4/qD1NzX4NAEFHMZ/q44WDk02nZoqD1Mc8OaJzWuuNmu+BpCq7zobOE+Q0JmdcSCoM
         /fOsUrkIpR3qgJ2h7Na5C+df/N4+WoNVRgCJ1uB6bUGNNR7MWWfPB/PUR87rSI6nnJ
         alxBxxsoxbIHreZ0nljWIoYnIWZMxbV3u/MeoBiPUDPcBplUJoo/naZLNPsJ0VZN+u
         S3jbvVt9F8+jQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 00/11] net: dsa: microchip: make ksz8795 driver more
 versatile
Message-ID: <20201202171852.6e61ead0@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
References: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 21:44:55 +0100 Michael Grzeschik wrote:
> This series changes the ksz8795 driver to use more dynamic variables
> instead of static defines. The purpose is to prepare the driver to
> be used with other microchip switches with a similar layout.

Applied, thanks!
