Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A217BD8B8C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732080AbfJPInf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:43:35 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:41653 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfJPIne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 04:43:34 -0400
Received: from [167.98.27.226] (helo=[10.35.5.173])
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKeu2-0000B8-Ev; Wed, 16 Oct 2019 09:43:30 +0100
Subject: Re: [PATCH] net: stmmac: fix argument to stmmac_pcs_ctrl_ane()
To:     linux-kernel@lists.codethink.co.uk
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191016082205.26899-1-ben.dooks@codethink.co.uk>
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
Message-ID: <27111986-1fc4-534d-9cd8-65bcab94a840@codethink.co.uk>
Date:   Wed, 16 Oct 2019 09:43:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016082205.26899-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/10/2019 09:22, Ben Dooks (Codethink) wrote:
> The stmmac_pcs_ctrl_ane() expects a register address as
> argument 1, but for some reason the mac_device_info is
> being passed.
> 
> Fix the warning (and possible bug) from sparse:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    expected void [noderef] <asn:2> *ioaddr
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    got struct mac_device_info *hw

apologies, looks like I reposted this by accident.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html
