Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A7C438B67
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhJXScw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:32:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230016AbhJXScw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oNxMQUGHKyBCn2GPEOyLZdcvyL/X2AF6FgAN39hAAmU=; b=3bUZ/1be0DAQcSmmKUInt1UMml
        5h2Bpo5hjKK+2BgznKHnaN3o0D6AX8eYX2jyiC9tPymk+xTmlb+jcKPjmFPe5H1QA9X/fT1QJQLys
        AS29wsaEY8m5pkmacWGQsDZ2Pdc/1U+KVTHx6NASaohjlPM4NgDpJA5syTfhkflHLbMo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiGJ-00BZxx-De; Sun, 24 Oct 2021 20:30:27 +0200
Date:   Sun, 24 Oct 2021 20:30:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 06/14] net: phy: add qca8081 read_status
Message-ID: <YXWmQ2MKTPrbhgiZ@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-7-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-7-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:30PM +0800, Luo Jie wrote:
> 1. Separate the function at803x_read_specific_status from
> the at803x_read_status, since it can be reused by the
> read_status of qca8081 phy driver excepting adding the
> 2500M speed.
> 
> 2. Add the qca8081 read_status function qca808x_read_status.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
