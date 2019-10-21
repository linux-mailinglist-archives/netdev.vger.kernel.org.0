Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65608DF86F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 01:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfJUXNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 19:13:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbfJUXNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 19:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Spuk8QNhQmrSsEHeANp2DfSWW33p/48VogUWd/jEFEw=; b=L/ZsrOUvuL2dp1l4USfKTc4/j6
        6AdNwITSAtgqYpuad7spcRbYRgzcbFcxLoy4QUxkK0A0gE6xE9rw6It+GegficWeipjSgQQiJrEaz
        +Am27urLv+h35vj22kcw4vRAqwvCZEMgAVlPQBWhdu4dsQ2E40ACrt3x5RhPDCjtILpk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMgrV-0007BV-Ch; Tue, 22 Oct 2019 01:13:17 +0200
Date:   Tue, 22 Oct 2019 01:13:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, f.fainelli@gmail.com, rmk@armlinux.org.uk
Subject: Re: [PATCH net-next 2/4] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Message-ID: <20191021231317.GA27462@lunn.ch>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-3-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571698228-30985-3-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana

> +/**
> + * dprc_get_connection() - Get connected endpoint and link status if connection
> + *			exists.
> + * @mc_io:	Pointer to MC portal's I/O object
> + * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
> + * @token:	Token of DPRC object
> + * @endpoint1:	Endpoint 1 configuration parameters
> + * @endpoint2:	Returned endpoint 2 configuration parameters
> + * @state:	Returned link state:
> + *		1 - link is up;
> + *		0 - link is down;
> + *		-1 - no connection (endpoint2 information is irrelevant)
> + *
> + * Return:     '0' on Success; -ENAVAIL if connection does not exist.

#define	ENAVAIL		119	/* No XENIX semaphores available */

This is not a semaphore.

How about

#define	ENOTCONN	107	/* Transport endpoint is not connected */

	Andrew
