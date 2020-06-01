Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E93C1EB0C6
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgFAVO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgFAVO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 17:14:28 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04892073B;
        Mon,  1 Jun 2020 21:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591046067;
        bh=bTcmNMh17kO9uMAxaAXHi4xCOl76UBWHIyMinra3PR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nPnQJcNLgKf5a7jPNgebpbBNvvMY4Jdz01IYG3lkaeX+2bWYfncKDfbfUDwFBqr0l
         YnutPpNzTy4D4Sy9pGQ2BFFogCvIAX57w3FENE9fAEZNBGDTLdgQskHTn5FLglnud6
         pL4byqdRN7vZWE2PlmQbzBa5lRfYKbu0z0vP+qtU=
Date:   Mon, 1 Jun 2020 14:14:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
Subject: Re: [PATCH v3 net-next 12/13] net: dsa: felix: move probing to
 felix_vsc9959.c
Message-ID: <20200601141425.3c36f08b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200531122640.1375715-13-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
        <20200531122640.1375715-13-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 May 2020 15:26:39 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Felix is not actually meant to be a DSA driver only for the switch
> inside NXP LS1028A, but an umbrella for all Vitesse / Microsemi /
> Microchip switches that are register-compatible with Ocelot and that are
> using in DSA mode (with an NPI Ethernet port).
> 
> For the dsa_switch_ops exported by the felix driver to be generic enough
> to be used by other non-PCI switches, we need to move the PCI-specific
> probing to the low-level translation module felix_vsc9959.c. This way,
> other switches can have their own probing functions, as platform devices
> or otherwise.
> 
> This patch also removes the "Felix instance table", which did not stand
> the test of time and is unnecessary at this point.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

drivers/net/dsa/ocelot/felix_vsc9959.c:1520:25: warning: symbol 'felix_info_vsc9959' was not declared. Should it be static?
