Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0FF2C7053
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 19:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgK0Tq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729796AbgK0Tpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:45:46 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5770C221F7;
        Fri, 27 Nov 2020 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606504562;
        bh=jP8SYl2r2cDuPz994OD0FaFWL+iaJ2Tnnt/wi39a5i8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VY0Gqrh9HmNBWQxR273LxbWKC2O9p2kJfB016TDz6m6ElEWQUwQWfUWiXDZKp4C9s
         4n1VRkdojlvep6m2FK2by1kcNOeI9TT87lyxdmzBASerpQ5YEPKTaeEfqQk0gXKUx3
         uvAGXf9i2zKt4JTHQ67c5Jf4V1ldBeibyxSEa9jQ=
Date:   Fri, 27 Nov 2020 11:16:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-11-27
Message-ID: <20201127111601.0904f768@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127100301.512603-1-mkl@pengutronix.de>
References: <20201127100301.512603-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 11:02:55 +0100 Marc Kleine-Budde wrote:
> The first patch is by me and target the gs_usb driver and fixes the endianess
> problem with candleLight firmware.
> 
> Another patch by me for the mcp251xfd driver add sanity checking to bail out if
> no IRQ is configured.
> 
> The next three patches target the m_can driver. A patch by me removes the
> hardcoded IRQF_TRIGGER_FALLING from the request_threaded_irq() as this clashes
> with the trigger level specified in the DT. Further a patch by me fixes the
> nominal bitiming tseg2 min value for modern m_can cores. Pankaj Sharma's patch
> add support for cores version 3.3.x.
> 
> The last patch by Oliver Hartkopp is for af_can and converts a WARN() into a
> pr_warn(), which is triggered by the syzkaller. It was able to create a
> situation where the closing of a socket runs simultaneously to the notifier
> call chain for removing the CAN network device in use.

Pulled, thanks!
