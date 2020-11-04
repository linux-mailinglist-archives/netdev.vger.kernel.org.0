Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FDC2A6548
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgKDNd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:33:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgKDNd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:33:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaIvC-005D94-K0; Wed, 04 Nov 2020 14:33:54 +0100
Date:   Wed, 4 Nov 2020 14:33:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/12] net: ethernet: ti: am65-cpsw-qos: Demote
 non-conformant function header
Message-ID: <20201104133354.GA933237@lunn.ch>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-7-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104090610.1446616-7-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:06:04AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'ndev' not described in 'am65_cpsw_timer_set'
>  drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'est_new' not described in 'am65_cpsw_timer_set'
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I _think_ these have got missed so far in the various cleanup passes
because of missing COMPILE_TEST. I've been adding that as part of
fixing these warnings. When your respin, could you add that as well?

Thanks
	Andrew
