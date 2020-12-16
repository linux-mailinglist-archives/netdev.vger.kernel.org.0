Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9A52DC960
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgLPXEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbgLPXEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 18:04:39 -0500
Date:   Wed, 16 Dec 2020 15:03:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608159839;
        bh=RttwvEDUsuE1bGBayAnfgLcff4WIknofCve2Wxo3UD0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=uo9pAM7EEG4ccv1/EHMICqEwoPfn447ZqGbHRVvAA3Mp/3kFmQfH77pmYgn/Orzzx
         CpSNVkba/W6tz35MMB4/i0k3/ZQ7rzhPYzLAB1L0vTqSDAFWoKH0w407QyiWxR60Mn
         DD7e1uodtmn9CdHqRuUMWF73SysSdIHur6vEQpFi1YeZXaam3YsNGFh85AqE+T5J3V
         s/aGpScKN0QnjIsTUKs/yVsPtggAFYDtqcvuQA1oJlw95MGPephFVdPP/2oQIKOwPg
         iHqVjdmmUWTrPrwCGqH/85ZBcxH8ulD0a6v1hdWolS8lzGigyJTxZESH9451r9Csgu
         w4xYCb2X6vSfw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next] phy: fix kdoc warning
Message-ID: <20201216150358.3e1d5586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215063750.3120976-1-kuba@kernel.org>
References: <20201215063750.3120976-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 22:37:50 -0800 Jakub Kicinski wrote:
> Kdoc does not like it when multiline comment follows the networking
> style of starting right on the first line:
> 
> include/linux/phy.h:869: warning: Function parameter or member 'config_intr' not described in 'phy_driver'
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied.
