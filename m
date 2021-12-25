Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F17547F399
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhLYPMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 10:12:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhLYPMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Dec 2021 10:12:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=duUyZErsu2YplOH1MLDA9LxIpPGtl930GQzALds5j0M=; b=x9YBhdNe5zMP4ikxF8sWQt4aGK
        lFD+C55geE85JnxBgHZDrUxnaKF+DP/igq89VvVjLaEFU3eyyE1FiCTHM2W1P6RcR5zCHDLDQml5S
        1GQ0dhgA5MvIB1eZVP1RucYkTE+wniwCTm1xij+6VtiFPQ4UByhZPEBwuUU1CQokZGUg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n18i1-00HTAR-VN; Sat, 25 Dec 2021 16:11:45 +0100
Date:   Sat, 25 Dec 2021 16:11:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, davem@davemloft.net,
        colin.king@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: net: smc911x: Fix wrong check for irq
Message-ID: <Ycc0seKB4DdXiVm0@lunn.ch>
References: <20211224051254.1565040-1-jiasheng@iscas.ac.cn>
 <20211224150425.3c21994f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224150425.3c21994f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 24, 2021 at 03:04:25PM -0800, Jakub Kicinski wrote:
> On Fri, 24 Dec 2021 13:12:54 +0800 Jiasheng Jiang wrote:
> > Because ndev->irq is unsigned
> 
> It's not..

https://elixir.bootlin.com/linux/v5.16-rc6/source/include/linux/netdevice.h#L2065

Definitely an int.

	   Andrew
