Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9CE133504
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgAGVjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:39:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgAGVja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:39:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8778715A17441;
        Tue,  7 Jan 2020 13:39:29 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:39:29 -0800 (PST)
Message-Id: <20200107.133929.478761725654377944.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com, corbet@lwn.net,
        mcoquelin.stm32@gmail.com, linux-doc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Documentation: stmmac documentation
 improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1578392890.git.Jose.Abreu@synopsys.com>
References: <cover.1578392890.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:39:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue,  7 Jan 2020 11:37:17 +0100

> [ Not sure if this should go for net-next or Documentation tree. ]
> 
> Converts stmmac documentation to RST format.
> 
> 1) Adds missing entry of stmmac documentation to MAINTAINERS.
> 
> 2) Converts stmmac documentation to RST format and adds some new info.
> 
> 3) Adds the new RST file to the list of files.

Series applied to net-next, thanks Jose.
