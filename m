Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8504A69E87A
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 20:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjBUTlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 14:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjBUTlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 14:41:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D764E2E80C;
        Tue, 21 Feb 2023 11:41:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D339611B3;
        Tue, 21 Feb 2023 19:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C8AC433EF;
        Tue, 21 Feb 2023 19:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677008459;
        bh=eYLLW5S3Lj0DfJGoQXiq8cvFhX8POKnoMCP9k1pGSvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eVb89wVeLoZIphCUnqK8cj8jMop3IR9+3QChT71az41oS9ofu5w/z/BkhbiJ4e303
         +rCySsaZGqAYdNOQ3BwDDH9e0AILMmJ8DSWJdtOAuEtTxEccsDeTEsv8sw/xUrTo5N
         TbvBt1+87H7HA4Yfzdd0gML+HB9zjyNGwY6jXB7hMkXD/AZ4E+YeEDJciKjEYG7cVV
         Y6MU89pWb9X6LAV5kZ7dTkAQlVAw53c4tP8bLlw0WRocTDX/Dp5YZnj244mWnaQwG2
         6qz7y67AuafRORCs6QX6ukbx5mCiFI6T5zrp5dYpRo7V59ftuNf7gPPiAmZoZ9BtpA
         yOC8V2od/uikQ==
Date:   Tue, 21 Feb 2023 11:40:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2] net: stmmac: Premature loop termination check
 was ignored
Message-ID: <20230221114058.5775664d@kernel.org>
In-Reply-To: <877cwa7qtm.fsf@henneberg-systemdesign.com>
References: <87fsaz6smr.fsf@henneberg-systemdesign.com>
        <Y/T0NRtorZn74EH3@corigine.com>
        <877cwa7qtm.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Feb 2023 20:35:25 +0100 Jochen Henneberg wrote:
> The premature loop termination check makes sense only in case of the
> jump to read_again where the count may have been updated. But
> read_again did not include the check.
> 
> Fixes: bba2556efad6 (net: stmmac: Enable RX via AF_XDP zero-copy)
> Fixes: ec222003bd94 (net: stmmac: Prepare to add Split Header support)
> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>

Please repost separately, not as a reply. Patch tracking utilities 
will categorize emails with Re in the subject as comments rather 
than submissions.
