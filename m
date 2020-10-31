Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B3E2A1AAB
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgJaVP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgJaVP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 17:15:57 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD102206E9;
        Sat, 31 Oct 2020 21:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604178957;
        bh=ZkCYhDBOiB8KC+RIbhnGxjj0Eq/6u19ZNFtvAX16nxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AEHUG0IVnoqpU6bTmpVh+b2UU9U4dR7dmRBczlPdYcTds2SDz5WsnsxCt/FOT0h9A
         BZ9tkyxzO/cmguUAQllzCnfq1tdu0QcT80q2Y1PwNv/iEuWtWUuH2kO+GVJQh4VAjd
         TjcNtTyo/Wn16ICqv0YtPWVkxyhdUOCAD2s0nhdU=
Date:   Sat, 31 Oct 2020 14:15:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     Robert Hancock <robert.hancock@calian.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: axienet: Properly handle PCS/PMA PHY
 for 1000BaseX mode
Message-ID: <20201031141556.151349a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <SN6PR02MB56460D7AACA73840DF048A8CC7170@SN6PR02MB5646.namprd02.prod.outlook.com>
References: <20201028171429.1699922-1-robert.hancock@calian.com>
        <SN6PR02MB56460D7AACA73840DF048A8CC7170@SN6PR02MB5646.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 17:49:39 +0000 Radhey Shyam Pandey wrote:
> > Update the axienet driver to properly support the Xilinx PCS/PMA PHY
> > component which is used for 1000BaseX and SGMII modes, including
> > properly configuring the auto-negotiation mode of the PHY and reading the
> > negotiated state from the PHY.
> > 
> > Signed-off-by: Robert Hancock <robert.hancock@calian.com>  
> 
> Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Applied, thanks!
