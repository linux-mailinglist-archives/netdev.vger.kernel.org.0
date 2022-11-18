Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C44762EC1A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 03:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbiKRCuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 21:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiKRCt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 21:49:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129E119001;
        Thu, 17 Nov 2022 18:49:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A469A62312;
        Fri, 18 Nov 2022 02:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B09C433D6;
        Fri, 18 Nov 2022 02:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668739797;
        bh=OQmYBT6P/2H3zDKUuL1fe32vXFPlDlBRe16RHFc1eoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nN1z2tvRBiLyKjsys3UI6W9oq47wakCVQfdQAiddMlt0JA9JbtsMRdJYzk1FQLUeH
         7xs3kQdiWRxpwtzbvxhOcq/Y7fGhgyUDBwqZF3pPhdMY6OshBLMTLWA0qNhnmQhPSd
         SBcNof4Z4qATlaEDIfClS/uP2y6j3qI6pS1XqCvrV/ox6grGCTu9+nqeY1w/J1B9eh
         Gt1th5G1WpdJJX9nD08BKwOEdT0u22IudI0e4tINleQZozxFViXtulLfMFVVGXBjuY
         PU2uMIwppQBP6PHYo1UVtZVzMyedYb91YlkjCqevoDQnV2MVlxREARzNqv33jaR99R
         dcQEPqNfeiRgQ==
Date:   Thu, 17 Nov 2022 18:49:55 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macsec: Fix invalid error code set
Message-ID: <Y3by04Dy3RRBkRr7@x130.lan>
References: <20221118011249.48112-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221118011249.48112-1-yuehaibing@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18 Nov 09:12, YueHaibing wrote:
>'ret' is defined twice in macsec_changelink(), when it is set in macsec_is_offloaded
>case, it will be invalid before return.
>
>Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
>Signed-off-by: YueHaibing <yuehaibing@huawei.com>

I have the same exact patch lined up in my internal queue.
this needs to go to net: so for next time please tag [PATCH net].

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

