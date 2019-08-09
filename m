Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BFE88370
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfHIToi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:44:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIToi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:44:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CBA1142CC45D;
        Fri,  9 Aug 2019 12:44:38 -0700 (PDT)
Date:   Fri, 09 Aug 2019 12:44:37 -0700 (PDT)
Message-Id: <20190809.124437.700825515396914245.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com
Subject: Re: [PATCH net-next 04/12] net: stmmac: Add Split Header support
 and enable it in XGMAC cores
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c85acbe21eaf8ed11ceffe8adcae9ddf2643d66e.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
        <cover.1565375521.git.joabreu@synopsys.com>
        <c85acbe21eaf8ed11ceffe8adcae9ddf2643d66e.1565375521.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 12:44:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri,  9 Aug 2019 20:36:12 +0200

> Add the support for Split Header feature in the RX path and enable it in
> XGMAC cores.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Well, what is the performance advantage/disadvantage of this mode?  Show
some numbers please to justify the use of the feature.
