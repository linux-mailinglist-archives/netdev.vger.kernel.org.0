Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E812C4902
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgKYUYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgKYUYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 15:24:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A0B206F7;
        Wed, 25 Nov 2020 20:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606335888;
        bh=Dl5c+RKzPPwhuzu5T3GA8NMUY11ne19HlxPOZAzVdG0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ip0rT0TgqWXcOXvZ8vLiI0sCei2eX2wvilJmb0ORqawsdIflbMnGzUg1KzIin4iXA
         qLFTy8QjL/X6CpOqjAk5EM9DcOD8tCn3y8mPhrGMwnErOaWKyAw3qgaB176KXmHpjU
         74p4uwYVPeh8sKy1AuM3gzOLPIlFUNDIBh54BRUg=
Date:   Wed, 25 Nov 2020 12:24:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/3] net: ptp: use common defines for PTP
 message types in further drivers
Message-ID: <20201125122447.7a1fc8a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124074418.2609-1-ceggers@arri.de>
References: <20201124074418.2609-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 08:44:15 +0100 Christian Eggers wrote:
> Changes in v2:
> ----------------
> - resend, as v1 was sent before the prerequisites were merged
> - removed mismatch between From: and Signed-off-by:
> - [2/3] Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> - [3/3] Reviewed-by: Antoine Tenart <atenart@kernel.org>
> - [3/3] removed dead email addresses from Cc:
> 
> 
> This series replaces further driver internal enumeration / uses of magic
> numbers with the newly introduced PTP_MSGTYPE_* defines.

Applied, thanks!
