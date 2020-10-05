Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3872841B2
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgJEUyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:54:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJEUyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 16:54:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kPXUm-000H1f-VW; Mon, 05 Oct 2020 22:54:08 +0200
Date:   Mon, 5 Oct 2020 22:54:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 net-next 3/3] net: atlantic: implement media detect
 feature via phy tunables
Message-ID: <20201005205408.GD56634@lunn.ch>
References: <20201005153939.248-1-irusskikh@marvell.com>
 <20201005153939.248-4-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005153939.248-4-irusskikh@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 06:39:39PM +0300, Igor Russkikh wrote:
> Mediadetect is another name for the EDPD (energy detect power down).
> This feature allows device to save extra power when no link is available.
> 
> PHY goes into the extreme power saving mode and only periodically wakes up
> and checks for the link.
> 
> AQC devices has fixed check period of 6 seconds
> 
> The feature may increase linkup time.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
