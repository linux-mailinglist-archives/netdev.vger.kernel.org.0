Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC8B1DDB9B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbgEVAFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEVAFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:05:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784B6C061A0E;
        Thu, 21 May 2020 17:05:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CF83120ED486;
        Thu, 21 May 2020 17:05:39 -0700 (PDT)
Date:   Thu, 21 May 2020 17:05:38 -0700 (PDT)
Message-Id: <20200521.170538.966530806675679298.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Fix passing invalid reference to
 qrtr_local_enqueue()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519181416.4235-1-manivannan.sadhasivam@linaro.org>
References: <20200519181416.4235-1-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:05:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Tue, 19 May 2020 23:44:16 +0530

> Once the traversal of the list is completed with list_for_each_entry(),
> the iterator (node) will point to an invalid object. So passing this to
> qrtr_local_enqueue() which is outside of the iterator block is erroneous
> eventhough the object is not used.
> 
> So fix this by passing NULL to qrtr_local_enqueue().
> 
> Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied and queued up for -stable, thanks.
