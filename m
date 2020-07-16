Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E21222B61
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgGPTBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgGPTBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 15:01:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4511D207CB;
        Thu, 16 Jul 2020 19:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594926101;
        bh=uUyO/WUcDET9l9NPCQSCwcaoCg2aHLPqtEociUNDW3A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0iemkbiqnlmqcqZmz5OzktgeI15dosdy5TsY2iQD8tGaIkq1GGlj94M8m90ucFol
         oRlSv9UbSneQKkWqUlw3d9gmqpEuSYGcbz+XbmC7+KWV+19xdHZHA9F50CZvrtWED5
         nKK6GNLdTh6HTI/k3ofeukaue+V5KlimuaaXZ4Z8=
Date:   Thu, 16 Jul 2020 12:01:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc
Subject: Re: [PATCH net-next] net: phy: continue searching for C45 MMDs even
 if first returned ffff:ffff
Message-ID: <20200716120139.78f6f9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200712164815.1763532-1-olteanv@gmail.com>
References: <20200712164815.1763532-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 19:48:15 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> At the time of introduction, in commit bdeced75b13f ("net: dsa: felix:
> Add PCS operations for PHYLINK"), support for the Lynx PCS inside Felix
> was relying, for USXGMII support, on the fact that get_phy_device() is
> able to parse the Lynx PCS "device-in-package" registers for this C45
> MDIO device and identify it correctly.
> [...]

PHY folks, is this part of the larger PCS discussion or something
you're happy to have applied in the current form?
