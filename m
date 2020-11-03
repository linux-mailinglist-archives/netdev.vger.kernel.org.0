Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4972A37FC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKCAoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:44:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgKCAoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:44:07 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFFCB22258;
        Tue,  3 Nov 2020 00:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604364247;
        bh=JbViUoCmtWwJ6RZtFVMHNjbS8wM0U77l4YnasnHFcR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MB1eM19B5iaKGiNbMAR8pdZOynt8tDhHkglZPEFwWOsJUmN+z8FZzvzmhuJK5rndX
         uQaWV34Lem6DRNenAZEIzhArexKBjYHGxhYAnkCo4eR4V8JqL1rRMZYtGkJNCeidBg
         d0UgHAR+hfagITeTFQI7YUPQoBdNbaCZGqUvZJrE=
Date:   Mon, 2 Nov 2020 16:44:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "Reviewed-by : Jesse Brandeburg" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net-next v3 00/10] net: ethernet: ti: am65-cpsw: add
 multi port support in mac-only mode
Message-ID: <20201102164405.2c93e914@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030200707.24294-1-grygorii.strashko@ti.com>
References: <20201030200707.24294-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 22:06:57 +0200 Grygorii Strashko wrote:
> This series adds multi-port support in mac-only mode (multi MAC mode) to TI
> AM65x CPSW driver in preparation for enabling support for multi-port devices,
> like Main CPSW0 on K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
> 
> The multi MAC mode is implemented by configuring every enabled port in "mac-only"
> mode (all ingress packets are sent only to the Host port and egress packets
> directed to target Ext. Port) and creating separate net_device for
> every enabled Ext. port.
> 
> This series does not affect on existing CPSW2g one Ext. Port devices and xmit
> path changes are done only for multi-port devices by splitting xmit path for
> one-port and multi-port devices. 
> 
> Patches 1-3: Preparation patches to improve K3 CPSW configuration depending on DT
> Patches 4-5: Fix VLAN offload for multi MAC mode
> Patch 6: Fixes CPTS context lose issue during PM runtime transition
> Patch 7: Fixes TX csum offload for multi MAC mode
> Patches 8-9: add multi-port support to TI AM65x CPSW
> Patch 10: handle deferred probe with new dev_err_probe() API

Applied, thanks!
