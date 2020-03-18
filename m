Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33CA1894FA
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCREhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:37:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgCREhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:37:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B979120F52AA;
        Tue, 17 Mar 2020 21:37:51 -0700 (PDT)
Date:   Tue, 17 Mar 2020 21:37:50 -0700 (PDT)
Message-Id: <20200317.213750.1737351964613250216.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next 0/4] net: stmmac: 100GB Enterprise MAC support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584436401.git.Jose.Abreu@synopsys.com>
References: <cover.1584436401.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 21:37:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue, 17 Mar 2020 10:18:49 +0100

> Adds the support for Enterprise MAC IP version which allows operating
> speeds up to 100GB.
> 
> Patch 1/4, adds the support in XPCS for XLGMII interface that is used in
> this kind of Enterprise MAC IPs.
> 
> Patch 2/4, adds the XLGMII interface support in stmmac.
> 
> Patch 3/4, adds the HW specific support for Enterprise MAC.
> 
> We end in patch 4/4, by updating stmmac documentation to mention the
> support for this new IP version.

Series applied, thank you.
