Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BEE2605BC
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgIGUit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 16:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbgIGUir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 16:38:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2174021556;
        Mon,  7 Sep 2020 20:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599511124;
        bh=CQ2rh3UwBAj+NLRlOiFRdPT2kD9jlx5l+PaStBfsA0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RfxVjjIrzFib8T0Z9FhjEKtsLm0Eq4R8jD2XMofu79VCZKIi63SprE71AOmM9fnfF
         BmQrO9WQ6kJGBdRJ8Z7KSIqymjVoprp2SG1amAK5AuFiH6hzWctTlU84UaUUboblfR
         wJ27mrCoRIPoX37YYDSRqHc9pbr5nMKfWo+APmSg=
Date:   Mon, 7 Sep 2020 13:38:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <shawnguo@kernel.org>,
        <s.hauer@pengutronix.de>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ethernet: dwmac: remove redundant null
 check before clk_disable_unprepare()
Message-ID: <20200907133842.762cb362@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599482814-42552-1-git-send-email-zhangchangzhong@huawei.com>
References: <1599482814-42552-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 20:46:54 +0800 Zhang Changzhong wrote:
> Because clk_prepare_enable() and clk_disable_unprepare() already checked
> NULL clock parameter, so the additional checks are unnecessary, just
> remove them.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
