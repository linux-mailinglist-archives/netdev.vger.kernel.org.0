Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7492137729
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgAJTa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:30:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39962 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgAJTa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:30:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDB801577F51F;
        Fri, 10 Jan 2020 11:30:24 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:30:24 -0800 (PST)
Message-Id: <20200110.113024.2292445373481219663.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: stmmac: Frame Preemption fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1578669088.git.Jose.Abreu@synopsys.com>
References: <cover.1578669088.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 11:30:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri, 10 Jan 2020 16:13:33 +0100

> Two single fixes for the -next tree for recently introduced Frame Preemption
> feature.
> 
> 1) and 2) fixes the disabling of Frame Preemption that was not being correctly
> handled because of a missing return.

Series applied, thanks.
