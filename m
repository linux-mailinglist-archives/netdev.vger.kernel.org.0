Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6719B569
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbgDASZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:25:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732316AbgDASZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:25:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20FEE120F5284;
        Wed,  1 Apr 2020 11:25:43 -0700 (PDT)
Date:   Wed, 01 Apr 2020 11:25:42 -0700 (PDT)
Message-Id: <20200401.112542.1191455491464437178.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: Fix VLAN filtering when HW does
 not support it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <42e493820f707c5a5d3375676ef6b6a96988f846.1585762111.git.Jose.Abreu@synopsys.com>
References: <42e493820f707c5a5d3375676ef6b6a96988f846.1585762111.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Apr 2020 11:25:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Wed,  1 Apr 2020 19:29:03 +0200

> If we don't have any filters available we can't rely upon the return
> code of stmmac_add_hw_vlan_rx_fltr() / stmmac_del_hw_vlan_rx_fltr(). Add
> a check for this.
> 
> Fixes: ed64639bc1e0 ("net: stmmac: Add support for VLAN Rx filtering")
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

Applied.
