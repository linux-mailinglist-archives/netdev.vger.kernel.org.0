Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0315A1B2B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiHYVgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243882AbiHYVgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2F7C12DA
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:36:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FEC461B77
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 21:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CFCC433C1;
        Thu, 25 Aug 2022 21:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661463371;
        bh=qM3D+zLBMHlKr2gyvH3/gwKfhlw2RCIsgIy8IyMc1Sw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eTXNbPgiqcu/8RO2F9L0h2oJHv00RXo+8rSIqSlNGK5t6JXuXQt/touIkqDWdD+wC
         Q6q+U1KhFngjufhEyAn/TC3aLqXqTRiJ9CqHberbH3thP9TcUjPnz41BEPpnNmDZ3q
         7ZJWu1I1K2B0wcD5QjG7zI41QEcguaRSdkpxBk1uLF3FtcxYXj+OnsyJQK6UEHQsbA
         vS2mHbT5rED80dkHRIMp9g8lhHwl2sS8T/FSJ36EWIoj6r+bE9XDeSU6xRpTOEJ5La
         oI7ZgBtKqtFe92jebVMdQEev3/vMaAzjJ+DqkmQ5RMUHeBokkDN8pjSrDTTwlL1qgL
         OEj5gJAkeL1FQ==
Date:   Thu, 25 Aug 2022 14:36:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220825143610.4f13f730@kernel.org>
In-Reply-To: <cover.1661260787.git.leonro@nvidia.com>
References: <cover.1661260787.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 16:31:57 +0300 Leon Romanovsky wrote:
>  * I didn't hear any suggestion what term to use instead of
>    "full offload", so left it as is. It is used in commit messages
>    and documentation only and easy to rename.
>  * Added performance data and background info to cover letter
>  * Reused xfrm_output_resume() function to support multiple XFRM transformations
>  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
>  * Documentation is in progress, but not part of this series yet.

Since the use case is somewhat in question, perhaps switch to RFC
postings until the drivers side incl. tc forwarding is implemented?
Also the perf traces, I don't see them here.
