Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA39289D17
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgJJBcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729487AbgJJBJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:09:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF282076E;
        Sat, 10 Oct 2020 01:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602292168;
        bh=zVXI7Xsxrr9zJ7BZ8/DTnYCiJVp2vlRnm6jMoWz51Mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S2YcdyyCDQlRS810sfuniQpx/6QP/jTQZgLiWj7jDRG9jIFDql2pMPzi4IT1UN87s
         N7azef/m4bC3Xnl4JQXAfKa48XVudExm/PDHlzvxToExVjqTSfi7N2sIJXXEfM6EEg
         pwashQ+qmfrj6APBb0XoKdQxQbsSA2jdc4DHAxDY=
Date:   Fri, 9 Oct 2020 18:09:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can-next 2020-10-07
Message-ID: <20201009180926.2a85bc8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 23:31:42 +0200 Marc Kleine-Budde wrote:
> The first 3 patches are by me and fix several warnings found when compiling the 
> kernel with W=1.
> 
> Lukas Bulwahn's patch adjusts the MAINTAINERS file, to accommodate the renaming 
> of the mcp251xfd driver.
> 
> Vincent Mailhol contributes 3 patches for the CAN networking layer. First error
> queue support is added the the CAN RAW protocol. The second patch converts the
> get_can_dlc() and get_canfd_dlc() in-Kernel-only macros from using __u8 to u8.
> The third patch adds a helper function to calculate the length of one bit in in
> multiple of time quanta.
> 
> Oliver Hartkopp's patch add support for the ISO 15765-2:2016 transport protocol
> to the CAN stack.
> 
> Three patches by Lad Prabhakar add documentation for various new rcar
> controllers to the device tree bindings of the rcar_can and rcan_canfd driver.
> 
> Michael Walle's patch adds various processors to the flexcan driver binding
> documentation.
> 
> The next two patches are by me and target the flexcan driver aswell. The remove
> the ack_grp and ack_bit from the fsl,stop-mode DT property and the driver, as
> they are not used anymore. As these are the last two arguments this change will
> not break existing device trees.
> 
> The last three patches are by Srinivas Neeli and target the xilinx_can driver.
> The first one increases the lower limit for the bit rate prescaler to 2, the
> other two fix sparse and coverity findings.

Pulled, thank you!

Would you mind in the future adding net-next to the patch subject like
we do for normal patches directly applied to net-next? That way our
build bot will test the patches. I should just teach it to recognize
PRs but I haven't found the time, yet :(
