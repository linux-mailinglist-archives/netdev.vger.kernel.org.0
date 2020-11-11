Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14B82AFBFF
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgKLBba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:31:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbgKKWwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:52:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2D020679;
        Wed, 11 Nov 2020 22:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605135156;
        bh=9+qWTCAIVfMQOoi1NRuH0DOW/jGqynk1pB7Phvv8n6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TeRnNZzu+eow5uNtVKN1K2Ik9Mjzrh4sJzRzHxBwNSqCEKNCHJFpO07l39HxtnMOw
         Do+IKiduwPbaAEchVe6XeqUNObUeS9/695Jk+vV19q8i+lMZ+ji5kmqy0Xirz47rTl
         DzWPdguqnHJDAFNcBIE0uilE1uYc3cfmmZZLCvQM=
Date:   Wed, 11 Nov 2020 14:52:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net RESEND] arm64: dts: fsl-ls1028a-kontron-sl28:
 specify in-band mode for ENETC
Message-ID: <20201111145235.5e41d67a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109110436.5906-1-michael@walle.cc>
References: <20201109110436.5906-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 12:04:36 +0100 Michael Walle wrote:
> Since commit 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX") the
> network port of the Kontron sl28 board is broken. After the migration to
> phylink the device tree has to specify the in-band-mode property. Add
> it.
> 
> Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied to net, thanks!
