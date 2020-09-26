Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F02279C23
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgIZTct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgIZTct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 15:32:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D175C0613CE;
        Sat, 26 Sep 2020 12:32:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12AB81299FC82;
        Sat, 26 Sep 2020 12:16:00 -0700 (PDT)
Date:   Sat, 26 Sep 2020 12:32:43 -0700 (PDT)
Message-Id: <20200926.123243.339674534364184510.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     loic.poulain@linaro.org, hemantk@codeaurora.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 2/2] net: qrtr: Start MHI channels during init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926075656.GE9302@linux>
References: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
        <1600674184-3537-2-git-send-email-loic.poulain@linaro.org>
        <20200926075656.GE9302@linux>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 26 Sep 2020 12:16:00 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Sat, 26 Sep 2020 13:26:56 +0530

> On Mon, Sep 21, 2020 at 09:43:04AM +0200, Loic Poulain wrote:
>> Start MHI device channels so that transfers can be performed.
>> The MHI stack does not auto-start channels anymore.
>> 
>> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Dave: I'd like to queue this patch through MHI tree because there is a dependent
> change in MHI bus. So, can you please provide your Ack?

Sure:

Acked-by: David S. Miller <davem@davemloft.net>
