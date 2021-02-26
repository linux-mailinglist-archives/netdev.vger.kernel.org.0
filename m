Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05AF326A6D
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBZXgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhBZXgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:36:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E22B864EFA;
        Fri, 26 Feb 2021 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614382568;
        bh=qY4vMF6zA1Esx2A9+Ztvl2BvQl2kDYWfda3Ih0vakKU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fViSDvEHkvMkJN3excDFbrmSBWnWOOY5+ufot+sVO/a4JLoO484oBPgcLWqnVgld+
         GMvbkApg93Fc6khHUhHS1gbfgYESXZRAuX1Zk0m7GnVdgFJzpjsvD1YbnAbxkq0+8a
         fNzRBSI9lVbgTqbNm90F/Bj0wF1eIYQSXR+k/tEM6uXuM/B3Szq+df133IIfqKtfla
         T0lqJ2N2Wezi48RBtocG5XaiO+8VSsff4BG9L40IKVxcXA9OwkUQQbegw3Rk6maa5X
         u/fvplvv1Ysls/spUX0+c3BjiXqekhGKvrLFpKG0L/ZWSY9dulCe9lUxK2uo3eYn0d
         U0GDc7dVCA90w==
Date:   Fri, 26 Feb 2021 15:36:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: mscc: ocelot: select NET_DEVLINK
Message-ID: <20210226153606.658b98d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225143910.3964364-1-arnd@kernel.org>
References: <20210225143910.3964364-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 15:38:31 +0100 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without this option, the driver fails to link:
> 
> ld.lld: error: undefined symbol: devlink_sb_register
>  [...]  
> 
> Fixes: f59fd9cab730 ("net: mscc: ocelot: configure watermarks using devlink-sb")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied patch 1 and 2, I'll take Qingfang's patch for mt7530, thanks!
