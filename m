Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC7626625B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgIKPnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgIKPk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:40:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C107206F4;
        Fri, 11 Sep 2020 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599838850;
        bh=zzWjTJEeO1Mzv9RyZoB9yNlnHJKEb/2Y9Tw1813MRsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QLyIooXKlYxu61+c4QrwIBZDSTerUe0S41bGigOTvy8jXDAjalzrjq2wTzPG7CXJD
         45ow7Z8MvZHw1oIPYp/GBikPkdH+ePuNOARYut91mcsQx+CkGlR7IqMcnVhqnq614E
         0Jt7GcJRYy7xlBIJyJK8HDkWY55skoZG85sotTEY=
Date:   Fri, 11 Sep 2020 08:40:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] net: ag71xx: add ethtool support
Message-ID: <20200911084048.3d520502@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911082528.27121-2-o.rempel@pengutronix.de>
References: <20200911082528.27121-1-o.rempel@pengutronix.de>
        <20200911082528.27121-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 10:25:27 +0200 Oleksij Rempel wrote:
> Add basic ethtool support. The functionality was tested on AR9331 SoC.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
