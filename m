Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA322A650D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKDNYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:24:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgKDNYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:24:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaImE-005Cye-Nl; Wed, 04 Nov 2020 14:24:38 +0100
Date:   Wed, 4 Nov 2020 14:24:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Martin Habets <mhabets@solarflare.com>,
        linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        John Williams <john.williams@xilinx.com>,
        Shannon Nelson <snelson@pensando.io>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/12] net: ethernet: xilinx: xilinx_emaclite: Document
 'txqueue' even if it is unused
Message-ID: <20201104132438.GY933237@lunn.ch>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-4-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104090610.1446616-4-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:06:01AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c:525: warning: Function parameter or member 'txqueue' not described in 'xemaclite_tx_timeout'

https://www.spinics.net/lists/netdev/msg695975.html

	Andrew
