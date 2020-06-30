Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B55210036
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgF3Wt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgF3Wtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:49:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90254C061755;
        Tue, 30 Jun 2020 15:49:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8320F127BE1A0;
        Tue, 30 Jun 2020 15:49:53 -0700 (PDT)
Date:   Tue, 30 Jun 2020 15:49:52 -0700 (PDT)
Message-Id: <20200630.154952.639740134458057752.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: ipa: head-of-line block registers
 are RX only
From:   David Miller <davem@davemloft.net>
In-Reply-To: <95f96c77-6dce-8626-9951-124610cf4c31@linaro.org>
References: <825816f3-5797-bbcf-571b-c6a7a6821397@linaro.org>
        <20200630.122114.69420116631257185.davem@davemloft.net>
        <95f96c77-6dce-8626-9951-124610cf4c31@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 15:49:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Tue, 30 Jun 2020 17:41:44 -0500

> My point was to try to isolate the damage done to the IPA device and
> driver, rather than killing the system.

Excellent, then we are both on the same page.
