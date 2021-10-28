Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5864243D88D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhJ1BcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhJ1BcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 21:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E3A61139;
        Thu, 28 Oct 2021 01:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635384577;
        bh=uokBlSXS094pKVa9bOSFdbhnVbLf1kOZl+IVnDQthII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gOdmDi4RbMaLXuhQRXLiky0iAXUB064PRvzUsDfocp4NmS8CdSqibwteGRmOj7Ddh
         R04vGO1gI0R87exRqUexqs0OITJjBJca6++lWyv84IV6kxfR4fif0GISq4Hu0SNUFb
         AveGN+9Yd0Y1hXqFLV6P8DefzXKcBmmRMjKEKV0HAxgs3C2dD4Z/fIkWW8GLNOkapK
         3Neng5WC9oxP6g+CxN3nt/lan3a/dXE8mF9sYR3trukpkvHK9DDr+5vJhjAc72zo/P
         Ltq3XKANRiX2+K1C/Bzgc0GNQepQ8QSBByGzjde0W2WDnx+L6I+VTUKUDJaXvrSztu
         Y6UZSm4/2uhrA==
Date:   Wed, 27 Oct 2021 18:29:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, lgirdwood@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: Fix unsigned comparison with less than zero
Message-ID: <20211027182936.4b43d988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1635325191-101815-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1635325191-101815-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 16:59:51 +0800 Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/net/phy/at803x.c:493:5-10: WARNING: Unsigned expression
> compared with zero: value < 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: ea13c9ee855c ("drivers: net: phy: at803x: separate wol specific code to wol standard apis")

Please pay more attention.

This is not a correct fixes tag, take a look at the code, the
comparison was introduced in 7beecaf7d507 ("net: phy: at803x: improve
the WOL feature").

Do not fix spelling of the quoted commits. You replaced seperate
with separate and I had fun time trying to figure out why scripts
complain that the fixes tag is incorrect.

Fixed and applied to net-next.
