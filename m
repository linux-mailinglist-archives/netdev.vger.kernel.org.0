Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3581F543571
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbiFHOvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243195AbiFHOsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:48:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE2826E287
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 07:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD74561BBD
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 14:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8362C3411E;
        Wed,  8 Jun 2022 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654699673;
        bh=ksOFFDKZVcX796aqyxqCznb2tOO7u1HD4iu+iuimyFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ozmHHYWXWJ+m4ivnIWQ99kvEEUUQrs2z2QY0yDXjynjDBy+jiKLnLv3hFpXG8nXEm
         GGKol1xpWMor4YnmdQWllDK7D2DADgZRVApIv9RG5YVIP1/vziBjEVh0Zez25R2h7j
         dOi6AIBeAq5+Lg3f6R9AbKq6tpgcnoWumjEbW0WlI2348paVVaowBSF0zBu8piZqqX
         ++/EaRuLpvNalukbBfmZy+ZAHpfTamt7TJ7mWlO84yNjT5YzUHo5Qd0/vSjEeAzVop
         SQFleWEW8GT5R6GoT3tllHG8QAw5OrFkl5wEwvn1u7j8A3iqE2sNEpXOWTPqIUB8nV
         g9Tii5yD3d4+g==
Date:   Wed, 8 Jun 2022 07:47:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net] tls: Rename TLS_INFO_ZC_SENDFILE to TLS_INFO_ZC_TX
Message-ID: <20220608074751.09f29e7f@kernel.org>
In-Reply-To: <20220608112236.3131958-1-maximmi@nvidia.com>
References: <20220608112236.3131958-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jun 2022 14:22:36 +0300 Maxim Mikityanskiy wrote:
> To embrace possible future optimizations of TLS, rename zerocopy
> sendfile definitions to more generic ones:
> 
> * setsockopt: TLS_TX_ZEROCOPY_SENDFILE- > TLS_TX_ZEROCOPY
> * sock_diag: TLS_INFO_ZC_SENDFILE -> TLS_INFO_ZC_TX

Why don't we throw in the _RO as well if we're renaming?
