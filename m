Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D921368444
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhDVP5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236333AbhDVP5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C3EF613D1;
        Thu, 22 Apr 2021 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619107009;
        bh=3A1lONZmc2L40wnJPowdIircP7DAhBfWCyzhVUSzlFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1jHTmqFRb+J37YymjElCmNrBtEQVe1i48m98zhDaQMkeDe5fUXml3zuAhf15ph3C
         Ga4KTJcLBG+mhdAIRSgzUswebP1xPKuS4j4lK5apOHH5tHMN9HoiGqz2jc4lo8xMws
         iJt3QGnY/jjQ3QWv9R1cOe08mjOjJvyhrEDBUShI3Qrdh4ksa99sKOqgMIrbESnVew
         W5m3VDrWILJi0erK4/u7EAcOhfwnWFB0o9jpsnZQJsUoh/PD4FiTWbrS2TvHxjaF5q
         OpUHcNmQgFNcmpTCXaT5rjuUCqQnDg04HBQTh6wJ9+iwsz2NV2kAh/Mbq94PM5HsVv
         gMFcit9CPzVQQ==
Date:   Thu, 22 Apr 2021 08:56:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor
 when STMMAC resume
Message-ID: <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
        <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
        <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
        <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 04:53:08 +0000 Joakim Zhang wrote:
> Could you please help review this patch? It's really beyond my
> comprehension, why this patch would affect Tegra186 Jetson TX2 board?

Looks okay, please repost as non-RFC.
