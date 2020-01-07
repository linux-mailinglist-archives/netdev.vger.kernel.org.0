Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2839C133512
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgAGVmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:42:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgAGVmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:42:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C97B15A17458;
        Tue,  7 Jan 2020 13:42:24 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:42:24 -0800 (PST)
Message-Id: <20200107.134224.1676825160556917131.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     Jose.Abreu@synopsys.com, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        heiko@sntech.de, bot@kernelci.org, sriram.dash@samsung.com
Subject: Re: [PATCH net] net: stmmac: Fixed link does not need MDIO Bus
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5d4a30a5-7af5-7147-11a9-bb5ca3564baa@gmail.com>
References: <5764e60da6d3af7e76c30f63b07f1a12b4787918.1578400471.git.Jose.Abreu@synopsys.com>
        <5d4a30a5-7af5-7147-11a9-bb5ca3564baa@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:42:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 7 Jan 2020 11:05:07 -0800

> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail> # Lamobo R1 (fixed-link +
> MDIO sub node for roboswitch).

Florian please be careful not to let individual tags split into
multiple lines, I had to hand edit the second part of the Tested-by:
tag into the commit message.
