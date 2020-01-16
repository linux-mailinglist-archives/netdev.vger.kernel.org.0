Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D78E13FACD
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 21:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgAPUqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 15:46:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbgAPUqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 15:46:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lhKxhhdaviAYxlA8QdTGMZz3KtEUWXZOP1z0zqm8hh0=; b=LiZWAhuVDJ7Da/aWyTG6z2PX9q
        dKba3m5yBWNHdAJ0lQjMluBqfS//lN+D8U//oHyak804qWxgjI2tanvFHv6wZAB1cFtH4KwBKWRUN
        M6aLH0OXSqafiT7I3Ihfbc1ZYcnjxI/Ua1deZiENMdi4FjPLfuAJE1mOzrP8E9LXnhpg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1isC2N-0000o2-TM; Thu, 16 Jan 2020 21:46:43 +0100
Date:   Thu, 16 Jan 2020 21:46:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, po.liu@nxp.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] enetc: Don't print from enetc_sched_speed_set
 when link goes down
Message-ID: <20200116204643.GL2475@lunn.ch>
References: <20200116171828.2016-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116171828.2016-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 07:18:28PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It is not an error to unplug a cable from the ENETC port even with TSN
> offloads, so don't spam the log with link-related messages from the
> tc-taprio offload subsystem, a single notification is sufficient:
> 
> [10972.351859] fsl_enetc 0000:00:00.0 eno0: Qbv PSPEED set speed link down.
> [10972.360241] fsl_enetc 0000:00:00.0 eno0: Link is Down
> 
> Fixes: 2e47cb415f0a ("enetc: update TSN Qbv PSPEED set according to adjust link speed")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
