Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1897A137747
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgAJTcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:32:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39992 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbgAJTcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:32:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E9CA1577F52F;
        Fri, 10 Jan 2020 11:32:24 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:32:23 -0800 (PST)
Message-Id: <20200110.113223.993180749814320634.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: stmmac: Filtering fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1578669661.git.Jose.Abreu@synopsys.com>
References: <cover.1578669661.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 11:32:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri, 10 Jan 2020 16:23:51 +0100

> Two single fixes for the L3 and L4 filtering in stmmac.
> 
> 1) Updates the internal status of RSS when disabling it in order to keep
> internal driver status consistent.
> 
> 2) Do not lets user add a filter if RSS is enabled because the filter will
> not work correctly as RSS bypasses this mechanism.

Series applied and queued up for v5.4 -stable, thanks.
