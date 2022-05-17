Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C58452A697
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349986AbiEQPaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbiEQPaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D884F9C8;
        Tue, 17 May 2022 08:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50BAF60B8B;
        Tue, 17 May 2022 15:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEE1C385B8;
        Tue, 17 May 2022 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652801403;
        bh=1z4+aRsUje0J9eCxSE/M8CluHxB3pLVHNWKNJDnanBs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AtX2dguJhHE0cWfPqNxTyEl527o65mrW8uGIQLSoSByEwEkHoN+xUvBif11Nc+5sb
         L1dDX2lRuP9K/R0S9ozPqImQ6dG0BYv/RdJHZROn5m/YDbTQ5v6yzsVCPaFPSGRUi0
         VmnUIhSneeyFkyToUIESoeo8mWKyLWGbjZqIZBiezHu0PDpe81gicQRpUpz7aB8tJF
         07RJn0E6rS7awqbtnceGH8iQJjgwqQc6EKC3bL6xojZILxpPJAEGhb7A8MEdVzbyPp
         dISVdIZ9ix7xQ9U0IXq4k0BTNjmu57dlH9AIVSE81giPElk6+iyl0S0FmvX3a5wN2y
         Nh0bKIn+VhRTA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: Fix Makefile to be in alphabetical order
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <MA1PR01MB26992E104B006B340C3C3A84C1CA9@MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM>
References: <MA1PR01MB26992E104B006B340C3C3A84C1CA9@MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM>
To:     Srinivasan R <srinir@outlook.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Srinivasan R <srinir@outlook.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Srinivasan R <srinir@outlook.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165280139864.3650.6325168867367666102.kvalo@kernel.org>
Date:   Tue, 17 May 2022 15:30:01 +0000 (UTC)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan R <srinir@outlook.com> wrote:

> Fix quantenna to be in the right order
> 
> Signed-off-by: Srinivasan R <srinir@outlook.com>

Patch applied to wireless-next.git, thanks.

8762246c7b23 wireless: Fix Makefile to be in alphabetical order

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/MA1PR01MB26992E104B006B340C3C3A84C1CA9@MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

