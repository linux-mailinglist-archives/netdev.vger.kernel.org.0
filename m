Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1609E35C8AA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241762AbhDLOYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:24:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241922AbhDLOYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:24:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVxTb-00GH8N-N8; Mon, 12 Apr 2021 16:23:43 +0200
Date:   Mon, 12 Apr 2021 16:23:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <YHRX7x0Nm9Kb0Kai@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
 <YHCsrVNcZmeTPJzW@lunn.ch>
 <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
 <YHRDtTKUI0Uck00n@lunn.ch>
 <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is purely a C45 device.

> Even if the PHY will be based on the same IP or not, if it is a C45
> PHY, it will be supported by this driver. We are not talking about 2 or
> 3 PHYs. This driver will support all future C45 PHYs. That's why we
> named it "NXP C45".

So if in future you produce C45 multi-gige PHYs, which have nothing in
common with the T1 automative PHY, it will still be in this driver?

       Andrew
