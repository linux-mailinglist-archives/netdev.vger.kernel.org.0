Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5890328D74A
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgJNAGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbgJNAGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:06:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD0C20776;
        Wed, 14 Oct 2020 00:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633992;
        bh=LoF1sJ3Qxhrpy9joJ60Bakvq7tkRnNGdA4cB6aLL2IE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PWRjSOfT2kOQWySuhxncWm1R82fUTc8tx4YlysJsLdV2TpNvAy7AQWHsrqj+U5iCe
         Jf+/EPfRnwm7BVQlhh9jIy/t8aEBWBPBANp7bTb8SsBTZsmW58iPGJWrWxNnCJpZtT
         WL0HSpK0ALFCkRnkRlzKWga2mjnkGHOdoS/xDDss=
Date:   Tue, 13 Oct 2020 17:06:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: mscc: ocelot: remove duplicate
 ocelot_port_dev_check
Message-ID: <20201013170630.29d2d199@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011092041.3535101-1-vladimir.oltean@nxp.com>
References: <20201011092041.3535101-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 12:20:41 +0300 Vladimir Oltean wrote:
> A helper for checking whether a net_device belongs to mscc_ocelot
> already existed and did not need to be rewritten. Use it.
> 
> Fixes: 319e4dd11a20 ("net: mscc: ocelot: introduce conversion helpers between port and netdev")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thank you!
