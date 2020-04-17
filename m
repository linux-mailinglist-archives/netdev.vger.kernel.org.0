Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE461AE511
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgDQSoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:44:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgDQSox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+ObM/A2hqjWLRAVfTuk1oXAkCPtHwJYy8q+B7ukFaAE=; b=fV4RFFN/LTF3o1IKxSniqwMn2+
        z7pKQwnNd2tOCF74rZoLOkK0LA3Nz5Fw4QKcL2777ndtzqxfE4UADN0v0NcuvSwfCntsdCA/zxgVd
        oPjtPZWvZtmnDceU+n9WwhxDJpRpEHtM1bAMz6KxphlirgGbaBjq0CGay9bzu146Ji1I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPVyl-003Kov-OP; Fri, 17 Apr 2020 20:44:43 +0200
Date:   Fri, 17 Apr 2020 20:44:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: mdio-bcm-iproc: Do not show kernel
 pointer
Message-ID: <20200417184443.GE785713@lunn.ch>
References: <20200417183420.8514-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417183420.8514-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 11:34:20AM -0700, Florian Fainelli wrote:
> Displaying the virtual address at which the MDIO base register address
> has been mapped is not useful and is not visible with pointer hashing in
> place, replace the message with something indicating successful
> registration instead.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
