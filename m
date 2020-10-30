Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EED2A0C3C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgJ3RLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgJ3RLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 13:11:36 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24AAD20731;
        Fri, 30 Oct 2020 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604077895;
        bh=NKWXyt09m2Fju1vlya6H/SM3wonRJzKMq/JlAfiMXKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PBWbiyDhx4rRQRxiI3pHNBMBLWfBRyQH1pxyVdczM9OS3TAjSEHJZKggAaV5L26hQ
         wE08sNw4wQdXtFFU/+XPpt1CpVtwyuCKdStTJpALJQkwmY0/uEsgULZFZh5mU2a8zU
         /syLhTfwYANLPu0gbhRMHBLalvfTAic3HBxTt110=
Date:   Fri, 30 Oct 2020 10:11:33 -0700
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
Subject: Re: [RESEND v3 net-next] net: stmmac: Enable EEE HW LPI timer with
 auto SW/HW switching
Message-ID: <20201030101133.7a222a89@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027160051.22898-1-weifeng.voon@intel.com>
References: <20201027160051.22898-1-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 00:00:51 +0800 Voon Weifeng wrote:
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

Applied, thanks!
