Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFF62EE733
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbhAGUvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:51:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbhAGUvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:51:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C525E2343B;
        Thu,  7 Jan 2021 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610052644;
        bh=vR3twviWbqVzoifMBy9iL3KzALLUQ/EEStwQfBZzYPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sJRDTMTHVogJDRYE9zTsz6MSmV/+wzdBIOUlGg2pO7hlr1gzVC/B7tlQyOE7pXu5v
         cRPbny8Zk4UBqtmO5ebklyR8/Oe3tKErQBLCYwo97ayFz/+tktP0jVfP0BoAKicx/F
         /1onVRHBdt338kBqyfdUayh0A+cOAC2CW4G/xU/yuc1CRij8zcUPtpWugeZLguCzJs
         e5wfMKzaXpgj+eBd3OxWkbUDtaWtAkKdFvp3qnYw7a1D6XMM7QIcE2wBUYFE8j5hLf
         xNZid+4FrVUX2kxb4vdjMw8B8F5eJtC6SHR/gisjCZNq0trbWN9coPsh4MLZN1qmDc
         mbCeEUEptsQSQ==
Date:   Thu, 7 Jan 2021 12:50:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY 
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next] net: phy: bcm7xxx: Add an entry for BCM72116
Message-ID: <20210107125042.3dac4fae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106170944.1253046-1-f.fainelli@gmail.com>
References: <20210106170944.1253046-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 09:09:44 -0800 Florian Fainelli wrote:
> BCM72116 features a 28nm integrated EPHY, add an entry to match this PHY
> OUI.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

net or net-next? Looks like just adding and ID and there is nothing new
in net-next in the area AFAICT.
