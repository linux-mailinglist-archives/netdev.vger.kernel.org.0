Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE8F2F0891
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbhAJRN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:13:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbhAJRN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 12:13:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyeH9-00HLGm-RA; Sun, 10 Jan 2021 18:13:11 +0100
Date:   Sun, 10 Jan 2021 18:13:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org
Subject: Re: [PATCH RFC net-next  06/19] net: mvpp2: increase BM pool size to
 2048 buffers
Message-ID: <X/s1p+0xCOi+BYWO@lunn.ch>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-7-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-7-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:30:10PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> BM pool size increased to support Firmware Flow Control.
> Minimum depletion thresholds to support FC is 1024 buffers.
> BM pool size increased to 2048 to have some 1024 buffers
> space between depletion thresholds and BM pool size.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 89b3ede..8dc669d 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -851,8 +851,8 @@ enum mvpp22_ptp_packet_format {
>  #define MVPP22_PTP_TIMESTAMPQUEUESELECT	BIT(18)
>  
>  /* BM constants */
> -#define MVPP2_BM_JUMBO_BUF_NUM		512
> -#define MVPP2_BM_LONG_BUF_NUM		1024
> +#define MVPP2_BM_JUMBO_BUF_NUM		2048
> +#define MVPP2_BM_LONG_BUF_NUM		2048

Hi Stefan

Jumbo used to be 1/2 of regular. Do you know why?

It would be nice to have a comment in the commit message about why it
is O.K. to change the ratio of jumbo to regular frames, and what if
anything this does for memory requirements.

	 Andrew
 
