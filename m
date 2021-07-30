Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E8A3DB7AE
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbhG3LXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhG3LXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 07:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AAD46101C;
        Fri, 30 Jul 2021 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627644212;
        bh=O27IE+j7gHANW5VvwQ6r5nimd3mK5l0+qZ9rz7zKp0Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WL/FCkoQfXtFdweNoHI9CHLptD1KLWh1LPC5z608DSxenZcveWw42QGq9p/HHQbgX
         lr+mxuO7twKTj4zC1hc5uiiH5ZuOVbnQ8UY91FLDDTlY0fhKz1AUqWB2JjAVSybc1X
         8QIv6g1B5on3g3+G37B7dMYGrFA3S6LlzJvsPFaaWZyiN4lz8xmPq2SJQpUJMncq4Z
         TwBAThKbleWKHASj76/12ga57EYVk5YZa7BQ8utlcezRVUf/oPku13EUGC7+goYF97
         oZvE/f60FtPSAwfokMLq1ymv8O9kg7utsyZvagUySSoKNhSPLmnX/dKfooEEYPQOvQ
         15XPSV4dhrKXA==
Date:   Fri, 30 Jul 2021 04:23:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hao Chen <chenhaoa@uniontech.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, qiangqing.zhang@nxp.com
Subject: Re: [net,v7] net: stmmac: fix 'ethtool -P' return -EBUSY
Message-ID: <20210730042331.03fafba1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6015f3a3-1e6e-5242-bc2b-32d3b077d0e8@uniontech.com>
References: <20210722015433.8563-1-chenhaoa@uniontech.com>
        <6015f3a3-1e6e-5242-bc2b-32d3b077d0e8@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 17:49:31 +0800 Hao Chen wrote:
> There was no email or reply for a week. Can this patch be accepted?

Looks like v7 didn't make it into patchwork, these are your submissions
which did register:

https://patchwork.kernel.org/project/netdevbpf/list/?submitter=197871&state=*

Please resend.
