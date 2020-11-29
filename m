Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161DB2C7AE4
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 20:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgK2TJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 14:09:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgK2TJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 14:09:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjS3b-009O2k-DY; Sun, 29 Nov 2020 20:08:23 +0100
Date:   Sun, 29 Nov 2020 20:08:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 7/8] net: ethernet: toshiba: spider_net: Document a whole
 bunch of function parameters
Message-ID: <20201129190823.GN2234159@lunn.ch>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
 <20201126133853.3213268-8-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126133853.3213268-8-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 01:38:52PM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/toshiba/spider_net.c:263: warning: Function parameter or member 'hwdescr' not described in 'spider_net_get_descr_status'
>  drivers/net/ethernet/toshiba/spider_net.c:263: warning: Excess function parameter 'descr' description in 'spider_net_get_descr_status'
>  drivers/net/ethernet/toshiba/spider_net.c:554: warning: Function parameter or member 'netdev' not described in 'spider_net_get_multicast_hash'
>  drivers/net/ethernet/toshiba/spider_net.c:902: warning: Function parameter or member 't' not described in 'spider_net_cleanup_tx_ring'
>  drivers/net/ethernet/toshiba/spider_net.c:902: warning: Excess function parameter 'card' description in 'spider_net_cleanup_tx_ring'
>  drivers/net/ethernet/toshiba/spider_net.c:1074: warning: Function parameter or member 'card' not described in 'spider_net_resync_head_ptr'
>  drivers/net/ethernet/toshiba/spider_net.c:1234: warning: Function parameter or member 'napi' not described in 'spider_net_poll'
>  drivers/net/ethernet/toshiba/spider_net.c:1234: warning: Excess function parameter 'netdev' description in 'spider_net_poll'
>  drivers/net/ethernet/toshiba/spider_net.c:1278: warning: Function parameter or member 'p' not described in 'spider_net_set_mac'
>  drivers/net/ethernet/toshiba/spider_net.c:1278: warning: Excess function parameter 'ptr' description in 'spider_net_set_mac'
>  drivers/net/ethernet/toshiba/spider_net.c:1350: warning: Function parameter or member 'error_reg1' not described in 'spider_net_handle_error_irq'
>  drivers/net/ethernet/toshiba/spider_net.c:1350: warning: Function parameter or member 'error_reg2' not described in 'spider_net_handle_error_irq'
>  drivers/net/ethernet/toshiba/spider_net.c:1968: warning: Function parameter or member 't' not described in 'spider_net_link_phy'
>  drivers/net/ethernet/toshiba/spider_net.c:1968: warning: Excess function parameter 'data' description in 'spider_net_link_phy'
>  drivers/net/ethernet/toshiba/spider_net.c:2149: warning: Function parameter or member 'work' not described in 'spider_net_tx_timeout_task'
>  drivers/net/ethernet/toshiba/spider_net.c:2149: warning: Excess function parameter 'data' description in 'spider_net_tx_timeout_task'
>  drivers/net/ethernet/toshiba/spider_net.c:2182: warning: Function parameter or member 'txqueue' not described in 'spider_net_tx_timeout'
> 
> Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Utz Bacher <utz.bacher@de.ibm.com>
> Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
