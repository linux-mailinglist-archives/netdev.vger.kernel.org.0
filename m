Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE9F211607
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgGAW3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAW3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:29:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FCFC08C5C1;
        Wed,  1 Jul 2020 15:29:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2DE41495921C;
        Wed,  1 Jul 2020 15:29:20 -0700 (PDT)
Date:   Wed, 01 Jul 2020 15:29:20 -0700 (PDT)
Message-Id: <20200701.152920.1650710079381098871.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: ipa: small improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630125846.1281988-1-elder@linaro.org>
References: <20200630125846.1281988-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 15:29:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Tue, 30 Jun 2020 07:58:43 -0500

> This series contains two patches that improve the error output
> that's reported when an error occurs while changing the state of a
> GSI channel or event ring.  The first ensures all such error
> conditions report an error, and the second simplifies the messages a
> little and ensures they are all consistent.
> 
> A third (independent) patch gets rid of an unused symbol in the
> microcontroller code.
> 
> Version 2 fixes two alignment problems pointed out by checkpatch.pl,
> as requested by Jakub Kicinski.

Series applied.
