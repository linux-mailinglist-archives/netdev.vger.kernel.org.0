Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB372B05C5
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfIKWuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:50:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfIKWuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 18:50:35 -0400
Received: from localhost (unknown [88.214.186.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 594FE154FCEC3;
        Wed, 11 Sep 2019 15:50:33 -0700 (PDT)
Date:   Thu, 12 Sep 2019 00:50:31 +0200 (CEST)
Message-Id: <20190912.005031.1882887947559838557.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: pci: Add HAPS support using GMAC5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c37a55225e1ef66233b47c02b1441b91abeb3b76.1568047994.git.joabreu@synopsys.com>
References: <c37a55225e1ef66233b47c02b1441b91abeb3b76.1568047994.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 15:50:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon,  9 Sep 2019 18:54:26 +0200

> Add the support for Synopsys HAPS board that uses GMAC5.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied.
