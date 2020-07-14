Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222CB21E45B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGNAMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNAMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:12:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC8BC061755;
        Mon, 13 Jul 2020 17:12:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01C7512981398;
        Mon, 13 Jul 2020 17:12:05 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:12:05 -0700 (PDT)
Message-Id: <20200713.171205.730061541247000028.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: fix kerneldoc comments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713122418.505734-1-elder@linaro.org>
References: <20200713122418.505734-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:12:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon, 13 Jul 2020 07:24:18 -0500

> This commit affects comments (and in one case, whitespace) only.
> 
> Throughout the IPA code, return statements are documented using
> "@Return:", whereas they should use "Return:" instead.  Fix these
> mistakes.
> 
> In function definitions, some parameters are missing their comment
> to describe them.  And in structure definitions, some fields are
> missing their comment to describe them.  Add these missing
> descriptions.
> 
> Some arguments changed name and type along the way, but their
> descriptions were not updated (an endpoint pointer is now used in
> many places that previously used an endpoint ID).  Fix these
> incorrect parameter descriptions.
> 
> In the description for the ipa_clock structure, one field had a
> semicolon instead of a colon in its description.  Fix this.
> 
> Add a missing function description for ipa_gsi_endpoint_data_empty().
> 
> All of these issues were identified when building with "W=1".
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied, thanks Alex.
