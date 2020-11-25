Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B062A2C4841
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgKYT0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbgKYT03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 14:26:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA07206D9;
        Wed, 25 Nov 2020 19:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606332389;
        bh=y5G7G9tqQU0nNNYbyoVzJ6yqFdXX1xV0mpcHxeV68Ac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qnwv5kbxfR1G+CdcN52GwSplgjaPdm0fTc0l/8FM7uScdg4VvXnX4IWjOwV62BfVq
         NmbOGw0+P4rP+f+KtS7LX7YaJ5ikwX06YLbUF/9KTpjdhs4WftBY0yOJbXRHF4KVCY
         uw3BxXCNOSLzcEzAkzGMYELJkR7cypSjjVLbWGTM=
Date:   Wed, 25 Nov 2020 11:26:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Borneo <antonio.borneo@st.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, <stable@vger.kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: fix incorrect merge of patch upstream
Message-ID: <20201125112627.113c3c0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124223729.886992-1-antonio.borneo@st.com>
References: <42960ede-9355-1277-9a6f-4eac3c22365c@pengutronix.de>
        <20201124223729.886992-1-antonio.borneo@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 23:37:29 +0100 Antonio Borneo wrote:
> Commit 757926247836 ("net: stmmac: add flexible PPS to dwmac
> 4.10a") was intended to modify the struct dwmac410_ops, but it got
> somehow badly merged and modified the struct dwmac4_ops.
> 
> Revert the modification in struct dwmac4_ops and re-apply it
> properly in struct dwmac410_ops.
> 
> Fixes: 757926247836 ("net: stmmac: add flexible PPS to dwmac 4.10a")
> Cc: stable@vger.kernel.org # v5.6+
> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Applied, and queued for 5.9 (all other 5.5+ branches are EOL by now).

Thanks!
