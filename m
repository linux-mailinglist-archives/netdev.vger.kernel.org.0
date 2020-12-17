Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CB92DD6B4
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgLQSA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgLQSA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:00:26 -0500
Date:   Thu, 17 Dec 2020 09:59:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608227985;
        bh=jNtML/03RYnflOWL8WR+rzcFTOWO7gE/3Mgtcxp5w/E=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kQgX/CnWq7XOhpDBIzoGnNVs1wX8YxfjImlPjcb/Yr6sMl6Y+9IWySlm2KIMyTaAr
         CQlsqumlZ8cJNbkiy2TbJs5PplEUuU0Svw1lRJSqNsxxWxLZ8VsG00ZS92pszhdJMM
         NQcxTTRmjgxyvCKZJ5e8Lms0/fKg+437IHm0mtzz29fLhUu5463K3CHDb3uUHNy2jR
         rj5nfcW/wij3uJFOpHP8LoOdQqo6twmfJAiOEk2v0cDiV6cco9rciJUapbquUSU5BW
         uHCLmJtRbww+V1g/Zi9G5eXv75SKNyT4uCYzzjNfltSVN3jQuJipPEDcnKVYTp6dqp
         C6PPxIkZb3New==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Holger Assmann <h.assmann@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/2] net: stmmac: retain PTP-clock at hwtstamp_set
Message-ID: <20201217095943.6b17db4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ae5371c0-ea53-6885-a25b-b44e9fe0b615@pengutronix.de>
References: <20201216113239.2980816-1-h.assmann@pengutronix.de>
        <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ae5371c0-ea53-6885-a25b-b44e9fe0b615@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 09:25:48 +0100 Ahmad Fatoum wrote:
> On 17.12.20 02:13, Jakub Kicinski wrote:
> >> +			netdev_warn(priv->dev, "HW Timestamping init failed: %pe\n",
> >> +					ERR_PTR(ret));  
> > 
> > why convert to ERR_PTR and use %pe and not just %d?  
> 
> To get a symbolic error name if support is compiled in (note the `e' after %p).

Cool, GTK. Kind of weird we there is no equivalent int decorator, tho.
Do you happen to know why?
