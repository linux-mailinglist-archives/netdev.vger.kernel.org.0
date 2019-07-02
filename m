Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E202C5D5F2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGBSNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:13:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBSNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:13:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D993512D8E26B;
        Tue,  2 Jul 2019 11:13:12 -0700 (PDT)
Date:   Tue, 02 Jul 2019 11:13:12 -0700 (PDT)
Message-Id: <20190702.111312.2060711055112197124.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Subject: Re: [PATCH net-next] net: stmmac: Re-word Kconfig entry
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eac9ac857255993581bec265fb5ce7e3bdd20c78.1562058669.git.joabreu@synopsys.com>
References: <eac9ac857255993581bec265fb5ce7e3bdd20c78.1562058669.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 11:13:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue,  2 Jul 2019 11:12:10 +0200

> We support many speeds and it doesn't make much sense to list them all
> in the Kconfig. Let's just call it Multi-Gigabit.
> 
> Suggested-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied.
