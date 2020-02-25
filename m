Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D59A16C24A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgBYN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:28:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgBYN2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 08:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4p+RGUc5+ZbNK6jQIRsIeyCpqiN2vFIE2RHxhHH9WAI=; b=nuhLHYxQUeGNdnXEmFohug68rI
        01CbmWtvjIKjm0Wu+fTwj0n8zdX2/1zaxA1OEhseiJYynZT9Pwt2xano5pgI2anzw6yYVtCXgvKfR
        ZanrL0j/PujQEgiXNWAI08X3R8sdPR/k1VFlSKUKkMM7TizJ0VN2Ef1JSxji/AGeE+Tc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6aGC-0007IQ-Gd; Tue, 25 Feb 2020 14:28:28 +0100
Date:   Tue, 25 Feb 2020 14:28:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sudheesh Mavila <sudheesh.mavila@amd.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: corrected the return value for
 genphy_check_and_restart_aneg
Message-ID: <20200225132828.GD9749@lunn.ch>
References: <20200225122208.6881-1-sudheesh.mavila@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225122208.6881-1-sudheesh.mavila@amd.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 05:52:08PM +0530, Sudheesh Mavila wrote:
> When auto-negotiation is not required, return value should be zero.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>

Fixes: 2a10ab043ac5 ("net: phy: add genphy_check_and_restart_aneg()")

       Andrew
