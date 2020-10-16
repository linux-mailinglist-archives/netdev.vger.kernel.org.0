Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD0290C1D
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 21:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410571AbgJPTJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 15:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393044AbgJPTJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 15:09:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6B6207C4;
        Fri, 16 Oct 2020 19:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602875358;
        bh=UH+LqKT3oN3+/EeshsEExMkweOm/Xm7GjfB344nBP4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XhcRF2XPdR5z9JSbFGoLsxNrJ7KXG/sIEo4sooWrWG8fPSrX9k1wd7OoBnpIc+3kn
         pSZ/YXeNa24oqt/pASEWgZRvBZZJvXmGVpgwPnEKN6ArGbsCFOU+wS8wVg87lLF45U
         NgnjDi2KsijImSNUoGOFjw60a5gUb1kc519EEl+g=
Date:   Fri, 16 Oct 2020 12:09:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: Re: [PATCH v3 net-next] net: stmmac: Enable EEE HW LPI timer with
 auto SW/HW switching
Message-ID: <20201016120916.42ee51ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016024353.4717-1-weifeng.voon@intel.com>
References: <20201016024353.4717-1-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 10:43:53 +0800 Voon Weifeng wrote:
> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> 
> This patch enables the HW LPI Timer which controls the automatic entry
> and exit of the LPI state.
> The EEE LPI timer value is configured through ethtool. The driver will
> auto select the LPI HW timer if the value in the HW timer supported range.
> Else, the driver will fallback to SW timer.
> 
> Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Hopefully stmmac folks can review but unfortunately we already sent a PR
for 5.10 and therefore net-next is closed for new drivers and features.

Please repost when it reopens after 5.10-rc1 is cut.
