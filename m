Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9198E1B4DC7
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgDVT4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726079AbgDVT4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:56:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43357C03C1A9;
        Wed, 22 Apr 2020 12:56:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBB70120ED563;
        Wed, 22 Apr 2020 12:56:13 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:56:13 -0700 (PDT)
Message-Id: <20200422.125613.448651196314653733.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Add tracepoint support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421074054.23613-1-manivannan.sadhasivam@linaro.org>
References: <20200421074054.23613-1-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:56:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Tue, 21 Apr 2020 13:10:54 +0530

> Add tracepoint support for QRTR with NS as the first candidate. Later on
> this can be extended to core QRTR and transport drivers.
> 
> The trace_printk() used in NS has been replaced by tracepoints.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied to net-next.
