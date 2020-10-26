Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B302998FA
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390190AbgJZVm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:42:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390157AbgJZVm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:42:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXAFg-003gCl-LB; Mon, 26 Oct 2020 22:42:04 +0100
Date:   Mon, 26 Oct 2020 22:42:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        YueHaibing <yuehaibing@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 10/11] ch_ktls: fix enum-conversion warning
Message-ID: <20201026214204.GS752111@lunn.ch>
References: <20201026213040.3889546-1-arnd@kernel.org>
 <20201026213040.3889546-10-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026213040.3889546-10-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 10:29:57PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc points out an incorrect enum assignment:
> 
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c: In function 'chcr_ktls_cpl_set_tcb_rpl':
> drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:684:22: warning: implicit conversion from 'enum <anonymous>' to 'enum ch_ktls_open_state' [-Wenum-conversion]
> 
> This appears harmless, and should apparently use 'CH_KTLS_OPEN_SUCCESS'
> instead of 'false', with the same value '0'.
> 
> Fixes: efca3878a5fb ("ch_ktls: Issue if connection offload fails")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi Arnd

I have the same fix in my tree of W=1 fixes. I was just waiting for
net-next to open.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
