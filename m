Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F3B29DF51
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404012AbgJ2BAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731544AbgJ1WR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28D32222E9;
        Wed, 28 Oct 2020 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603848695;
        bh=YMddjiw9nDrxLgUoIKnUd2B5IBw2COwdEnecaxOwZUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0jwHVQ9LmCfgg5GmQoLZviXlS3+oR8ovHo0aBLxYwry4Nxg9z/Zuq7GNYR9s9FHj7
         81WXcFtS+jbcZREjh5LYDzSS6V4lZMe6a9s9ZDFkftNwWVaLmCuBSZU4fDWwlrdjST
         2m5ZmdTNHpYeQ+XyKA5vjDiu+zb/fJh9SHNQvB6s=
Date:   Tue, 27 Oct 2020 18:31:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: disable BMCR_ISOLATE in
 phylink_mii_c22_pcs_config
Message-ID: <20201027183134.696cc6ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026175802.1332477-1-robert.hancock@calian.com>
References: <20201026175802.1332477-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 11:58:02 -0600 Robert Hancock wrote:
> The Xilinx PCS/PMA PHY requires that BMCR_ISOLATE be disabled for proper
> operation in 1000BaseX mode. It should be safe to ensure this bit is
> disabled in phylink_mii_c22_pcs_config in all cases.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> 
> Resubmit tagged for net-next.

Applied, thank you!
