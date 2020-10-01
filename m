Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF527280AE6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733184AbgJAXIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgJAXIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:08:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66614206C1;
        Thu,  1 Oct 2020 23:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601593729;
        bh=1pHyViCMyAZxq87rCmC1bar3F/2pIh4QAMMvqHsnUKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LWDUtYeyci9YaoO3gdAvHlGQASG3nkDIiT5jX+1fvTjK2xrRoUCL56dsBd4y/isBG
         zXiJ0SIStTCb5k3ShcZ2ZdOzDIBO8AcBHb9rTFgFYZBGVxHpf4M5bN1f+p/fITMaAr
         7pA3q5z0m0utH4fwR7OQ1+bypUftgOjKPasq7O0c=
Date:   Thu, 1 Oct 2020 16:08:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH net-next 0/8] net: ethernet: ti: am65-cpsw: add multi
 port support in mac-only mode
Message-ID: <20201001160847.3b5d91f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 13:52:50 +0300 Grygorii Strashko wrote:
> This series adds multi-port support in mac-only mode (multi MAC mode) to TI
> AM65x CPSW driver in preparation for enabling support for multi-port devices,
> like Main CPSW0 on K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
> 
> The multi MAC mode is implemented by configuring every enabled port in "mac-only"
> mode (all ingress packets are sent only to the Host port and egress packets
> directed to target Ext. Port) and creating separate net_device for
> every enabled Ext. port.

Do I get it right that you select the mode based on platform? Can the
other mode still be supported on these platforms?

Is this a transition to normal DSA mode where ports always have netdevs?
