Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8505A1C7B84
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbgEFUuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729263AbgEFUuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:50:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159B3C061A0F;
        Wed,  6 May 2020 13:50:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A519120F5281;
        Wed,  6 May 2020 13:50:10 -0700 (PDT)
Date:   Wed, 06 May 2020 13:50:09 -0700 (PDT)
Message-Id: <20200506.135009.482598843321032652.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clew@codeaurora.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: qrtr: Add MHI transport layer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506045015.13421-1-manivannan.sadhasivam@linaro.org>
References: <20200506045015.13421-1-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 13:50:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Also when you resubmit, please provide a proper introduction posting
that explains what the patch series does, how it does it, and why
it is doing it that way.

Thanks.
